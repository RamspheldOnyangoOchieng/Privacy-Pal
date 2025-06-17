

actor class SecurityCanister {
    // State variables
    private stable var rateLimits = HashMap.new<Text, Types.RateLimit>();
    private stable var accessControls = HashMap.new<Text, Types.AccessControl>();
    private stable var securityLogs = HashMap.new<Text, Types.SecurityLog>();
    private stable var blacklistedPrincipals = HashMap.new<Text, Types.BlacklistEntry>();
    private stable var whitelistedPrincipals = HashMap.new<Text, Types.WhitelistEntry>();

    // Private helper functions
    private func generateSecurityLogId() : Text {
        "security_" # Nat.toText(Time.now())
    };

    private func validateRateLimit(rateLimit : Types.RateLimit) : Bool {
        rateLimit.maxRequests > 0 and
        rateLimit.timeWindow > 0
    };

    private func validateAccessControl(accessControl : Types.AccessControl) : Bool {
        Utils.isNotEmpty(accessControl.resource) and
        accessControl.permissions.size() > 0
    };

    private func checkRateLimit(principal : Principal, action : Text) : Bool {
        let principalId = Principal.toText(principal);
        switch (HashMap.get(rateLimits, Text.equal, action)) {
            case (?rateLimit) {
                let currentTime = Time.now();
                let windowStart = currentTime - rateLimit.timeWindow;
                let requests = Array.filter(rateLimit.requests, func(r : Types.Request) : Bool {
                    r.principalId == principalId and r.timestamp >= windowStart
                });
                Array.size(requests) < rateLimit.maxRequests
            };
            case null { true }
        }
    };

    private func checkAccessControl(principal : Principal, resource : Text, action : Text) : Bool {
        let principalId = Principal.toText(principal);
        switch (HashMap.get(accessControls, Text.equal, resource)) {
            case (?accessControl) {
                Array.some(accessControl.permissions, func(p : Types.Permission) : Bool {
                    p.principalId == principalId and p.action == action
                })
            };
            case null { false }
        }
    };

    private func logSecurityEvent(event : Types.SecurityEvent) : () {
        let logId = generateSecurityLogId();
        let log = {
            id = logId;
            event = event;
            timestamp = Time.now()
        };
        HashMap.put(securityLogs, Text.equal, logId, log)
    };

    // Public shared functions
    public shared(msg) func setRateLimit(action : Text, rateLimit : Types.RateLimit) : async Result.Result<(), Text> {
        if (not validateRateLimit(rateLimit)) {
            return #err(Constants.ERROR_INVALID_RATE_LIMIT)
        };
        HashMap.put(rateLimits, Text.equal, action, rateLimit);
        logSecurityEvent({
            type = #rateLimitSet;
            principalId = Principal.toText(msg.caller);
            details = "Rate limit set for action: " # action
        });
        #ok()
    };

    public shared(msg) func setAccessControl(resource : Text, accessControl : Types.AccessControl) : async Result.Result<(), Text> {
        if (not validateAccessControl(accessControl)) {
            return #err(Constants.ERROR_INVALID_ACCESS_CONTROL)
        };
        HashMap.put(accessControls, Text.equal, resource, accessControl);
        logSecurityEvent({
            type = #accessControlSet;
            principalId = Principal.toText(msg.caller);
            details = "Access control set for resource: " # resource
        });
        #ok()
    };

    public shared(msg) func blacklistPrincipal(principal : Principal, reason : Text) : async Result.Result<(), Text> {
        let principalId = Principal.toText(principal);
        let entry = {
            principalId = principalId;
            reason = reason;
            timestamp = Time.now()
        };
        HashMap.put(blacklistedPrincipals, Text.equal, principalId, entry);
        logSecurityEvent({
            type = #principalBlacklisted;
            principalId = Principal.toText(msg.caller);
            details = "Principal blacklisted: " # principalId
        });
        #ok()
    };

    public shared(msg) func whitelistPrincipal(principal : Principal, reason : Text) : async Result.Result<(), Text> {
        let principalId = Principal.toText(principal);
        let entry = {
            principalId = principalId;
            reason = reason;
            timestamp = Time.now()
        };
        HashMap.put(whitelistedPrincipals, Text.equal, principalId, entry);
        logSecurityEvent({
            type = #principalWhitelisted;
            principalId = Principal.toText(msg.caller);
            details = "Principal whitelisted: " # principalId
        });
        #ok()
    };

    public shared(msg) func checkSecurity(principal : Principal, resource : Text, action : Text) : async Result.Result<Bool, Text> {
        let principalId = Principal.toText(principal);
        
        // Check if principal is blacklisted
        if (Option.isSome(HashMap.get(blacklistedPrincipals, Text.equal, principalId))) {
            logSecurityEvent({
                type = #accessDenied;
                principalId = principalId;
                details = "Access denied: Principal is blacklisted"
            });
            return #err(Constants.ERROR_PRINCIPAL_BLACKLISTED)
        };

        // Check if principal is whitelisted
        if (Option.isSome(HashMap.get(whitelistedPrincipals, Text.equal, principalId))) {
            logSecurityEvent({
                type = #accessGranted;
                principalId = principalId;
                details = "Access granted: Principal is whitelisted"
            });
            return #ok(true)
        };

        // Check rate limit
        if (not checkRateLimit(principal, action)) {
            logSecurityEvent({
                type = #rateLimitExceeded;
                principalId = principalId;
                details = "Rate limit exceeded for action: " # action
            });
            return #err(Constants.ERROR_RATE_LIMIT_EXCEEDED)
        };

        // Check access control
        if (not checkAccessControl(principal, resource, action)) {
            logSecurityEvent({
                type = #accessDenied;
                principalId = principalId;
                details = "Access denied: Insufficient permissions"
            });
            return #err(Constants.ERROR_ACCESS_DENIED)
        };

        logSecurityEvent({
            type = #accessGranted;
            principalId = principalId;
            details = "Access granted for resource: " # resource
        });
        #ok(true)
    };

    // Query functions
    public query func getRateLimit(action : Text) : async ?Types.RateLimit {
        HashMap.get(rateLimits, Text.equal, action)
    };

    public query func getAccessControl(resource : Text) : async ?Types.AccessControl {
        HashMap.get(accessControls, Text.equal, resource)
    };

    public query func isPrincipalBlacklisted(principal : Principal) : async Bool {
        Option.isSome(HashMap.get(blacklistedPrincipals, Text.equal, Principal.toText(principal)))
    };

    public query func isPrincipalWhitelisted(principal : Principal) : async Bool {
        Option.isSome(HashMap.get(whitelistedPrincipals, Text.equal, Principal.toText(principal)))
    };

    public query func getSecurityLogs() : async [Types.SecurityLog] {
        let logs = HashMap.entries(securityLogs);
        Array.map(logs, func((id, log) : (Text, Types.SecurityLog)) : Types.SecurityLog { log })
    };

    public query func getSecurityLogsByType(eventType : Types.SecurityEventType) : async [Types.SecurityLog] {
        let logs = HashMap.entries(securityLogs);
        let filteredLogs = Array.filter(logs, func((id, log) : (Text, Types.SecurityLog)) : Bool {
            log.event.type == eventType
        });
        Array.map(filteredLogs, func((id, log) : (Text, Types.SecurityLog)) : Types.SecurityLog { log })
    };

    public query func getSecurityLogsByPrincipal(principalId : Text) : async [Types.SecurityLog] {
        let logs = HashMap.entries(securityLogs);
        let filteredLogs = Array.filter(logs, func((id, log) : (Text, Types.SecurityLog)) : Bool {
            log.event.principalId == principalId
        });
        Array.map(filteredLogs, func((id, log) : (Text, Types.SecurityLog)) : Types.SecurityLog { log })
    };

    public query func getSecurityLogsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.SecurityLog] {
        let logs = HashMap.entries(securityLogs);
        let filteredLogs = Array.filter(logs, func((id, log) : (Text, Types.SecurityLog)) : Bool {
            log.timestamp >= startTime and log.timestamp <= endTime
        });
        Array.map(filteredLogs, func((id, log) : (Text, Types.SecurityLog)) : Types.SecurityLog { log })
    };
}; 