

actor class CompressionCanister {
    // State variables
    private stable var compressionJobs = HashMap.new<Text, Types.CompressionJob>();
    private stable var compressionHistory = HashMap.new<Text, Types.CompressionHistory>();
    private stable var compressionStats = HashMap.new<Text, Types.CompressionStats>();

    // Private helper functions
    private func generateJobId() : Text {
        "compression_" # Nat.toText(Time.now())
    };

    private func validateCompressionJob(job : Types.CompressionJob) : Bool {
        Utils.isNotEmpty(job.fileId) and
        job.compressionLevel >= 0 and
        job.compressionLevel <= 9 and
        Utils.isValidCompressionType(job.compressionType)
    };

    private func updateCompressionStats(fileId : Text, action : Types.CompressionAction) : () {
        let stats = switch (HashMap.get(compressionStats, Text.equal, fileId)) {
            case (?s) { s };
            case null {
                {
                    fileId = fileId;
                    compressions = 0;
                    decompressions = 0;
                    totalCompressedSize = 0;
                    totalOriginalSize = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedStats = switch (action) {
            case (#compress(compressedSize, originalSize)) {
                {
                    stats with
                    compressions = stats.compressions + 1;
                    totalCompressedSize = stats.totalCompressedSize + compressedSize;
                    totalOriginalSize = stats.totalOriginalSize + originalSize
                }
            };
            case (#decompress) {
                {
                    stats with
                    decompressions = stats.decompressions + 1
                }
            }
        };
        HashMap.put(compressionStats, Text.equal, fileId, updatedStats)
    };

    private func logCompressionHistory(fileId : Text, action : Types.CompressionAction, userId : Text) : () {
        let historyId = generateJobId();
        let history = {
            id = historyId;
            fileId = fileId;
            userId = userId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(compressionHistory, Text.equal, historyId, history)
    };

    // Public shared functions
    public shared(msg) func compressFile(fileId : Text, compressionType : Text, compressionLevel : Nat) : async Result.Result<Text, Text> {
        let jobId = generateJobId();
        let job = {
            id = jobId;
            fileId = fileId;
            compressionType = compressionType;
            compressionLevel = compressionLevel;
            status = #pending;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateCompressionJob(job)) {
            return #err(Constants.ERROR_INVALID_COMPRESSION_JOB)
        };
        HashMap.put(compressionJobs, Text.equal, jobId, job);
        // Simulate compression
        let compressedSize = 1000; // Example size
        let originalSize = 2000; // Example size
        updateCompressionStats(fileId, #compress(compressedSize, originalSize));
        logCompressionHistory(fileId, #compress(compressedSize, originalSize), Principal.toText(msg.caller));
        #ok(jobId)
    };

    public shared(msg) func decompressFile(fileId : Text) : async Result.Result<Text, Text> {
        let jobId = generateJobId();
        let job = {
            id = jobId;
            fileId = fileId;
            compressionType = "none";
            compressionLevel = 0;
            status = #pending;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        HashMap.put(compressionJobs, Text.equal, jobId, job);
        updateCompressionStats(fileId, #decompress);
        logCompressionHistory(fileId, #decompress, Principal.toText(msg.caller));
        #ok(jobId)
    };

    public shared(msg) func getCompressionJob(jobId : Text) : async Result.Result<Types.CompressionJob, Text> {
        switch (HashMap.get(compressionJobs, Text.equal, jobId)) {
            case (?job) { #ok(job) };
            case null { #err(Constants.ERROR_COMPRESSION_JOB_NOT_FOUND) }
        }
    };

    public shared(msg) func updateCompressionJobStatus(jobId : Text, status : Types.CompressionStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(compressionJobs, Text.equal, jobId)) {
            case (?job) {
                let updatedJob = {
                    job with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(compressionJobs, Text.equal, jobId, updatedJob);
                #ok()
            };
            case null { #err(Constants.ERROR_COMPRESSION_JOB_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getCompressionStats(fileId : Text) : async ?Types.CompressionStats {
        HashMap.get(compressionStats, Text.equal, fileId)
    };

    public query func getCompressionHistory() : async [Types.CompressionHistory] {
        let history = HashMap.entries(compressionHistory);
        Array.map(history, func((id, h) : (Text, Types.CompressionHistory)) : Types.CompressionHistory { h })
    };

    public query func getCompressionHistoryByFile(fileId : Text) : async [Types.CompressionHistory] {
        let history = HashMap.entries(compressionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CompressionHistory)) : Bool {
            h.fileId == fileId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CompressionHistory)) : Types.CompressionHistory { h })
    };

    public query func getCompressionHistoryByUser(userId : Text) : async [Types.CompressionHistory] {
        let history = HashMap.entries(compressionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CompressionHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CompressionHistory)) : Types.CompressionHistory { h })
    };

    public query func getCompressionHistoryByAction(action : Types.CompressionAction) : async [Types.CompressionHistory] {
        let history = HashMap.entries(compressionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CompressionHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CompressionHistory)) : Types.CompressionHistory { h })
    };

    public query func getCompressionHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.CompressionHistory] {
        let history = HashMap.entries(compressionHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.CompressionHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.CompressionHistory)) : Types.CompressionHistory { h })
    };
}; 