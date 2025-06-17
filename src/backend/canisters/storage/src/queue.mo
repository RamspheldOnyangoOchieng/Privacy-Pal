

actor class QueueCanister {
    // State variables
    private stable var queueItems = HashMap.new<Text, Types.QueueItem>();
    private stable var queueStats = HashMap.new<Text, Types.QueueStats>();
    private stable var queueHistory = HashMap.new<Text, Types.QueueHistory>();

    // Private helper functions
    private func generateQueueItemId() : Text {
        "queue_" # Nat.toText(Time.now())
    };

    private func validateQueueItem(item : Types.QueueItem) : Bool {
        Utils.isNotEmpty(item.fileId) and
        Utils.isValidQueuePriority(item.priority) and
        Utils.isValidQueueRetries(item.retries)
    };

    private func updateQueueStats(fileId : Text, action : Types.QueueAction) : () {
        let stats = switch (HashMap.get(queueStats, Text.equal, fileId)) {
            case (?s) { s };
            case null {
                {
                    fileId = fileId;
                    enqueued = 0;
                    dequeued = 0;
                    failed = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedStats = switch (action) {
            case (#enqueue) { { stats with enqueued = stats.enqueued + 1 } };
            case (#dequeue) { { stats with dequeued = stats.dequeued + 1 } };
            case (#fail) { { stats with failed = stats.failed + 1 } }
        };
        HashMap.put(queueStats, Text.equal, fileId, updatedStats)
    };

    private func logQueueHistory(fileId : Text, action : Types.QueueAction, userId : Text) : () {
        let historyId = generateQueueItemId();
        let history = {
            id = historyId;
            fileId = fileId;
            userId = userId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(queueHistory, Text.equal, historyId, history)
    };

    // Public shared functions
    public shared(msg) func enqueueFile(fileId : Text, priority : Nat, retries : Nat) : async Result.Result<Text, Text> {
        let itemId = generateQueueItemId();
        let item = {
            id = itemId;
            fileId = fileId;
            priority = priority;
            retries = retries;
            status = #pending;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateQueueItem(item)) {
            return #err(Constants.ERROR_INVALID_QUEUE_ITEM)
        };
        HashMap.put(queueItems, Text.equal, itemId, item);
        updateQueueStats(fileId, #enqueue);
        logQueueHistory(fileId, #enqueue, Principal.toText(msg.caller));
        #ok(itemId)
    };

    public shared(msg) func dequeueFile() : async Result.Result<Types.QueueItem, Text> {
        let items = HashMap.entries(queueItems);
        let pendingItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem)) : Bool {
            item.status == #pending
        });
        if (Array.size(pendingItems) == 0) {
            return #err(Constants.ERROR_QUEUE_EMPTY)
        };
        let sortedItems = Array.sort(pendingItems, func((id1, item1) : (Text, Types.QueueItem), (id2, item2) : (Text, Types.QueueItem)) : Order.Order {
            if (item1.priority > item2.priority) { #greater }
            else if (item1.priority < item2.priority) { #less }
            else if (item1.createdAt < item2.createdAt) { #less }
            else if (item1.createdAt > item2.createdAt) { #greater }
            else { #equal }
        });
        let (itemId, item) = Array.get(sortedItems, 0).unwrap();
        let updatedItem = {
            item with
            status = #processing;
            updatedAt = Time.now()
        };
        HashMap.put(queueItems, Text.equal, itemId, updatedItem);
        updateQueueStats(item.fileId, #dequeue);
        logQueueHistory(item.fileId, #dequeue, Principal.toText(msg.caller));
        #ok(updatedItem)
    };

    public shared(msg) func updateQueueItemStatus(itemId : Text, status : Types.QueueStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(queueItems, Text.equal, itemId)) {
            case (?item) {
                let updatedItem = {
                    item with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(queueItems, Text.equal, itemId, updatedItem);
                if (status == #failed) {
                    updateQueueStats(item.fileId, #fail);
                    logQueueHistory(item.fileId, #fail, Principal.toText(msg.caller))
                };
                #ok()
            };
            case null { #err(Constants.ERROR_QUEUE_ITEM_NOT_FOUND) }
        }
    };

    public shared(msg) func retryQueueItem(itemId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(queueItems, Text.equal, itemId)) {
            case (?item) {
                if (item.retries <= 0) {
                    return #err(Constants.ERROR_MAX_RETRIES_EXCEEDED)
                };
                let updatedItem = {
                    item with
                    status = #pending;
                    retries = item.retries - 1;
                    updatedAt = Time.now()
                };
                HashMap.put(queueItems, Text.equal, itemId, updatedItem);
                updateQueueStats(item.fileId, #enqueue);
                logQueueHistory(item.fileId, #enqueue, Principal.toText(msg.caller));
                #ok()
            };
            case null { #err(Constants.ERROR_QUEUE_ITEM_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getQueueStats(fileId : Text) : async ?Types.QueueStats {
        HashMap.get(queueStats, Text.equal, fileId)
    };

    public query func getQueueHistory() : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        Array.map(history, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };

    public query func getQueueHistoryByFile(fileId : Text) : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.QueueHistory)) : Bool {
            h.fileId == fileId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };

    public query func getQueueHistoryByUser(userId : Text) : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.QueueHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };

    public query func getQueueHistoryByAction(action : Types.QueueAction) : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.QueueHistory)) : Bool {
            h.action == action
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };

    public query func getQueueHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.QueueHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };
}; 