module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Queue size limits
    public let MIN_QUEUE_SIZE : Nat = 0;
    public let MAX_QUEUE_SIZE : Nat = 100000;
    public let DEFAULT_QUEUE_SIZE : Nat = 1000;
    public let MIN_QUEUE_ITEMS : Nat = 0;
    public let MAX_QUEUE_ITEMS : Nat = 100000;
    public let DEFAULT_QUEUE_ITEMS : Nat = 1000;
    public let MIN_QUEUE_ITEM_SIZE : Nat = 0;
    public let MAX_QUEUE_ITEM_SIZE : Nat = 1048576; // 1MB in bytes
    public let DEFAULT_QUEUE_ITEM_SIZE : Nat = 1024; // 1KB in bytes

    // Queue time limits
    public let MIN_QUEUE_TIMEOUT : Nat = 1;
    public let MAX_QUEUE_TIMEOUT : Nat = 3600;
    public let DEFAULT_QUEUE_TIMEOUT : Nat = 30;
    public let MIN_QUEUE_RETRY : Nat = 0;
    public let MAX_QUEUE_RETRY : Nat = 10;
    public let DEFAULT_QUEUE_RETRY : Nat = 3;
    public let MIN_QUEUE_DELAY : Nat = 0;
    public let MAX_QUEUE_DELAY : Nat = 3600;
    public let DEFAULT_QUEUE_DELAY : Nat = 0;
    public let MIN_QUEUE_INTERVAL : Nat = 1;
    public let MAX_QUEUE_INTERVAL : Nat = 3600;
    public let DEFAULT_QUEUE_INTERVAL : Nat = 60;

    // Queue priority limits
    public let MIN_QUEUE_PRIORITY : Nat = 0;
    public let MAX_QUEUE_PRIORITY : Nat = 10;
    public let DEFAULT_QUEUE_PRIORITY : Nat = 5;
    public let MIN_QUEUE_WEIGHT : Nat = 0;
    public let MAX_QUEUE_WEIGHT : Nat = 100;
    public let DEFAULT_QUEUE_WEIGHT : Nat = 50;
    public let MIN_QUEUE_THRESHOLD : Nat = 0;
    public let MAX_QUEUE_THRESHOLD : Nat = 100;
    public let DEFAULT_QUEUE_THRESHOLD : Nat = 80;

    // Queue status types
    public let QUEUE_STATUS_PENDING : Text = "pending";
    public let QUEUE_STATUS_PROCESSING : Text = "processing";
    public let QUEUE_STATUS_COMPLETED : Text = "completed";
    public let QUEUE_STATUS_FAILED : Text = "failed";
    public let QUEUE_STATUS_CANCELLED : Text = "cancelled";
    public let QUEUE_STATUS_TIMEOUT : Text = "timeout";
    public let QUEUE_STATUS_RETRY : Text = "retry";
    public let QUEUE_STATUS_DELAYED : Text = "delayed";
    public let QUEUE_STATUS_SCHEDULED : Text = "scheduled";
    public let QUEUE_STATUS_PAUSED : Text = "paused";
    public let QUEUE_STATUS_RESUMED : Text = "resumed";
    public let QUEUE_STATUS_STOPPED : Text = "stopped";
    public let QUEUE_STATUS_STARTED : Text = "started";
    public let QUEUE_STATUS_RESTARTED : Text = "restarted";
    public let QUEUE_STATUS_CLEARED : Text = "cleared";
    public let QUEUE_STATUS_DRAINED : Text = "drained";
    public let QUEUE_STATUS_FLUSHED : Text = "flushed";
    public let QUEUE_STATUS_RESET : Text = "reset";
    public let QUEUE_STATUS_INITIALIZED : Text = "initialized";
    public let QUEUE_STATUS_DESTROYED : Text = "destroyed";

    // Queue type types
    public let QUEUE_TYPE_FIFO : Text = "fifo";
    public let QUEUE_TYPE_LIFO : Text = "lifo";
    public let QUEUE_TYPE_PRIORITY : Text = "priority";
    public let QUEUE_TYPE_WEIGHTED : Text = "weighted";
    public let QUEUE_TYPE_DELAY : Text = "delay";
    public let QUEUE_TYPE_SCHEDULED : Text = "scheduled";
    public let QUEUE_TYPE_RETRY : Text = "retry";
    public let QUEUE_TYPE_DEAD_LETTER : Text = "dead-letter";
    public let QUEUE_TYPE_BATCH : Text = "batch";
    public let QUEUE_TYPE_STREAM : Text = "stream";
    public let QUEUE_TYPE_PUBLISH_SUBSCRIBE : Text = "pub-sub";
    public let QUEUE_TYPE_REQUEST_REPLY : Text = "request-reply";
    public let QUEUE_TYPE_WORK_QUEUE : Text = "work-queue";
    public let QUEUE_TYPE_TASK_QUEUE : Text = "task-queue";
    public let QUEUE_TYPE_JOB_QUEUE : Text = "job-queue";
    public let QUEUE_TYPE_MESSAGE_QUEUE : Text = "message-queue";
    public let QUEUE_TYPE_EVENT_QUEUE : Text = "event-queue";
    public let QUEUE_TYPE_COMMAND_QUEUE : Text = "command-queue";
    public let QUEUE_TYPE_NOTIFICATION_QUEUE : Text = "notification-queue";
    public let QUEUE_TYPE_ALERT_QUEUE : Text = "alert-queue";

    // Error messages
    public let ERROR_INVALID_QUEUE_SIZE : Text = "Invalid queue size";
    public let ERROR_INVALID_QUEUE_ITEMS : Text = "Invalid number of queue items";
    public let ERROR_INVALID_QUEUE_ITEM_SIZE : Text = "Invalid queue item size";
    public let ERROR_INVALID_QUEUE_TIMEOUT : Text = "Invalid queue timeout";
    public let ERROR_INVALID_QUEUE_RETRY : Text = "Invalid queue retry";
    public let ERROR_INVALID_QUEUE_DELAY : Text = "Invalid queue delay";
    public let ERROR_INVALID_QUEUE_INTERVAL : Text = "Invalid queue interval";
    public let ERROR_INVALID_QUEUE_PRIORITY : Text = "Invalid queue priority";
    public let ERROR_INVALID_QUEUE_WEIGHT : Text = "Invalid queue weight";
    public let ERROR_INVALID_QUEUE_THRESHOLD : Text = "Invalid queue threshold";
    public let ERROR_INVALID_QUEUE_STATUS : Text = "Invalid queue status";
    public let ERROR_INVALID_QUEUE_TYPE : Text = "Invalid queue type";

    // Status messages
    public let STATUS_QUEUE_CREATED : Text = "Queue created successfully";
    public let STATUS_QUEUE_DELETED : Text = "Queue deleted successfully";
    public let STATUS_QUEUE_UPDATED : Text = "Queue updated successfully";
    public let STATUS_QUEUE_CLEARED : Text = "Queue cleared successfully";
    public let STATUS_QUEUE_ITEM_CREATED : Text = "Queue item created successfully";
    public let STATUS_QUEUE_ITEM_DELETED : Text = "Queue item deleted successfully";
    public let STATUS_QUEUE_ITEM_UPDATED : Text = "Queue item updated successfully";
    public let STATUS_QUEUE_ITEM_PROCESSED : Text = "Queue item processed successfully";
    public let STATUS_QUEUE_ITEM_FAILED : Text = "Queue item failed";
    public let STATUS_QUEUE_ITEM_CANCELLED : Text = "Queue item cancelled";
    public let STATUS_QUEUE_ITEM_TIMEOUT : Text = "Queue item timed out";
    public let STATUS_QUEUE_ITEM_RETRY : Text = "Queue item retry";
    public let STATUS_QUEUE_ITEM_DELAYED : Text = "Queue item delayed";
    public let STATUS_QUEUE_ITEM_SCHEDULED : Text = "Queue item scheduled";
    public let STATUS_QUEUE_ITEM_PAUSED : Text = "Queue item paused";
    public let STATUS_QUEUE_ITEM_RESUMED : Text = "Queue item resumed";
    public let STATUS_QUEUE_ITEM_STOPPED : Text = "Queue item stopped";
    public let STATUS_QUEUE_ITEM_STARTED : Text = "Queue item started";
    public let STATUS_QUEUE_ITEM_RESTARTED : Text = "Queue item restarted";
    public let STATUS_QUEUE_ITEM_CLEARED : Text = "Queue item cleared";
    public let STATUS_QUEUE_ITEM_DRAINED : Text = "Queue item drained";
    public let STATUS_QUEUE_ITEM_FLUSHED : Text = "Queue item flushed";
    public let STATUS_QUEUE_ITEM_RESET : Text = "Queue item reset";
    public let STATUS_QUEUE_ITEM_INITIALIZED : Text = "Queue item initialized";
    public let STATUS_QUEUE_ITEM_DESTROYED : Text = "Queue item destroyed";

    // Feature flags
    public let ENABLE_QUEUE_CREATION : Bool = true;
    public let ENABLE_QUEUE_DELETION : Bool = true;
    public let ENABLE_QUEUE_UPDATE : Bool = true;
    public let ENABLE_QUEUE_CLEAR : Bool = true;
    public let ENABLE_QUEUE_ITEM_CREATION : Bool = true;
    public let ENABLE_QUEUE_ITEM_DELETION : Bool = true;
    public let ENABLE_QUEUE_ITEM_UPDATE : Bool = true;
    public let ENABLE_QUEUE_ITEM_PROCESSING : Bool = true;
    public let ENABLE_QUEUE_ITEM_RETRY : Bool = true;
    public let ENABLE_QUEUE_ITEM_DELAY : Bool = true;
    public let ENABLE_QUEUE_ITEM_SCHEDULING : Bool = true;
    public let ENABLE_QUEUE_ITEM_PAUSING : Bool = true;
    public let ENABLE_QUEUE_ITEM_RESUMING : Bool = true;
    public let ENABLE_QUEUE_ITEM_STOPPING : Bool = true;
    public let ENABLE_QUEUE_ITEM_STARTING : Bool = true;
    public let ENABLE_QUEUE_ITEM_RESTARTING : Bool = true;
    public let ENABLE_QUEUE_ITEM_CLEARING : Bool = true;
    public let ENABLE_QUEUE_ITEM_DRAINING : Bool = true;
    public let ENABLE_QUEUE_ITEM_FLUSHING : Bool = true;
    public let ENABLE_QUEUE_ITEM_RESETTING : Bool = true;
    public let ENABLE_QUEUE_ITEM_INITIALIZING : Bool = true;
    public let ENABLE_QUEUE_ITEM_DESTROYING : Bool = true;
    public let ENABLE_QUEUE_COMPRESSION : Bool = true;
    public let ENABLE_QUEUE_ENCRYPTION : Bool = true;
    public let ENABLE_QUEUE_PERSISTENCE : Bool = true;
    public let ENABLE_QUEUE_DISTRIBUTION : Bool = true;
    public let ENABLE_QUEUE_REPLICATION : Bool = true;
}; 