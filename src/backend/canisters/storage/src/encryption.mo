

actor class EncryptionCanister {
    // State variables
    private stable var encryptionKeys = HashMap.new<Text, Types.EncryptionKey>();
    private stable var encryptionJobs = HashMap.new<Text, Types.EncryptionJob>();
    private stable var encryptionHistory = HashMap.new<Text, Types.EncryptionHistory>();
    private stable var encryptionStats = HashMap.new<Text, Types.EncryptionStats>();

    // Private helper functions
    private func generateJobId() : Text {
        "encryption_" # Nat.toText(Time.now())
    };

    private func generateKeyId() : Text {
        "key_" # Nat.toText(Time.now())
    };

    private func validateEncryptionJob(job : Types.EncryptionJob) : Bool {
        Utils.isNotEmpty(job.fileId) and
        Utils.isValidEncryptionAlgorithm(job.algorithm) and
        Utils.isValidEncryptionMode(job.mode)
    };

    private func validateEncryptionKey(key : Types.EncryptionKey) : Bool {
        Utils.isNotEmpty(key.id) and
        Utils.isValidEncryptionAlgorithm(key.algorithm) and
        Utils.isValidKeySize(key.size)
    };

    private func updateEncryptionStats(fileId : Text, action : Types.EncryptionAction) : () {
        let stats = switch (HashMap.get(encryptionStats, Text.equal, fileId)) {
            case (?s) { s };
            case null {
                {
                    fileId = fileId;
                    encryptions = 0;
                    decryptions = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedStats = switch (action) {
            case (#encrypt) { { stats with encryptions = stats.encryptions + 1 } };
            case (#decrypt) { { stats with decryptions = stats.decryptions + 1 } }
        };
        HashMap.put(encryptionStats, Text.equal, fileId, updatedStats)
    };

    private func logEncryptionHistory(fileId : Text, action : Types.EncryptionAction, userId : Text) : () {
        let historyId = generateJobId();
        let history = {
            id = historyId;
            fileId = fileId;
            userId = userId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(encryptionHistory, Text.equal, historyId, history)
    };

    // Public shared functions
    public shared(msg) func generateEncryptionKey(algorithm : Text, size : Nat) : async Result.Result<Text, Text> {
        let keyId = generateKeyId();
        let key = {
            id = keyId;
            algorithm = algorithm;
            size = size;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateEncryptionKey(key)) {
            return #err(Constants.ERROR_INVALID_ENCRYPTION_KEY)
        };
        HashMap.put(encryptionKeys, Text.equal, keyId, key);
        #ok(keyId)
    };

    public shared(msg) func encryptFile(fileId : Text, keyId : Text, algorithm : Text, mode : Text) : async Result.Result<Text, Text> {
        let jobId = generateJobId();
        let job = {
            id = jobId;
            fileId = fileId;
            keyId = keyId;
            algorithm = algorithm;
            mode = mode;
            status = #pending;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateEncryptionJob(job)) {
            return #err(Constants.ERROR_INVALID_ENCRYPTION_JOB)
        };
        HashMap.put(encryptionJobs, Text.equal, jobId, job);
        updateEncryptionStats(fileId, #encrypt);
        logEncryptionHistory(fileId, #encrypt, Principal.toText(msg.caller));
        #ok(jobId)
    };

    public shared(msg) func decryptFile(fileId : Text, keyId : Text) : async Result.Result<Text, Text> {
        let jobId = generateJobId();
        let job = {
            id = jobId;
            fileId = fileId;
            keyId = keyId;
            algorithm = "none";
            mode = "none";
            status = #pending;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        HashMap.put(encryptionJobs, Text.equal, jobId, job);
        updateEncryptionStats(fileId, #decrypt);
        logEncryptionHistory(fileId, #decrypt, Principal.toText(msg.caller));
        #ok(jobId)
    };

    public shared(msg) func getEncryptionJob(jobId : Text) : async Result.Result<Types.EncryptionJob, Text> {
        switch (HashMap.get(encryptionJobs, Text.equal, jobId)) {
            case (?job) { #ok(job) };
            case null { #err(Constants.ERROR_ENCRYPTION_JOB_NOT_FOUND) }
        }
    };

    public shared(msg) func updateEncryptionJobStatus(jobId : Text, status : Types.EncryptionStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(encryptionJobs, Text.equal, jobId)) {
            case (?job) {
                let updatedJob = {
                    job with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(encryptionJobs, Text.equal, jobId, updatedJob);
                #ok()
            };
            case null { #err(Constants.ERROR_ENCRYPTION_JOB_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getEncryptionKey(keyId : Text) : async ?Types.EncryptionKey {
        HashMap.get(encryptionKeys, Text.equal, keyId)
    };

    public query func getEncryptionStats(fileId : Text) : async ?Types.EncryptionStats {
        HashMap.get(encryptionStats, Text.equal, fileId)
    };

    public query func getEncryptionHistory() : async [Types.EncryptionHistory] {
        let history = HashMap.entries(encryptionHistory);
        Array.map(history, func((id, h) : (Text, Types.EncryptionHistory)) : Types.EncryptionHistory { h })
    };

    public query func getEncryptionHistoryByFile(fileId : Text) : async [Types.EncryptionHistory] {
        let history = HashMap.entries(encryptionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.EncryptionHistory)) : Bool {
            h.fileId == fileId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.EncryptionHistory)) : Types.EncryptionHistory { h })
    };

    public query func getEncryptionHistoryByUser(userId : Text) : async [Types.EncryptionHistory] {
        let history = HashMap.entries(encryptionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.EncryptionHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.EncryptionHistory)) : Types.EncryptionHistory { h })
    };

    public query func getEncryptionHistoryByAction(action : Types.EncryptionAction) : async [Types.EncryptionHistory] {
        let history = HashMap.entries(encryptionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.EncryptionHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.EncryptionHistory)) : Types.EncryptionHistory { h })
    };

    public query func getEncryptionHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.EncryptionHistory] {
        let history = HashMap.entries(encryptionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.EncryptionHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.EncryptionHistory)) : Types.EncryptionHistory { h })
    };
}; 