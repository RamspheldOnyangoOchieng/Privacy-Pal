

actor class IdentityCanister() {
    // State
    private var users = HashMap.HashMap<Principal, Types.User>(0, Principal.equal, Principal.hash);
    private var sessions = HashMap.HashMap<Text, Types.Session>(0, Text.equal, Text.hash);
    private var devices = HashMap.HashMap<Text, Types.Device>(0, Text.equal, Text.hash);
    private var trustScores = HashMap.HashMap<Principal, Types.TrustScore>(0, Principal.equal, Principal.hash);
    private var deviceProfiles = HashMap.HashMap<Text, Types.DeviceProfile>(0, Text.equal, Text.hash);
    private var blacklistedDevices = HashMap.HashMap<Text, Types.BlacklistEntry>(0, Text.equal, Text.hash);
    private var securityLogs = HashMap.HashMap<Text, [Types.SecurityLog]>(0, Text.equal, Text.hash);
    private var anonymousIdentities = HashMap.HashMap<Text, Types.AnonymousIdentity>(0, Text.equal, Text.hash);
    private var identityLinks = HashMap.HashMap<Text, [Text]>(0, Text.equal, Text.hash);
    private var securityMetrics = HashMap.HashMap<Text, Types.SecurityMetrics>(0, Text.equal, Text.hash);
    private var trustFactors = HashMap.HashMap<Text, [Types.TrustFactor]>(0, Text.equal, Text.hash);
    private let securityManager = Security.SecurityManager();

    // Types
    private type User = {
        id: Principal;
        email: Text;
        name: Text;
        createdAt: Int;
        lastActive: Int;
        status: UserStatus;
        devices: [Text];
    };

    private type UserStatus = {
        #Active;
        #Inactive;
        #Suspended;
    };

    private type Session = {
        id: Text;
        userId: Principal;
        deviceId: Text;
        createdAt: Int;
        expiresAt: Int;
        lastActive: Int;
        ipAddress: ?Text;
    };

    private type Device = {
        id: Text;
        userId: Principal;
        name: Text;
        type: DeviceType;
        fingerprint: Text;
        lastActive: Int;
        trustLevel: TrustLevel;
    };

    private type DeviceType = {
        #Mobile;
        #Desktop;
        #Tablet;
        #Other;
    };

    private type TrustLevel = {
        #High;
        #Medium;
        #Low;
        #Blocked;
    };

    private type TrustScore = {
        userId: Principal;
        score: Float;
        factors: [TrustFactor];
        lastUpdated: Int;
    };

    private type TrustFactor = {
        type: Text;
        value: Float;
        weight: Float;
        lastUpdated: Int;
    };

    private type DeviceInfo = {
        platform: Text;
        browser: ?Text;
        version: ?Text;
        fingerprint: Text;
        screenResolution: ?Text;
        timezone: ?Text;
        language: ?Text;
        vpnDetected: Bool;
        torDetected: Bool;
        hardwareInfo: ?HardwareInfo;
        networkInfo: ?NetworkInfo;
    };

    private type HardwareInfo = {
        cpuCores: ?Nat;
        memorySize: ?Nat;
        gpuInfo: ?Text;
        deviceType: ?Text;
    };

    private type NetworkInfo = {
        connectionType: ?Text;
        bandwidth: ?Nat;
        latency: ?Nat;
        proxyDetected: Bool;
    };

    private type DeviceProfile = {
        deviceInfo: DeviceInfo;
        firstSeen: Int;
        lastSeen: Int;
        sessionCount: Nat;
        suspiciousActivities: Nat;
        trustScore: Float;
        region: ?Text;
        riskLevel: RiskLevel;
        behaviorPattern: BehaviorPattern;
    };

    private type BehaviorPattern = {
        loginTimes: [Int];
        activityHours: [Int];
        commonLocations: [Text];
        deviceChanges: [DeviceChange];
    };

    private type DeviceChange = {
        timestamp: Int;
        oldInfo: DeviceInfo;
        newInfo: DeviceInfo;
        reason: ?Text;
    };

    private type AnonymousIdentity = {
        id: Text;
        createdAt: Int;
        lastUsed: Int;
        deviceFingerprints: [Text];
        ipAddresses: [Text];
        trustScore: Float;
        riskLevel: RiskLevel;
        linkedIdentities: [Text];
        anonymityMetrics: AnonymityMetrics;
        rotationHistory: [RotationRecord];
    };

    private type AnonymityMetrics = {
        entropyScore: Float;
        correlationScore: Float;
        uniquenessScore: Float;
        lastCalculated: Int;
    };

    private type RotationRecord = {
        timestamp: Int;
        oldId: Text;
        newId: Text;
        reason: Text;
    };

    private type AnonymityPool = {
        id: Text;
        members: [Text];
        createdAt: Int;
        lastRotated: Int;
        entropyLevel: Float;
        riskLevel: RiskLevel;
    };

    private type RiskLevel = {
        #Low;
        #Medium;
        #High;
        #Critical;
    };

    private type AnonymityLevel = {
        #Basic;
        #Enhanced;
        #Maximum;
    };

    private type BlacklistEntry = {
        reason: Text;
        timestamp: Int;
        expiresAt: ?Int;
        deviceInfo: DeviceInfo;
    };

    private type SecurityLog = {
        timestamp: Int;
        eventType: Text;
        details: Text;
        severity: SecuritySeverity;
    };

    private type SecuritySeverity = {
        #Info;
        #Warning;
        #Critical;
    };

    // Constants
    private let SESSION_DURATION = 24 * 60 * 60 * 1_000_000_000; // 24 hours
    private let MAX_SESSIONS_PER_DEVICE = 3;
    private let SUSPICIOUS_ACTIVITY_THRESHOLD = 5;
    private let TRUST_SCORE_DECAY = 0.1;
    private let MIN_TRUST_SCORE = 0.3;
    private let MAX_LINKED_IDENTITIES = 3;
    private let ANONYMIZATION_INTERVAL = 7 * 24 * 60 * 60 * 1_000_000_000; // 7 days
    private let MIN_ENTROPY_SCORE = 0.7;
    private let MAX_CORRELATION_SCORE = 0.3;
    private let TRUST_SCORE_VOLATILITY_THRESHOLD = 0.2;
    private let SECURITY_METRICS_UPDATE_INTERVAL = 60 * 1_000_000_000; // 1 minute

    // Helper Functions
    private func generateSessionId() : async Text {
        let random = await Random.blob(32);
        let hash = await sha256(Blob.toArray(random));
        bytesToText(hash)
    };

    private func generateDeviceId() : async Text {
        let random = await Random.blob(32);
        let hash = await sha256(Blob.toArray(random));
        bytesToText(hash)
    };

    private func calculateTrustScore(userId: Principal) : async Float {
        var totalScore = 0.0;
        var totalWeight = 0.0;

        switch (trustScores.get(userId)) {
            case (?score) {
                for (factor in score.factors.vals()) {
                    totalScore += factor.value * factor.weight;
                    totalWeight += factor.weight;
                };
            };
            case null {};
        };

        if (totalWeight > 0.0) {
            totalScore / totalWeight
        } else {
            0.0
        }
    };

    private func updateTrustFactors(userId: Principal) {
        let now = Time.now();
        let factors: [TrustFactor] = [
            {
                type = "account_age";
                value = 1.0;
                weight = 0.2;
                lastUpdated = now;
            },
            {
                type = "device_trust";
                value = 0.8;
                weight = 0.3;
                lastUpdated = now;
            },
            {
                type = "activity_level";
                value = 0.9;
                weight = 0.3;
                lastUpdated = now;
            },
            {
                type = "report_quality";
                value = 0.7;
                weight = 0.2;
                lastUpdated = now;
            }
        ];

        let trustScore: TrustScore = {
            userId = userId;
            score = 0.0; // Will be calculated
            factors = factors;
            lastUpdated = now;
        };

        trustScores.put(userId, trustScore);
    };

    private func updateDeviceProfile(
        deviceInfo: DeviceInfo,
        isSuspicious: Bool,
        region: ?Text
    ) {
        let fingerprint = calculateDeviceFingerprint(deviceInfo);
        switch (deviceProfiles.get(fingerprint)) {
            case (?profile) {
                let updatedProfile: Types.DeviceProfile = {
                    deviceInfo = deviceInfo;
                    firstSeen = profile.firstSeen;
                    lastSeen = Time.now();
                    sessionCount = profile.sessionCount + 1;
                    suspiciousActivities = if (isSuspicious) { profile.suspiciousActivities + 1 } else { profile.suspiciousActivities };
                    trustScore = if (isSuspicious) { 
                        Float.max(profile.trustScore - TRUST_SCORE_DECAY, MIN_TRUST_SCORE)
                    } else {
                        profile.trustScore
                    };
                    region = region;
                    riskLevel = calculateRiskLevel(profile.suspiciousActivities, deviceInfo);
                    behaviorPattern = profile.behaviorPattern;
                };
                deviceProfiles.put(fingerprint, updatedProfile);
            };
            case null {
                let newProfile: Types.DeviceProfile = {
                    deviceInfo = deviceInfo;
                    firstSeen = Time.now();
                    lastSeen = Time.now();
                    sessionCount = 1;
                    suspiciousActivities = if (isSuspicious) { 1 } else { 0 };
                    trustScore = if (isSuspicious) { 0.5 } else { 1.0 };
                    region = region;
                    riskLevel = calculateRiskLevel(0, deviceInfo);
                    behaviorPattern = {
                        loginTimes = [];
                        activityHours = [];
                        commonLocations = [];
                        deviceChanges = [];
                    };
                };
                deviceProfiles.put(fingerprint, newProfile);
            };
        };
    };

    private func calculateRiskLevel(suspiciousActivities: Nat, deviceInfo: DeviceInfo) : RiskLevel {
        if (suspiciousActivities >= SUSPICIOUS_ACTIVITY_THRESHOLD) {
            return #Critical;
        } else if (deviceInfo.vpnDetected or deviceInfo.torDetected) {
            return #High;
        } else if (suspiciousActivities > 0) {
            return #Medium;
        } else {
            return #Low;
        };
    };

    private func logSecurityEvent(
        principalId: Text,
        eventType: Text,
        details: Text,
        severity: SecuritySeverity
    ) {
        let log: SecurityLog = {
            timestamp = Time.now();
            eventType = eventType;
            details = details;
            severity = severity;
        };
        switch (securityLogs.get(principalId)) {
            case (?logs) {
                let updatedLogs = Array.append(logs, [log]);
                securityLogs.put(principalId, updatedLogs);
            };
            case null {
                securityLogs.put(principalId, [log]);
            };
        };
    };

    private func checkDeviceBlacklist(deviceInfo: DeviceInfo) : Bool {
        let fingerprint = calculateDeviceFingerprint(deviceInfo);
        switch (blacklistedDevices.get(fingerprint)) {
            case (?entry) {
                switch (entry.expiresAt) {
                    case (?expiresAt) {
                        if (Time.now() < expiresAt) {
                            return true;
                        } else {
                            blacklistedDevices.delete(fingerprint);
                            return false;
                        };
                    };
                    case null { return true };
                };
            };
            case null { return false };
        };
    };

    private func calculateAnonymityMetrics(identity: Types.AnonymousIdentity) : AnonymityMetrics {
        let entropyScore = calculateEntropyScore(identity);
        let correlationScore = calculateCorrelationScore(identity);
        let uniquenessScore = calculateUniquenessScore(identity);

        {
            entropyScore = entropyScore;
            correlationScore = correlationScore;
            uniquenessScore = uniquenessScore;
            lastCalculated = Time.now();
        }
    };

    private func calculateEntropyScore(identity: Types.AnonymousIdentity) : Float {
        // Implement entropy calculation based on device diversity, IP changes, and activity patterns
        let deviceDiversity = calculateDeviceDiversity(identity.deviceFingerprints);
        let ipDiversity = calculateIPDiversity(identity.ipAddresses);
        let activityDiversity = calculateActivityDiversity(identity);
        
        (deviceDiversity + ipDiversity + activityDiversity) / 3.0
    };

    private func calculateCorrelationScore(identity: Types.AnonymousIdentity) : Float {
        // Implement correlation analysis between different identity attributes
        let deviceCorrelation = calculateDeviceCorrelation(identity);
        let ipCorrelation = calculateIPCorrelation(identity);
        let activityCorrelation = calculateActivityCorrelation(identity);
        
        (deviceCorrelation + ipCorrelation + activityCorrelation) / 3.0
    };

    private func calculateUniquenessScore(identity: Types.AnonymousIdentity) : Float {
        // Implement uniqueness calculation based on behavior patterns and attributes
        let behaviorUniqueness = calculateBehaviorUniqueness(identity);
        let attributeUniqueness = calculateAttributeUniqueness(identity);
        
        (behaviorUniqueness + attributeUniqueness) / 2.0
    };

    private func updateSecurityMetrics(identityId: Text) {
        switch (securityMetrics.get(identityId)) {
            case (?metrics) {
                let updatedMetrics: Types.SecurityMetrics = {
                    totalSessions = metrics.totalSessions + 1;
                    failedAttempts = metrics.failedAttempts;
                    suspiciousActivities = metrics.suspiciousActivities;
                    lastIncident = metrics.lastIncident;
                    riskScore = calculateRiskScore(metrics);
                    threatLevel = calculateThreatLevel(metrics);
                };
                securityMetrics.put(identityId, updatedMetrics);
            };
            case null {
                let initialMetrics: Types.SecurityMetrics = {
                    totalSessions = 1;
                    failedAttempts = 0;
                    suspiciousActivities = 0;
                    lastIncident = null;
                    riskScore = 0.0;
                    threatLevel = #Low;
                };
                securityMetrics.put(identityId, initialMetrics);
            };
        };
    };

    private func calculateRiskScore(metrics: Types.SecurityMetrics) : Float {
        let failedAttemptsWeight = 0.4;
        let suspiciousActivitiesWeight = 0.4;
        let incidentRecencyWeight = 0.2;
        
        let failedAttemptsScore = Float.fromInt(metrics.failedAttempts) / 10.0;
        let suspiciousActivitiesScore = Float.fromInt(metrics.suspiciousActivities) / 10.0;
        let incidentRecencyScore = switch (metrics.lastIncident) {
            case (?timestamp) {
                let timeSinceIncident = Time.now() - timestamp;
                if (timeSinceIncident < 24 * 60 * 60 * 1_000_000_000) { // 24 hours
                    1.0
                } else {
                    0.5
                }
            };
            case null { 0.0 };
        };
        
        (failedAttemptsScore * failedAttemptsWeight) +
        (suspiciousActivitiesScore * suspiciousActivitiesWeight) +
        (incidentRecencyScore * incidentRecencyWeight)
    };

    private func calculateThreatLevel(metrics: Types.SecurityMetrics) : Types.ThreatLevel {
        if (metrics.riskScore >= 0.8) {
            #Critical
        } else if (metrics.riskScore >= 0.6) {
            #High
        } else if (metrics.riskScore >= 0.4) {
            #Medium
        } else {
            #Low
        }
    };

    // Public Functions
    public shared(msg) func createUser(
        email: Text,
        name: Text
    ) : async Result.Result<Principal, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        if (not Utils.validateEmail(email)) {
            return #err("Invalid email format");
        };

        let userId = msg.caller;
        let user : Types.User = {
            id = userId;
            email = email;
            name = name;
            createdAt = Time.now();
            lastActive = Time.now();
            status = #Active;
            devices = [];
        };

        users.put(userId, user);
        updateTrustFactors(userId);
        return #ok(userId);
    };

    public shared(msg) func createSession(
        deviceName: Text,
        deviceType: DeviceType,
        ipAddress: ?Text
    ) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        if (not securityManager.recordLoginAttempt(msg.caller)) {
            return #err("Too many login attempts");
        };

        let userId = msg.caller;
        switch (users.get(userId)) {
            case (?user) {
                // Generate device ID
                let deviceId = await generateDeviceId();
                let now = Time.now();

                // Create device
                let device: Types.Device = {
                    id = deviceId;
                    userId = userId;
                    name = deviceName;
                    type = deviceType;
                    fingerprint = ""; // TODO: Implement device fingerprinting
                    lastActive = now;
                    trustLevel = #Medium;
                };

                devices.put(deviceId, device);

                // Create session
                let sessionId = await generateSessionId();
                let session: Types.Session = {
                    id = sessionId;
                    userId = userId;
                    deviceId = deviceId;
                    createdAt = now;
                    expiresAt = now + Constants.SESSION_DURATION;
                    lastActive = now;
                    ipAddress = ipAddress;
                };

                sessions.put(sessionId, session);

                // Update user's devices
                let updatedDevices = Array.append(user.devices, [deviceId]);
                let updatedUser: Types.User = {
                    id = userId;
                    email = user.email;
                    name = user.name;
                    createdAt = user.createdAt;
                    lastActive = now;
                    status = user.status;
                    devices = updatedDevices;
                };

                users.put(userId, updatedUser);

                return #ok(sessionId);
            };
            case null {
                return #err("User not found");
            };
        }
    };

    public query func getUser() : async ?Types.User {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return null;
        };
        users.get(msg.caller)
    };

    public query func getTrustScore() : async ?Types.TrustScore {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return null;
        };
        trustScores.get(msg.caller)
    };

    public shared(msg) func createAnonymousSession(
        deviceInfo: DeviceInfo,
        ipAddress: ?Text,
        anonymityLevel: AnonymityLevel
    ) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        // Check if device is blacklisted
        if (checkDeviceBlacklist(deviceInfo)) {
            logSecurityEvent(
                Principal.toText(msg.caller),
                "blacklisted_device_attempt",
                "Attempted session creation with blacklisted device",
                #Critical
            );
            return #err("Device is blacklisted");
        };

        // Check number of active sessions for this device
        let fingerprint = calculateDeviceFingerprint(deviceInfo);
        var activeSessions = 0;
        for ((_, session) in sessions.entries()) {
            if (session.deviceInfo.fingerprint == fingerprint and isSessionValid(session)) {
                activeSessions += 1;
            };
        };

        if (activeSessions >= MAX_SESSIONS_PER_DEVICE) {
            logSecurityEvent(
                Principal.toText(msg.caller),
                "max_sessions_exceeded",
                "Maximum sessions exceeded for device",
                #Warning
            );
            return #err("Maximum sessions exceeded");
        };

        // Create new session
        let sessionId = await generateSessionId();
        let now = Time.now();

        let session: Types.Session = {
            id = sessionId;
            userId = msg.caller;
            deviceId = fingerprint;
            createdAt = now;
            expiresAt = now + Constants.SESSION_DURATION;
            lastActive = now;
            ipAddress = ipAddress;
            securityLevel = #High;
            anonymityLevel = anonymityLevel;
            sessionMetrics = {
                requestCount = 0;
                lastRequestTime = now;
                averageResponseTime = 0.0;
                errorRate = 0.0;
                bandwidthUsage = 0;
            };
        };

        sessions.put(sessionId, session);
        updateDeviceProfile(deviceInfo, false, null);
        updateSecurityMetrics(Principal.toText(msg.caller));

        return #ok(sessionId);
    };

    public shared(msg) func createAnonymousIdentity() : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let identityId = await generateAnonymousId();
        let now = Time.now();

        let identity: Types.AnonymousIdentity = {
            id = identityId;
            createdAt = now;
            lastUsed = now;
            deviceFingerprints = [];
            ipAddresses = [];
            trustScore = 1.0;
            riskLevel = #Low;
            linkedIdentities = [];
            anonymityMetrics = {
                entropyScore = 1.0;
                correlationScore = 0.0;
                uniquenessScore = 1.0;
                lastCalculated = now;
            };
            rotationHistory = [];
        };

        anonymousIdentities.put(identityId, identity);
        return #ok(identityId);
    };

    public query func getSecurityMetrics(identityId: Text) : async Result.Result<Types.SecurityMetrics, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        switch (securityMetrics.get(identityId)) {
            case (?metrics) {
                return #ok(metrics);
            };
            case null {
                return #err("No security metrics found");
            };
        };
    };

    public query func getAnonymityMetrics(identityId: Text) : async Result.Result<Types.AnonymityMetrics, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        switch (anonymousIdentities.get(identityId)) {
            case (?identity) {
                return #ok(identity.anonymityMetrics);
            };
            case null {
                return #err("No anonymity metrics found");
            };
        };
    };

    public shared(msg) func validateSession(sessionId: Text) : async Result.Result<Bool, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        switch (sessions.get(sessionId)) {
            case (?session) {
                if (session.userId == msg.caller and not Utils.isSessionExpired(session)) {
                    // Update last activity
                    let updatedSession = {
                        session with
                        lastActive = Time.now()
                    };
                    sessions.put(sessionId, updatedSession);
                    return #ok(true);
                } else {
                    sessions.delete(sessionId);
                    logSecurityEvent(
                        Principal.toText(session.userId),
                        "session_expired",
                        "Session expired and was deleted",
                        #Info
                    );
                    return #ok(false);
                };
            };
            case null {
                return #ok(false);
            };
        };
    };

    public shared(msg) func refreshSession(sessionId: Text) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        switch (sessions.get(sessionId)) {
            case (?session) {
                if (session.userId == msg.caller and not Utils.isSessionExpired(session)) {
                    let now = Time.now();
                    let updatedSession = {
                        session with
                        expiresAt = now + Constants.SESSION_DURATION
                    };
                    sessions.put(sessionId, updatedSession);
                    return #ok(sessionId);
                } else {
                    return #err("Session expired");
                };
            };
            case null {
                return #err("Session not found");
            };
        };
    };

    public shared(msg) func endSession(sessionId: Text) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        switch (sessions.get(sessionId)) {
            case (?session) {
                if (session.userId == msg.caller) {
                    sessions.delete(sessionId);
                    logSecurityEvent(
                        Principal.toText(session.userId),
                        "session_ended",
                        "Session ended by user",
                        #Info
                    );
                    return #ok("Session ended successfully");
                } else {
                    return #err("Unauthorized");
                };
            };
            case null {
                return #err("Session not found");
            };
        };
    };

    public shared(msg) func reportSuspiciousActivity(
        deviceInfo: DeviceInfo,
        reason: Text
    ) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let fingerprint = calculateDeviceFingerprint(deviceInfo);
        updateDeviceProfile(deviceInfo, true, null);

        switch (deviceProfiles.get(fingerprint)) {
            case (?profile) {
                if (profile.suspiciousActivities >= SUSPICIOUS_ACTIVITY_THRESHOLD) {
                    let blacklistEntry: Types.BlacklistEntry = {
                        reason = reason;
                        timestamp = Time.now();
                        expiresAt = ?(Time.now() + 7 * 24 * 60 * 60 * 1_000_000_000); // 7 days
                        deviceInfo = deviceInfo;
                    };
                    blacklistedDevices.put(fingerprint, blacklistEntry);
                    logSecurityEvent(
                        Principal.toText(msg.caller),
                        "device_blacklisted",
                        "Device blacklisted due to suspicious activity",
                        #Critical
                    );
                };
            };
            case null {};
        };

        return #ok("Suspicious activity reported");
    };

    public query func getSecurityLogs() : async Result.Result<[Types.SecurityLog], Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };
        securityManager.getSecurityLogs()
    };

    public query func getDeviceTrustScore(deviceInfo: DeviceInfo) : async Result.Result<Float, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let fingerprint = calculateDeviceFingerprint(deviceInfo);
        switch (deviceProfiles.get(fingerprint)) {
            case (?profile) {
                return #ok(profile.trustScore);
            };
            case null {
                return #ok(1.0);
            };
        };
    };

    public shared(msg) func updateTrustScore(factor: Types.TrustFactor) : async Result.Result<(), Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let currentScore = switch(trustScores.get(msg.caller)) {
            case (?score) score;
            case null {
                {
                    userId = msg.caller;
                    score = 0.5;
                    factors = [];
                    lastUpdated = Time.now();
                }
            };
        };

        let updatedFactors = Array.append(currentScore.factors, [factor]);
        let newScore = Utils.calculateTrustScore(updatedFactors);
        let updatedScore = {
            currentScore with
            score = newScore;
            factors = updatedFactors;
            lastUpdated = Time.now();
        };

        trustScores.put(msg.caller, updatedScore);
        securityManager.logSecurityEvent(
            msg.caller,
            #TrustScoreUpdate,
            #Low,
            "Trust score updated to: " # Float.toText(newScore)
        );
        #ok()
    };

    public shared(msg) func registerDevice(name: Text, deviceType: DeviceType) : async Result.Result<Text, Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let deviceId = Utils.generateDeviceId();
        let device : Types.Device = {
            id = deviceId;
            userId = msg.caller;
            name = name;
            type = deviceType;
            fingerprint = ""; // TODO: Implement device fingerprinting
            lastActive = Time.now();
            trustLevel = #Medium;
        };

        devices.put(deviceId, device);
        securityManager.logSecurityEvent(
            msg.caller,
            #DeviceAdded,
            #Low,
            "New device registered: " # name
        );
        return #ok(deviceId);
    };

    public shared(msg) func getDevices() : async Result.Result<[Types.Device], Text> {
        if (not securityManager.checkRateLimit(msg.caller)) {
            return #err("Rate limit exceeded");
        };

        let userDevices = Buffer.Buffer<Types.Device>(0);
        for ((_, device) in devices.entries()) {
            if (device.userId == msg.caller) {
                userDevices.add(device);
            };
        };
        return #ok(Buffer.toArray(userDevices));
    };
} 