

actor class CacheCanister() {
    // State variables
    private stable var cache : HashMap.HashMap<Text, CacheEntry> = HashMap.new();
    private stable var cacheStats : HashMap.HashMap<Text, CacheStats> = HashMap.new();
    private stable var cachePolicies : HashMap.HashMap<Text, CachePolicy> = HashMap.new();
    private stable var distributedCache : HashMap.HashMap<Text, DistributedCacheEntry> = HashMap.new();
    private stable var cacheWarmupQueue : Buffer.Buffer<CacheWarmupRequest> = Buffer.Buffer(0);
    private stable var invalidationRules : HashMap.HashMap<Text, InvalidationRule> = HashMap.new();

    // Types
    type CacheEntry = {
        value : Blob;
        expiry : Time.Time;
        lastAccessed : Time.Time;
        accessCount : Nat;
        tags : [Text];
        version : Nat;
    };

    type CacheStats = {
        hits : Nat;
        misses : Nat;
        evictions : Nat;
        size : Nat;
        lastUpdated : Time.Time;
    };

    type CachePolicy = {
        maxSize : Nat;
        ttl : Nat; // Time to live in seconds
        evictionStrategy : EvictionStrategy;
        compressionEnabled : Bool;
        priority : Nat;
    };

    type EvictionStrategy = {
        #LRU; // Least Recently Used
        #LFU; // Least Frequently Used
        #FIFO; // First In First Out
        #TTL; // Time To Live
    };

    type DistributedCacheEntry = {
        value : Blob;
        expiry : Time.Time;
        version : Nat;
        nodes : [Principal];
        consistencyLevel : ConsistencyLevel;
    };

    type ConsistencyLevel = {
        #STRONG;
        #EVENTUAL;
        #CAUSAL;
    };

    type CacheWarmupRequest = {
        key : Text;
        value : Blob;
        priority : Nat;
        timestamp : Time.Time;
    };

    type InvalidationRule = {
        pattern : Text;
        strategy : InvalidationStrategy;
        dependencies : [Text];
    };

    type InvalidationStrategy = {
        #IMMEDIATE;
        #LAZY;
        #SCHEDULED;
    };

    // Private helper functions
    private func generateCacheKey(prefix : Text, id : Text) : Text {
        prefix # ":" # id;
    };

    private func shouldEvict(entry : CacheEntry, policy : CachePolicy) : Bool {
        switch (policy.evictionStrategy) {
            case (#LRU) {
                Time.now() - entry.lastAccessed > policy.ttl * 1_000_000_000;
            };
            case (#LFU) {
                entry.accessCount < 5; // Example threshold
            };
            case (#FIFO) {
                Time.now() - entry.lastAccessed > policy.ttl * 1_000_000_000;
            };
            case (#TTL) {
                Time.now() > entry.expiry;
            };
        };
    };

    private func updateCacheStats(key : Text, isHit : Bool) {
        let stats = Option.get(HashMap.get(cacheStats, Principal.equal, Principal.hash, key), {
            hits = 0;
            misses = 0;
            evictions = 0;
            size = 0;
            lastUpdated = Time.now();
        });

        let updatedStats = {
            stats with
            hits = if (isHit) { stats.hits + 1 } else { stats.hits };
            misses = if (not isHit) { stats.misses + 1 } else { stats.misses };
            lastUpdated = Time.now();
        };

        ignore HashMap.put(cacheStats, Principal.equal, Principal.hash, key, updatedStats);
    };

    private func processCacheWarmup() {
        let now = Time.now();
        let warmupRequests = Buffer.toArray(cacheWarmupQueue);
        Buffer.clear(cacheWarmupQueue);

        for (request in warmupRequests.vals()) {
            if (now - request.timestamp < 300_000_000_000) { // 5 minutes
                let policy = Option.get(HashMap.get(cachePolicies, Principal.equal, Principal.hash, request.key), {
                    maxSize = 1000;
                    ttl = 3600;
                    evictionStrategy = #LRU;
                    compressionEnabled = false;
                    priority = 1;
                });

                let entry = {
                    value = request.value;
                    expiry = now + policy.ttl * 1_000_000_000;
                    lastAccessed = now;
                    accessCount = 0;
                    tags = [];
                    version = 1;
                };

                ignore HashMap.put(cache, Principal.equal, Principal.hash, request.key, entry);
            };
        };
    };

    private func invalidateCache(key : Text, rule : InvalidationRule) {
        switch (rule.strategy) {
            case (#IMMEDIATE) {
                ignore HashMap.remove(cache, Principal.equal, Principal.hash, key);
                // Invalidate dependencies
                for (dep in rule.dependencies.vals()) {
                    ignore HashMap.remove(cache, Principal.equal, Principal.hash, dep);
                };
            };
            case (#LAZY) {
                // Mark for lazy invalidation
                let entry = Option.get(HashMap.get(cache, Principal.equal, Principal.hash, key), {
                    value = Blob.fromArray([]);
                    expiry = Time.now();
                    lastAccessed = Time.now();
                    accessCount = 0;
                    tags = [];
                    version = 1;
                });
                ignore HashMap.put(cache, Principal.equal, Principal.hash, key, {
                    entry with
                    expiry = Time.now() + 60_000_000_000; // 1 minute
                });
            };
            case (#SCHEDULED) {
                // Schedule invalidation
                let entry = Option.get(HashMap.get(cache, Principal.equal, Principal.hash, key), {
                    value = Blob.fromArray([]);
                    expiry = Time.now();
                    lastAccessed = Time.now();
                    accessCount = 0;
                    tags = [];
                    version = 1;
                });
                ignore HashMap.put(cache, Principal.equal, Principal.hash, key, {
                    entry with
                    expiry = Time.now() + 300_000_000_000; // 5 minutes
                });
            };
        };
    };

    // Public shared functions
    public shared(msg) func set(key : Text, value : Blob, policy : CachePolicy) : async () {
        let entry = {
            value = value;
            expiry = Time.now() + policy.ttl * 1_000_000_000;
            lastAccessed = Time.now();
            accessCount = 0;
            tags = [];
            version = 1;
        };

        ignore HashMap.put(cache, Principal.equal, Principal.hash, key, entry);
        ignore HashMap.put(cachePolicies, Principal.equal, Principal.hash, key, policy);
    };

    public shared(msg) func get(key : Text) : async ?Blob {
        switch (HashMap.get(cache, Principal.equal, Principal.hash, key)) {
            case (?entry) {
                if (Time.now() > entry.expiry) {
                    ignore HashMap.remove(cache, Principal.equal, Principal.hash, key);
                    updateCacheStats(key, false);
                    null;
                } else {
                    let policy = Option.get(HashMap.get(cachePolicies, Principal.equal, Principal.hash, key), {
                        maxSize = 1000;
                        ttl = 3600;
                        evictionStrategy = #LRU;
                        compressionEnabled = false;
                        priority = 1;
                    });

                    if (shouldEvict(entry, policy)) {
                        ignore HashMap.remove(cache, Principal.equal, Principal.hash, key);
                        updateCacheStats(key, false);
                        null;
                    } else {
                        let updatedEntry = {
                            entry with
                            lastAccessed = Time.now();
                            accessCount = entry.accessCount + 1;
                        };
                        ignore HashMap.put(cache, Principal.equal, Principal.hash, key, updatedEntry);
                        updateCacheStats(key, true);
                        ?entry.value;
                    };
                };
            };
            case null {
                updateCacheStats(key, false);
                null;
            };
        };
    };

    public shared(msg) func setDistributed(key : Text, value : Blob, nodes : [Principal], consistencyLevel : ConsistencyLevel) : async () {
        let entry = {
            value = value;
            expiry = Time.now() + 3600 * 1_000_000_000; // 1 hour
            version = 1;
            nodes = nodes;
            consistencyLevel = consistencyLevel;
        };

        ignore HashMap.put(distributedCache, Principal.equal, Principal.hash, key, entry);
    };

    public shared(msg) func getDistributed(key : Text) : async ?Blob {
        switch (HashMap.get(distributedCache, Principal.equal, Principal.hash, key)) {
            case (?entry) {
                if (Time.now() > entry.expiry) {
                    ignore HashMap.remove(distributedCache, Principal.equal, Principal.hash, key);
                    null;
                } else {
                    ?entry.value;
                };
            };
            case null { null };
        };
    };

    public shared(msg) func queueCacheWarmup(key : Text, value : Blob, priority : Nat) : async () {
        let request = {
            key = key;
            value = value;
            priority = priority;
            timestamp = Time.now();
        };
        Buffer.add(cacheWarmupQueue, request);
    };

    public shared(msg) func setInvalidationRule(key : Text, rule : InvalidationRule) : async () {
        ignore HashMap.put(invalidationRules, Principal.equal, Principal.hash, key, rule);
    };

    public shared(msg) func invalidate(key : Text) : async () {
        switch (HashMap.get(invalidationRules, Principal.equal, Principal.hash, key)) {
            case (?rule) {
                invalidateCache(key, rule);
            };
            case null {
                // Default to immediate invalidation
                ignore HashMap.remove(cache, Principal.equal, Principal.hash, key);
            };
        };
    };

    public query func getCacheStats(key : Text) : async ?CacheStats {
        HashMap.get(cacheStats, Principal.equal, Principal.hash, key);
    };

    public query func getCachePolicy(key : Text) : async ?CachePolicy {
        HashMap.get(cachePolicies, Principal.equal, Principal.hash, key);
    };
}; 