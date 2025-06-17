

actor class RateLimitingCanister() {
    // State variables
    private stable var rateLimits : HashMap.HashMap<Principal, RateLimit> = HashMap.new();
    private stable var quotas : HashMap.HashMap<Principal, Quota> = HashMap.new();
    private stable var blockedUsers : HashMap.HashMap<Principal, BlockInfo> = HashMap.new();
    private stable var metrics : HashMap.HashMap<Principal, RateLimitMetrics> = HashMap.new();
    private stable var burstConfigs : HashMap.HashMap<Principal, BurstConfig> = HashMap.new();
    private stable var priorityLevels : HashMap.HashMap<Principal, PriorityLevel> = HashMap.new();
    private stable var adaptiveLimits : HashMap.HashMap<Principal, AdaptiveLimit> = HashMap.new();

    // Types
    type RateLimit = {
        requestsPerMinute : Nat;
        burstLimit : Nat;
        priorityLevel : PriorityLevel;
        adaptiveEnabled : Bool;
    };

    type Quota = {
        dailyLimit : Nat;
        monthlyLimit : Nat;
        usedToday : Nat;
        usedThisMonth : Nat;
        lastReset : Time.Time;
    };

    type BlockInfo = {
        reason : Text;
        startTime : Time.Time;
        duration : Nat; // in seconds
    };

    type RateLimitMetrics = {
        totalRequests : Nat;
        blockedRequests : Nat;
        averageResponseTime : Nat;
        lastUpdated : Time.Time;
    };

    type BurstConfig = {
        maxBurstSize : Nat;
        burstWindow : Nat; // in seconds
        currentBurstCount : Nat;
        lastBurstTime : Time.Time;
    };

    type PriorityLevel = {
        level : Nat; // 1-5, where 5 is highest priority
        multiplier : Float; // Rate limit multiplier for this priority
        guaranteedRequests : Nat; // Minimum guaranteed requests per minute
    };

    type AdaptiveLimit = {
        baseLimit : Nat;
        currentLimit : Nat;
        minLimit : Nat;
        maxLimit : Nat;
        adjustmentFactor : Float;
        lastAdjustment : Time.Time;
        successRate : Float;
    };

    // Private helper functions
    private func generateRateLimitId() : Principal {
        Principal.fromText("rate-limit-" # Nat.toText(Time.now()));
    };

    private func calculateAdaptiveLimit(adaptive : AdaptiveLimit, metrics : RateLimitMetrics) : Nat {
        let timeSinceLastAdjustment = Time.now() - adaptive.lastAdjustment;
        if (timeSinceLastAdjustment < 60_000_000_000) { // 1 minute
            return adaptive.currentLimit;
        };

        let newLimit = if (adaptive.successRate > 0.95) {
            Nat.min(adaptive.maxLimit, Nat.add(adaptive.currentLimit, Nat.mul(Nat.fromIntWrap(adaptive.adjustmentFactor), 10)));
        } else if (adaptive.successRate < 0.8) {
            Nat.max(adaptive.minLimit, Nat.sub(adaptive.currentLimit, Nat.mul(Nat.fromIntWrap(adaptive.adjustmentFactor), 10)));
        } else {
            adaptive.currentLimit;
        };

        newLimit;
    };

    private func handleBurstRequest(user : Principal, burstConfig : BurstConfig) : Bool {
        let now = Time.now();
        if (now - burstConfig.lastBurstTime > burstConfig.burstWindow * 1_000_000_000) {
            // Reset burst window
            let updatedConfig = {
                burstConfig with
                currentBurstCount = 1;
                lastBurstTime = now;
            };
            ignore HashMap.put(burstConfigs, Principal.equal, Principal.hash, user, updatedConfig);
            return true;
        } else if (burstConfig.currentBurstCount < burstConfig.maxBurstSize) {
            // Allow burst request
            let updatedConfig = {
                burstConfig with
                currentBurstCount = burstConfig.currentBurstCount + 1;
            };
            ignore HashMap.put(burstConfigs, Principal.equal, Principal.hash, user, updatedConfig);
            return true;
        };
        false;
    };

    private func getEffectiveRateLimit(user : Principal) : Nat {
        switch (HashMap.get(rateLimits, Principal.equal, Principal.hash, user)) {
            case (?limit) {
                switch (HashMap.get(priorityLevels, Principal.equal, Principal.hash, user)) {
                    case (?priority) {
                        Nat.mul(limit.requestsPerMinute, Nat.fromIntWrap(priority.multiplier));
                    };
                    case null { limit.requestsPerMinute };
                };
            };
            case null { 60 }; // Default: 60 requests per minute
        };
    };

    // Public shared functions
    public shared(msg) func checkRateLimit() : async Bool {
        let user = msg.caller;
        
        // Check if user is blocked
        switch (HashMap.get(blockedUsers, Principal.equal, Principal.hash, user)) {
            case (?blockInfo) {
                if (Time.now() - blockInfo.startTime < blockInfo.duration * 1_000_000_000) {
                    return false;
                };
                // Unblock user if block duration has passed
                ignore HashMap.remove(blockedUsers, Principal.equal, Principal.hash, user);
            };
            case null {};
        };

        // Get rate limit and burst config
        let rateLimit = Option.get(HashMap.get(rateLimits, Principal.equal, Principal.hash, user), {
            requestsPerMinute = 60;
            burstLimit = 10;
            priorityLevel = { level = 1; multiplier = 1.0; guaranteedRequests = 10 };
            adaptiveEnabled = false;
        });

        let burstConfig = Option.get(HashMap.get(burstConfigs, Principal.equal, Principal.hash, user), {
            maxBurstSize = 10;
            burstWindow = 60;
            currentBurstCount = 0;
            lastBurstTime = 0;
        });

        // Check burst limit first
        if (not handleBurstRequest(user, burstConfig)) {
            return false;
        };

        // Get effective rate limit based on priority and adaptive settings
        let effectiveLimit = if (rateLimit.adaptiveEnabled) {
            switch (HashMap.get(adaptiveLimits, Principal.equal, Principal.hash, user)) {
                case (?adaptive) {
                    switch (HashMap.get(metrics, Principal.equal, Principal.hash, user)) {
                        case (?userMetrics) {
                            calculateAdaptiveLimit(adaptive, userMetrics);
                        };
                        case null { rateLimit.requestsPerMinute };
                    };
                };
                case null { rateLimit.requestsPerMinute };
            };
        } else {
            getEffectiveRateLimit(user);
        };

        // Update metrics
        let metrics = Option.get(HashMap.get(metrics, Principal.equal, Principal.hash, user), {
            totalRequests = 0;
            blockedRequests = 0;
            averageResponseTime = 0;
            lastUpdated = Time.now();
        });

        let updatedMetrics = {
            metrics with
            totalRequests = metrics.totalRequests + 1;
            lastUpdated = Time.now();
        };

        ignore HashMap.put(metrics, Principal.equal, Principal.hash, user, updatedMetrics);

        true;
    };

    public shared(msg) func setRateLimit(limit : RateLimit) : async () {
        let user = msg.caller;
        ignore HashMap.put(rateLimits, Principal.equal, Principal.hash, user, limit);
    };

    public shared(msg) func setQuota(quota : Quota) : async () {
        let user = msg.caller;
        ignore HashMap.put(quotas, Principal.equal, Principal.hash, user, quota);
    };

    public shared(msg) func blockUser(duration : Nat, reason : Text) : async () {
        let user = msg.caller;
        let blockInfo = {
            reason = reason;
            startTime = Time.now();
            duration = duration;
        };
        ignore HashMap.put(blockedUsers, Principal.equal, Principal.hash, user, blockInfo);
    };

    public shared(msg) func setBurstConfig(config : BurstConfig) : async () {
        let user = msg.caller;
        ignore HashMap.put(burstConfigs, Principal.equal, Principal.hash, user, config);
    };

    public shared(msg) func setPriorityLevel(priority : PriorityLevel) : async () {
        let user = msg.caller;
        ignore HashMap.put(priorityLevels, Principal.equal, Principal.hash, user, priority);
    };

    public shared(msg) func setAdaptiveLimit(adaptive : AdaptiveLimit) : async () {
        let user = msg.caller;
        ignore HashMap.put(adaptiveLimits, Principal.equal, Principal.hash, user, adaptive);
    };

    public query func getRateLimitMetrics(user : Principal) : async ?RateLimitMetrics {
        HashMap.get(metrics, Principal.equal, Principal.hash, user);
    };

    public query func getBurstConfig(user : Principal) : async ?BurstConfig {
        HashMap.get(burstConfigs, Principal.equal, Principal.hash, user);
    };

    public query func getPriorityLevel(user : Principal) : async ?PriorityLevel {
        HashMap.get(priorityLevels, Principal.equal, Principal.hash, user);
    };

    public query func getAdaptiveLimit(user : Principal) : async ?AdaptiveLimit {
        HashMap.get(adaptiveLimits, Principal.equal, Principal.hash, user);
    };
}; 