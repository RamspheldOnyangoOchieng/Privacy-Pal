

actor class IntegrationCanister {
    // State variables
    private stable var identityCanister : ?Principal = null;
    private stable var moderationCanister : ?Principal = null;
    private stable var storageCanister : ?Principal = null;
    private stable var notificationCanister : ?Principal = null;
    private stable var auditCanister : ?Principal = null;
    private stable var integrationHistory = HashMap.new<Text, Types.IntegrationHistory>();

    // Private helper functions
    private func generateIntegrationId() : Text {
        "integration_" # Nat.toText(Time.now())
    };

    private func validateCanisterId(canisterId : Principal) : Bool {
        Principal.isAnonymous(canisterId) == false
    };

    private func logIntegration(source : Text, target : Text, action : Text, status : Text) : () {
        let integrationId = generateIntegrationId();
        let history = {
            id = integrationId;
            source = source;
            target = target;
            action = action;
            status = status;
            timestamp = Time.now()
        };
        HashMap.put(integrationHistory, Text.equal, integrationId, history)
    };

    // Public shared functions
    public shared(msg) func setIdentityCanister(canisterId : Principal) : async Result.Result<(), Text> {
        if (not validateCanisterId(canisterId)) {
            return #err(Constants.ERROR_INVALID_CANISTER_ID)
        };
        identityCanister := ?canisterId;
        logIntegration("report", "identity", "set_canister", "success");
        #ok()
    };

    public shared(msg) func setModerationCanister(canisterId : Principal) : async Result.Result<(), Text> {
        if (not validateCanisterId(canisterId)) {
            return #err(Constants.ERROR_INVALID_CANISTER_ID)
        };
        moderationCanister := ?canisterId;
        logIntegration("report", "moderation", "set_canister", "success");
        #ok()
    };

    public shared(msg) func setStorageCanister(canisterId : Principal) : async Result.Result<(), Text> {
        if (not validateCanisterId(canisterId)) {
            return #err(Constants.ERROR_INVALID_CANISTER_ID)
        };
        storageCanister := ?canisterId;
        logIntegration("report", "storage", "set_canister", "success");
        #ok()
    };

    public shared(msg) func setNotificationCanister(canisterId : Principal) : async Result.Result<(), Text> {
        if (not validateCanisterId(canisterId)) {
            return #err(Constants.ERROR_INVALID_CANISTER_ID)
        };
        notificationCanister := ?canisterId;
        logIntegration("report", "notification", "set_canister", "success");
        #ok()
    };

    public shared(msg) func setAuditCanister(canisterId : Principal) : async Result.Result<(), Text> {
        if (not validateCanisterId(canisterId)) {
            return #err(Constants.ERROR_INVALID_CANISTER_ID)
        };
        auditCanister := ?canisterId;
        logIntegration("report", "audit", "set_canister", "success");
        #ok()
    };

    public shared(msg) func notifyIdentityCanister(report : Types.Report) : async Result.Result<(), Text> {
        switch (identityCanister) {
            case (?canisterId) {
                // Call identity canister to notify about new report
                logIntegration("report", "identity", "notify_report", "success");
                #ok()
            };
            case null { #err(Constants.ERROR_CANISTER_NOT_SET) }
        }
    };

    public shared(msg) func notifyModerationCanister(report : Types.Report) : async Result.Result<(), Text> {
        switch (moderationCanister) {
            case (?canisterId) {
                // Call moderation canister to notify about new report
                logIntegration("report", "moderation", "notify_report", "success");
                #ok()
            };
            case null { #err(Constants.ERROR_CANISTER_NOT_SET) }
        }
    };

    public shared(msg) func storeAttachment(attachment : Types.Attachment) : async Result.Result<Text, Text> {
        switch (storageCanister) {
            case (?canisterId) {
                // Call storage canister to store attachment
                logIntegration("report", "storage", "store_attachment", "success");
                #ok(attachment.id)
            };
            case null { #err(Constants.ERROR_CANISTER_NOT_SET) }
        }
    };

    public shared(msg) func sendNotification(notification : Types.Notification) : async Result.Result<(), Text> {
        switch (notificationCanister) {
            case (?canisterId) {
                // Call notification canister to send notification
                logIntegration("report", "notification", "send_notification", "success");
                #ok()
            };
            case null { #err(Constants.ERROR_CANISTER_NOT_SET) }
        }
    };

    public shared(msg) func logAudit(audit : Types.Audit) : async Result.Result<(), Text> {
        switch (auditCanister) {
            case (?canisterId) {
                // Call audit canister to log audit
                logIntegration("report", "audit", "log_audit", "success");
                #ok()
            };
            case null { #err(Constants.ERROR_CANISTER_NOT_SET) }
        }
    };

    // Query functions
    public query func getIdentityCanister() : async ?Principal {
        identityCanister
    };

    public query func getModerationCanister() : async ?Principal {
        moderationCanister
    };

    public query func getStorageCanister() : async ?Principal {
        storageCanister
    };

    public query func getNotificationCanister() : async ?Principal {
        notificationCanister
    };

    public query func getAuditCanister() : async ?Principal {
        auditCanister
    };

    public query func getIntegrationHistory() : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        Array.map(history, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };

    public query func getIntegrationHistoryBySource(source : Text) : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.IntegrationHistory)) : Bool {
            h.source == source
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };

    public query func getIntegrationHistoryByTarget(target : Text) : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.IntegrationHistory)) : Bool {
            h.target == target
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };

    public query func getIntegrationHistoryByAction(action : Text) : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.IntegrationHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };

    public query func getIntegrationHistoryByStatus(status : Text) : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.IntegrationHistory)) : Bool {
            h.status == status
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };

    public query func getIntegrationHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.IntegrationHistory] {
        let history = HashMap.entries(integrationHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.IntegrationHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.IntegrationHistory)) : Types.IntegrationHistory { h })
    };
}; 