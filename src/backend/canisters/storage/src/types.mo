module Types {
    // Basic types
    public type FileId = Text;
    public type ChunkId = Text;
    public type UserId = Text;
    public type Time = Nat;
    public type Size = Nat;
    public type MimeType = Text;
    public type Hash = Text;
    public type Path = Text;
    public type Url = Text;
    public type Status = Text;
    public type Error = Text;
    public type Result<T> = {
        #ok : T;
        #err : Error;
    };
    public type Option<T> = ?T;

    // File types
    public type File = {
        id : FileId;
        name : Text;
        size : Size;
        mimeType : MimeType;
        chunks : [Chunk];
        createdAt : Time;
        updatedAt : Time;
    };

    public type Chunk = {
        id : ChunkId;
        fileId : FileId;
        index : Nat;
        size : Size;
        data : [Nat8];
        hash : Hash;
        createdAt : Time;
    };

    public type FileMetadata = {
        fileId : FileId;
        description : Text;
        tags : [Text];
        category : Text;
        owner : UserId;
        isPublic : Bool;
        isEncrypted : Bool;
        encryptionKey : ?Hash;
        compressionType : ?Text;
        version : Nat;
        createdAt : Time;
        updatedAt : Time;
    };

    public type FilePermission = {
        fileId : FileId;
        owner : UserId;
        readAccess : [UserId];
        writeAccess : [UserId];
        deleteAccess : [UserId];
        shareAccess : [UserId];
        createdAt : Time;
        updatedAt : Time;
    };

    // Storage types
    public type StorageAction = {
        #upload;
        #download;
        #delete;
        #update;
        #share;
    };

    public type StorageMetrics = {
        fileId : FileId;
        uploads : Nat;
        downloads : Nat;
        deletes : Nat;
        lastUpdated : Time;
    };

    public type StorageHistory = {
        id : Text;
        fileId : FileId;
        userId : UserId;
        action : StorageAction;
        timestamp : Time;
    };

    // Cache types
    public type CacheEntry<T> = {
        data : T;
        timestamp : Time;
        ttl : Nat;
    };

    public type CacheStats = {
        cacheType : Text;
        hits : Nat;
        misses : Nat;
        lastUpdated : Time;
    };

    // Queue types
    public type QueueItem<T> = {
        id : Text;
        data : T;
        priority : Nat;
        status : QueueStatus;
        retries : Nat;
        createdAt : Time;
        updatedAt : Time;
    };

    public type QueueStatus = {
        #pending;
        #processing;
        #completed;
        #failed;
    };

    public type QueueStats = {
        queueType : Text;
        enqueued : Nat;
        dequeued : Nat;
        failed : Nat;
        lastUpdated : Time;
    };

    public type QueueHistory = {
        id : Text;
        queueType : Text;
        itemId : Text;
        action : QueueAction;
        timestamp : Time;
    };

    public type QueueAction = {
        #enqueue;
        #dequeue;
        #fail;
    };

    // Security types
    public type SecurityEvent = {
        type : SecurityEventType;
        principalId : Text;
        details : Text;
    };

    public type SecurityEventType = {
        #accessGranted;
        #accessDenied;
        #rateLimitExceeded;
        #principalBlacklisted;
        #principalWhitelisted;
        #rateLimitSet;
        #accessControlSet;
    };

    public type SecurityLog = {
        id : Text;
        event : SecurityEvent;
        timestamp : Time;
    };

    // Integration types
    public type IntegrationHistory = {
        id : Text;
        source : Text;
        target : Text;
        action : Text;
        status : Text;
        timestamp : Time;
    };

    // Analytics types
    public type AnalyticsAction = {
        #reportCreated;
        #reportViewed;
        #submissionMade;
        #commentPosted;
        #attachmentUploaded;
    };

    public type AnalyticsHistory = {
        id : Text;
        userId : Text;
        action : AnalyticsAction;
        details : Text;
        timestamp : Time;
    };

    // Filter types
    public type Filter = {
        id : Text;
        name : Text;
        description : Text;
        conditions : [FilterCondition];
        operator : FilterOperator;
        value : Text;
        createdAt : Time;
        updatedAt : Time;
    };

    public type FilterCondition = {
        field : Text;
        operator : FilterOperator;
        value : Text;
    };

    public type FilterOperator = {
        #equals;
        #contains;
        #startsWith;
        #endsWith;
        #greaterThan;
        #lessThan;
        #between;
        #inList;
        #regex;
    };

    public type FilterTemplate = {
        id : Text;
        name : Text;
        description : Text;
        filters : [Filter];
        createdAt : Time;
        updatedAt : Time;
    };

    public type FilterHistory = {
        id : Text;
        userId : Text;
        filterId : Text;
        action : Text;
        timestamp : Time;
    };

    // Sort types
    public type SortBy = {
        field : Text;
        direction : SortDirection;
    };

    public type SortDirection = {
        #ascending;
        #descending;
    };
}; 