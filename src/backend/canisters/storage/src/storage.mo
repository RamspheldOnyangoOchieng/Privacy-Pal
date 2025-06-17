

actor class StorageCanister() {
    // State
    private var files = HashMap.HashMap<Text, Types.File>(0, Text.equal, Text.hash);
    private var chunks = HashMap.HashMap<Text, Types.Chunk>(0, Text.equal, Text.hash);
    private var metadata = HashMap.HashMap<Text, Types.FileMetadata>(0, Text.equal, Text.hash);
    private var permissions = HashMap.HashMap<Text, Types.FilePermission>(0, Text.equal, Text.hash);
    private var storageMetrics = HashMap.HashMap<Text, Types.StorageMetrics>(0, Text.equal, Text.hash);
    private var accessLogs = HashMap.HashMap<Text, [Types.AccessLog]>(0, Text.equal, Text.hash);
    private var backupStatus = HashMap.HashMap<Text, Types.BackupStatus>(0, Text.equal, Text.hash);
    private var storageHistory = HashMap.HashMap<Text, Types.StorageHistory>(0, Text.equal, Text.hash);

    // Types
    private type File = {
        id: Text;
        content: Blob;
        metadata: FileMetadata;
        createdAt: Int;
        updatedAt: Int;
        size: Nat;
        type: FileType;
        status: FileStatus;
    };

    private type FileMetadata = {
        name: Text;
        description: ?Text;
        tags: [Text];
        owner: Principal;
        visibility: Visibility;
        encryption: EncryptionInfo;
        version: Nat;
    };

    private type FileType = {
        #Document;
        #Image;
        #Video;
        #Audio;
        #Other;
    };

    private type FileStatus = {
        #Active;
        #Archived;
        #Deleted;
    };

    private type Visibility = {
        #Public;
        #Private;
        #Restricted;
    };

    private type EncryptionInfo = {
        algorithm: Text;
        keyVersion: Nat;
        iv: Blob;
    };

    private type EncryptionKey = {
        key: Blob;
        iv: Blob;
        createdAt: Int;
        expiresAt: Int;
    };

    private type StorageMetrics = {
        totalFiles: Nat;
        totalSize: Nat;
        filesByType: [(Text, Nat)];
        storageByUser: [(Text, Nat)];
        lastUpdated: Int;
    };

    private type AccessLog = {
        timestamp: Int;
        action: AccessAction;
        user: Principal;
        ipAddress: ?Text;
        success: Bool;
    };

    private type AccessAction = {
        #Read;
        #Write;
        #Delete;
        #Share;
    };

    private type BackupStatus = {
        lastBackup: Int;
        nextBackup: Int;
        status: BackupState;
        size: Nat;
    };

    private type BackupState = {
        #Pending;
        #InProgress;
        #Completed;
        #Failed;
    };

    // Helper Functions
    private func generateFileId() : Text {
        "file_" # Nat.toText(Time.now())
    };

    private func generateChunkId() : Text {
        "chunk_" # Nat.toText(Time.now())
    };

    private func validateFile(file : Types.File) : Bool {
        Utils.isNotEmpty(file.name) and
        file.size > 0 and
        file.size <= Constants.MAX_FILE_SIZE and
        Utils.isValidMimeType(file.mimeType)
    };

    private func validateChunk(chunk : Types.Chunk) : Bool {
        chunk.size > 0 and
        chunk.size <= Constants.MAX_CHUNK_SIZE
    };

    private func checkUserQuota(userId: Principal) : async Bool {
        var totalSize = 0;
        for ((_, file) in files.entries()) {
            if (file.metadata.owner == userId) {
                totalSize += file.size;
            };
        };
        totalSize <= AppConstants.MAX_STORAGE_PER_USER
    };

    private func logAccess(
        fileId: Text,
        action: AccessAction,
        user: Principal,
        ipAddress: ?Text,
        success: Bool
    ) {
        let log: AccessLog = {
            timestamp = Time.now();
            action = action;
            user = user;
            ipAddress = ipAddress;
            success = success;
        };

        switch (accessLogs.get(fileId)) {
            case (?logs) {
                let updatedLogs = Array.append(logs, [log]);
                accessLogs.put(fileId, updatedLogs);
            };
            case null {
                accessLogs.put(fileId, [log]);
            };
        };
    };

    private func updateStorageMetrics(fileId : Text, action : Types.StorageAction) : () {
        let metrics = switch (HashMap.get(storageMetrics, Text.equal, fileId)) {
            case (?m) { m };
            case null {
                {
                    fileId = fileId;
                    uploads = 0;
                    downloads = 0;
                    deletes = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedMetrics = switch (action) {
            case (#upload) { { metrics with uploads = metrics.uploads + 1 } };
            case (#download) { { metrics with downloads = metrics.downloads + 1 } };
            case (#delete) { { metrics with deletes = metrics.deletes + 1 } }
        };
        HashMap.put(storageMetrics, Text.equal, fileId, updatedMetrics)
    };

    private func logStorageHistory(fileId : Text, action : Types.StorageAction, userId : Text) : () {
        let historyId = generateFileId();
        let history = {
            id = historyId;
            fileId = fileId;
            userId = userId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(storageHistory, Text.equal, historyId, history)
    };

    // Public Functions
    public shared(msg) func uploadFile(file : Types.File, chunks : [Types.Chunk]) : async Result.Result<Text, Text> {
        if (not validateFile(file)) {
            return #err(Constants.ERROR_INVALID_FILE)
        };
        for (chunk in chunks.vals()) {
            if (not validateChunk(chunk)) {
                return #err(Constants.ERROR_INVALID_CHUNK)
            }
        };
        let fileId = generateFileId();
        let newFile = {
            id = fileId;
            name = file.name;
            size = file.size;
            mimeType = file.mimeType;
            chunks = chunks;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        HashMap.put(files, Text.equal, fileId, newFile);
        updateStorageMetrics(fileId, #upload);
        logStorageHistory(fileId, #upload, Principal.toText(msg.caller));
        #ok(fileId)
    };

    public shared(msg) func downloadFile(fileId : Text) : async Result.Result<Types.File, Text> {
        switch (files.get(fileId)) {
            case (?file) {
                // Check access permissions
                if (file.metadata.owner != msg.caller and file.metadata.visibility == #Private) {
                    return #err(Constants.ERROR_ACCESS_DENIED)
                };

                // Log access
                logAccess(fileId, #Read, msg.caller, null, true);

                updateStorageMetrics(fileId, #download);
                logStorageHistory(fileId, #download, Principal.toText(msg.caller));
                #ok(file)
            };
            case null { #err(Constants.ERROR_FILE_NOT_FOUND) }
        }
    };

    public shared(msg) func deleteFile(fileId : Text) : async Result.Result<(), Text> {
        switch (files.get(fileId)) {
            case (?file) {
                // Check ownership
                if (file.metadata.owner != msg.caller) {
                    return #err(Constants.ERROR_NOT_AUTHORIZED)
                };

                // Delete file
                files.delete(fileId);
                metadata.delete(fileId);
                accessLogs.delete(fileId);

                // Log access
                logAccess(fileId, #Delete, msg.caller, null, true);

                updateStorageMetrics(fileId, #delete);
                logStorageHistory(fileId, #delete, Principal.toText(msg.caller));
                #ok()
            };
            case null { #err(Constants.ERROR_FILE_NOT_FOUND) }
        }
    };

    public shared(msg) func updateFileMetadata(fileId : Text, metadata : Types.FileMetadata) : async Result.Result<(), Text> {
        switch (files.get(fileId)) {
            case (?file) {
                HashMap.put(metadata, Text.equal, fileId, metadata);
                #ok()
            };
            case null { #err(Constants.ERROR_FILE_NOT_FOUND) }
        }
    };

    public shared(msg) func setFilePermission(fileId : Text, permission : Types.FilePermission) : async Result.Result<(), Text> {
        switch (files.get(fileId)) {
            case (?file) {
                HashMap.put(permissions, Text.equal, fileId, permission);
                #ok()
            };
            case null { #err(Constants.ERROR_FILE_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getFile(fileId : Text) : async ?Types.File {
        files.get(fileId)
    };

    public query func getFileMetadata(fileId : Text) : async ?Types.FileMetadata {
        metadata.get(fileId)
    };

    public query func getFilePermission(fileId : Text) : async ?Types.FilePermission {
        permissions.get(fileId)
    };

    public query func getStorageMetrics(fileId : Text) : async ?Types.StorageMetrics {
        storageMetrics.get(fileId)
    };

    public query func getStorageHistory() : async [Types.StorageHistory] {
        let history = HashMap.entries(storageHistory);
        Array.map(history, func((id, h) : (Text, Types.StorageHistory)) : Types.StorageHistory { h })
    };

    public query func getStorageHistoryByFile(fileId : Text) : async [Types.StorageHistory] {
        let history = HashMap.entries(storageHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.StorageHistory)) : Bool {
            h.fileId == fileId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.StorageHistory)) : Types.StorageHistory { h })
    };

    public query func getStorageHistoryByUser(userId : Text) : async [Types.StorageHistory] {
        let history = HashMap.entries(storageHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.StorageHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.StorageHistory)) : Types.StorageHistory { h })
    };

    public query func getStorageHistoryByAction(action : Types.StorageAction) : async [Types.StorageHistory] {
        let history = HashMap.entries(storageHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.StorageHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.StorageHistory)) : Types.StorageHistory { h })
    };

    public query func getStorageHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.StorageHistory] {
        let history = HashMap.entries(storageHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.StorageHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.StorageHistory)) : Types.StorageHistory { h })
    };
}; 