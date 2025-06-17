

actor class SecurityCanister() {
    // State variables
    private stable var nextKeyId : Nat = 0;
    private var encryptionKeys = HashMap.new<Text, Types.EncryptionKey>();
    private var securityLogs = HashMap.new<Text, [Types.SecurityLog]>();
    private var accessTokens = HashMap.new<Text, Types.AccessToken>();
    private var securityMetrics = HashMap.new<Text, Types.SecurityMetrics>();

    // Helper functions
    private func generateKeyId() : Text {
        let id = Nat.toText(nextKeyId);
        nextKeyId += 1;
        return id;
    };

    private func generateAccessToken() : Text {
        let randomBytes = Random.blob(32);
        let token = Blob.toArray(randomBytes);
        Text.fromIter(Iter.map(token.vals(), func (b : Nat8) : Char {
            Nat8.toNat(b).toChar()
        }))
    };

    private func validateAccessToken(token : Text) : Bool {
        switch (HashMap.get(accessTokens, Text.hash(token), token)) {
            case (null) { false };
            case (?accessToken) {
                Time.now() <= accessToken.expiresAt
            };
        }
    };

    private func logSecurityEvent(event : Types.SecurityEvent) {
        let log : Types.SecurityLog = {
            timestamp = Time.now();
            event = event;
            severity = calculateEventSeverity(event);
        };

        switch (HashMap.get(securityLogs, Text.hash(event.actorId), event.actorId)) {
            case (null) {
                HashMap.put(securityLogs, Text.hash(event.actorId), event.actorId, [log]);
            };
            case (?logs) {
                let updatedLogs = Array.append(logs, [log]);
                HashMap.put(securityLogs, Text.hash(event.actorId), event.actorId, updatedLogs);
            };
        };
    };

    private func calculateEventSeverity(event : Types.SecurityEvent) : Types.SecuritySeverity {
        switch (event) {
            case (#authenticationAttempt(_)) { #Low };
            case (#encryptionKeyRotation(_)) { #Medium };
            case (#accessTokenRevocation(_)) { #Medium };
            case (#securityBreachAttempt(_)) { #High };
            case (#suspiciousActivity(_)) { #High };
        }
    };

    private func updateSecurityMetrics(actorId : Text) {
        let currentMetrics = switch (HashMap.get(securityMetrics, Text.hash(actorId), actorId)) {
            case (null) {
                {
                    failedAuthAttempts = 0;
                    successfulAuthAttempts = 0;
                    keyRotations = 0;
                    securityBreaches = 0;
                    lastUpdated = Time.now();
                }
            };
            case (?metrics) { metrics };
        };

        let logs = switch (HashMap.get(securityLogs, Text.hash(actorId), actorId)) {
            case (null) { [] };
            case (?logs) { logs };
        };

        let updatedMetrics = {
            failedAuthAttempts = Array.filter(logs, func (log : Types.SecurityLog) : Bool {
                switch (log.event) {
                    case (#authenticationAttempt(#failed(_))) { true };
                    case (_) { false };
                }
            }).size();
            successfulAuthAttempts = Array.filter(logs, func (log : Types.SecurityLog) : Bool {
                switch (log.event) {
                    case (#authenticationAttempt(#success(_))) { true };
                    case (_) { false };
                }
            }).size();
            keyRotations = Array.filter(logs, func (log : Types.SecurityLog) : Bool {
                switch (log.event) {
                    case (#encryptionKeyRotation(_)) { true };
                    case (_) { false };
                }
            }).size();
            securityBreaches = Array.filter(logs, func (log : Types.SecurityLog) : Bool {
                switch (log.event) {
                    case (#securityBreachAttempt(_)) { true };
                    case (_) { false };
                }
            }).size();
            lastUpdated = Time.now();
        };

        HashMap.put(securityMetrics, Text.hash(actorId), actorId, updatedMetrics);
    };

    // Public functions
    public shared(msg) func generateEncryptionKey() : async { #ok : Types.EncryptionKey; #err : Text } {
        let keyId = generateKeyId();
        let randomBytes = Random.blob(32);
        
        let key : Types.EncryptionKey = {
            id = keyId;
            key = Blob.toArray(randomBytes);
            createdAt = Time.now();
            expiresAt = Time.now() + 30 * 24 * 60 * 60 * 1_000_000_000; // 30 days
            status = #Active;
            usageCount = 0;
        };

        HashMap.put(encryptionKeys, Text.hash(keyId), keyId, key);
        
        logSecurityEvent(#encryptionKeyRotation({
            keyId = keyId;
            actorId = Principal.toText(msg.caller);
            reason = "New key generation";
        }));

        #ok(key)
    };

    public shared(msg) func rotateEncryptionKey(oldKeyId : Text) : async { #ok : Types.EncryptionKey; #err : Text } {
        switch (HashMap.get(encryptionKeys, Text.hash(oldKeyId), oldKeyId)) {
            case (null) {
                #err("Key not found")
            };
            case (?oldKey) {
                let newKey = await generateEncryptionKey();
                
                switch (newKey) {
                    case (#ok(key)) {
                        let updatedOldKey = {
                            oldKey with
                            status = #Rotated;
                            expiresAt = Time.now();
                        };
                        
                        HashMap.put(encryptionKeys, Text.hash(oldKeyId), oldKeyId, updatedOldKey);
                        
                        logSecurityEvent(#encryptionKeyRotation({
                            keyId = key.id;
                            actorId = Principal.toText(msg.caller);
                            reason = "Key rotation";
                        }));
                        
                        #ok(key)
                    };
                    case (#err(e)) {
                        #err(e)
                    };
                }
            };
        }
    };

    public shared(msg) func createAccessToken(actorId : Text, duration : Nat) : async { #ok : Types.AccessToken; #err : Text } {
        let token = generateAccessToken();
        let accessToken : Types.AccessToken = {
            token = token;
            actorId = actorId;
            createdAt = Time.now();
            expiresAt = Time.now() + duration;
            permissions = [];
            status = #Active;
        };

        HashMap.put(accessTokens, Text.hash(token), token, accessToken);
        
        logSecurityEvent(#authenticationAttempt(#success({
            actorId = actorId;
            method = "Token generation";
        })));

        #ok(accessToken)
    };

    public shared(msg) func revokeAccessToken(token : Text) : async { #ok; #err : Text } {
        switch (HashMap.get(accessTokens, Text.hash(token), token)) {
            case (null) {
                #err("Token not found")
            };
            case (?accessToken) {
                let updatedToken = {
                    accessToken with
                    status = #Revoked;
                    expiresAt = Time.now();
                };
                
                HashMap.put(accessTokens, Text.hash(token), token, updatedToken);
                
                logSecurityEvent(#accessTokenRevocation({
                    token = token;
                    actorId = accessToken.actorId;
                    reason = "Manual revocation";
                }));
                
                #ok
            };
        }
    };

    public query func getSecurityLogs(actorId : Text) : async { #ok : [Types.SecurityLog]; #err : Text } {
        switch (HashMap.get(securityLogs, Text.hash(actorId), actorId)) {
            case (null) {
                #err("No logs found")
            };
            case (?logs) {
                #ok(logs)
            };
        }
    };

    public query func getSecurityMetrics(actorId : Text) : async { #ok : Types.SecurityMetrics; #err : Text } {
        switch (HashMap.get(securityMetrics, Text.hash(actorId), actorId)) {
            case (null) {
                #err("No metrics found")
            };
            case (?metrics) {
                #ok(metrics)
            };
        }
    };

    public query func validateToken(token : Text) : async { #ok : Bool; #err : Text } {
        #ok(validateAccessToken(token))
    };
}; 