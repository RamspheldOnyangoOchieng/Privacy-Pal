

actor class CacheCanister {
    // State variables
    private stable var cacheEntries = HashMap.new<Text, Types.CacheEntry>();
    private stable var cacheStats = HashMap.new<Text, Types.CacheStats>();
    private stable var cacheHistory = HashMap.new<Text, Types.CacheHistory>();

    // Private helper functions
    private func generateEntryId() : Text {
        "cache_" # Nat.toText(Time.now())
    };

    private func validateCacheEntry(entry : Types.CacheEntry) : Bool {
        Utils.isNotEmpty(entry.fileId) and
        Utils.isValidCacheTTL(entry.ttl) and
        Utils.isValidCacheSize(entry.size)
    };

    private func updateCacheStats(fileId : Text, action : Types.CacheAction) : () {
        let stats = switch (HashMap.get(cacheStats, Text.equal, fileId)) {
            case (?s) { s };
            case null {
                {
                    fileId = fileId;
                    hits = 0;
                    misses = 0;
                    evictions = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedStats = switch (action) {
            case (#hit) { { stats with hits = stats.hits + 1 } };
            case (#miss) { { stats with misses = stats.misses + 1 } };
            case (#evict) { { stats with evictions = stats.evictions + 1 } }
        };
        HashMap.put(cacheStats, Text.equal, fileId, updatedStats)
    };

    private func logCacheHistory(fileId : Text, action : Types.CacheAction, userId : Text) : () {
        let historyId = generateEntryId();
        let history = {
            id = historyId;
            fileId = fileId;
            userId = userId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(cacheHistory, Text.equal, historyId, history)
    };

    // Public shared functions
    public shared(msg) func cacheFile(fileId : Text, ttl : Nat, size : Nat) : async Result.Result<Text, Text> {
        let entryId = generateEntryId();
        let entry = {
            id = entryId;
            fileId = fileId;
            ttl = ttl;
            size = size;
            createdAt = Time.now();
            expiresAt = Time.now() + ttl
        };
        if (not validateCacheEntry(entry)) {
            return #err(Constants.ERROR_INVALID_CACHE_ENTRY)
        };
        HashMap.put(cacheEntries, Text.equal, entryId, entry);
        updateCacheStats(fileId, #hit);
        logCacheHistory(fileId, #hit, Principal.toText(msg.caller));
        #ok(entryId)
    };

    public shared(msg) func getCachedFile(fileId : Text) : async Result.Result<Types.CacheEntry, Text> {
        switch (HashMap.get(cacheEntries, Text.equal, fileId)) {
            case (?entry) {
                if (Time.now() > entry.expiresAt) {
                    HashMap.delete(cacheEntries, Text.equal, fileId);
                    updateCacheStats(fileId, #miss);
                    logCacheHistory(fileId, #miss, Principal.toText(msg.caller));
                    #err(Constants.ERROR_CACHE_ENTRY_EXPIRED)
                } else {
                    updateCacheStats(fileId, #hit);
                    logCacheHistory(fileId, #hit, Principal.toText(msg.caller));
                    #ok(entry)
                }
            };
            case null {
                updateCacheStats(fileId, #miss);
                logCacheHistory(fileId, #miss, Principal.toText(msg.caller));
                #err(Constants.ERROR_CACHE_ENTRY_NOT_FOUND)
            }
        }
    };

    public shared(msg) func evictCachedFile(fileId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(cacheEntries, Text.equal, fileId)) {
            case (?entry) {
                HashMap.delete(cacheEntries, Text.equal, fileId);
                updateCacheStats(fileId, #evict);
                logCacheHistory(fileId, #evict, Principal.toText(msg.caller));
                #ok()
            };
            case null { #err(Constants.ERROR_CACHE_ENTRY_NOT_FOUND) }
        }
    };

    public shared(msg) func updateCacheTTL(fileId : Text, ttl : Nat) : async Result.Result<(), Text> {
        switch (HashMap.get(cacheEntries, Text.equal, fileId)) {
            case (?entry) {
                let updatedEntry = {
                    entry with
                    ttl = ttl;
                    expiresAt = Time.now() + ttl
                };
                if (not validateCacheEntry(updatedEntry)) {
                    return #err(Constants.ERROR_INVALID_CACHE_ENTRY)
                };
                HashMap.put(cacheEntries, Text.equal, fileId, updatedEntry);
                #ok()
            };
            case null { #err(Constants.ERROR_CACHE_ENTRY_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getCacheStats(fileId : Text) : async ?Types.CacheStats {
        HashMap.get(cacheStats, Text.equal, fileId)
    };

    public query func getCacheHistory() : async [Types.CacheHistory] {
        let history = HashMap.entries(cacheHistory);
        Array.map(history, func((id, h) : (Text, Types.CacheHistory)) : Types.CacheHistory { h })
    };

    public query func getCacheHistoryByFile(fileId : Text) : async [Types.CacheHistory] {
        let history = HashMap.entries(cacheHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CacheHistory)) : Bool {
            h.fileId == fileId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CacheHistory)) : Types.CacheHistory { h })
    };

    public query func getCacheHistoryByUser(userId : Text) : async [Types.CacheHistory] {
        let history = HashMap.entries(cacheHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CacheHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CacheHistory)) : Types.CacheHistory { h })
    };

    public query func getCacheHistoryByAction(action : Types.CacheAction) : async [Types.CacheHistory] {
        let history = HashMap.entries(cacheHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CacheHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CacheHistory)) : Types.CacheHistory { h })
    };

    public query func getCacheHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.CacheHistory] {
        let history = HashMap.entries(cacheHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CacheHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CacheHistory)) : Types.CacheHistory { h })
    };
}; 