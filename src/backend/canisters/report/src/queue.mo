

actor class QueueCanister {
    // State variables
    private stable var reportQueue = HashMap.new<Text, Types.QueueItem<Types.Report>>();
    private stable var submissionQueue = HashMap.new<Text, Types.QueueItem<Types.ReportSubmission>>();
    private stable var notificationQueue = HashMap.new<Text, Types.QueueItem<Types.Notification>>();
    private stable var auditQueue = HashMap.new<Text, Types.QueueItem<Types.Audit>>();
    private stable var queueStats = HashMap.new<Text, Types.QueueStats>();
    private stable var queueHistory = HashMap.new<Text, Types.QueueHistory>();

    // Private helper functions
    private func generateQueueId() : Text {
        "queue_" # Nat.toText(Time.now())
    };

    private func validateQueueItem<T>(item : Types.QueueItem<T>) : Bool {
        item.priority >= 0 and
        item.priority <= Constants.MAX_QUEUE_PRIORITY and
        item.retries <= Constants.MAX_QUEUE_RETRIES
    };

    private func updateQueueStats(queueType : Text, action : Types.QueueAction) : () {
        let stats = switch (HashMap.get(queueStats, Text.equal, queueType)) {
            case (?s) { s };
            case null {
                {
                    queueType = queueType;
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
        HashMap.put(queueStats, Text.equal, queueType, updatedStats)
    };

    private func logQueueHistory(queueType : Text, itemId : Text, action : Types.QueueAction) : () {
        let historyId = generateQueueId();
        let history = {
            id = historyId;
            queueType = queueType;
            itemId = itemId;
            action = action;
            timestamp = Time.now()
        };
        HashMap.put(queueHistory, Text.equal, historyId, history)
    };

    // Public shared functions
    public shared(msg) func enqueueReport(report : Types.Report, priority : Nat) : async Result.Result<Text, Text> {
        let queueId = generateQueueId();
        let item = {
            id = queueId;
            data = report;
            priority = priority;
            status = #pending;
            retries = 0;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateQueueItem(item)) {
            return #err(Constants.ERROR_INVALID_QUEUE_ITEM)
        };
        HashMap.put(reportQueue, Text.equal, queueId, item);
        updateQueueStats("report", #enqueue);
        logQueueHistory("report", queueId, #enqueue);
        #ok(queueId)
    };

    public shared(msg) func enqueueSubmission(submission : Types.ReportSubmission, priority : Nat) : async Result.Result<Text, Text> {
        let queueId = generateQueueId();
        let item = {
            id = queueId;
            data = submission;
            priority = priority;
            status = #pending;
            retries = 0;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateQueueItem(item)) {
            return #err(Constants.ERROR_INVALID_QUEUE_ITEM)
        };
        HashMap.put(submissionQueue, Text.equal, queueId, item);
        updateQueueStats("submission", #enqueue);
        logQueueHistory("submission", queueId, #enqueue);
        #ok(queueId)
    };

    public shared(msg) func enqueueNotification(notification : Types.Notification, priority : Nat) : async Result.Result<Text, Text> {
        let queueId = generateQueueId();
        let item = {
            id = queueId;
            data = notification;
            priority = priority;
            status = #pending;
            retries = 0;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateQueueItem(item)) {
            return #err(Constants.ERROR_INVALID_QUEUE_ITEM)
        };
        HashMap.put(notificationQueue, Text.equal, queueId, item);
        updateQueueStats("notification", #enqueue);
        logQueueHistory("notification", queueId, #enqueue);
        #ok(queueId)
    };

    public shared(msg) func enqueueAudit(audit : Types.Audit, priority : Nat) : async Result.Result<Text, Text> {
        let queueId = generateQueueId();
        let item = {
            id = queueId;
            data = audit;
            priority = priority;
            status = #pending;
            retries = 0;
            createdAt = Time.now();
            updatedAt = Time.now()
        };
        if (not validateQueueItem(item)) {
            return #err(Constants.ERROR_INVALID_QUEUE_ITEM)
        };
        HashMap.put(auditQueue, Text.equal, queueId, item);
        updateQueueStats("audit", #enqueue);
        logQueueHistory("audit", queueId, #enqueue);
        #ok(queueId)
    };

    public shared(msg) func dequeueReport() : async ?Types.QueueItem<Types.Report> {
        let items = HashMap.entries(reportQueue);
        let pendingItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem<Types.Report>)) : Bool {
            item.status == #pending
        });
        if (Array.size(pendingItems) == 0) {
            return null
        };
        let sortedItems = Array.sort(pendingItems, func((id1, item1) : (Text, Types.QueueItem<Types.Report>), (id2, item2) : (Text, Types.QueueItem<Types.Report>)) : Order.Order {
            if (item1.priority > item2.priority) { #greater }
            else if (item1.priority < item2.priority) { #less }
            else { #equal }
        });
        let (queueId, item) = Array.get(sortedItems, 0);
        let updatedItem = {
            item with
            status = #processing;
            updatedAt = Time.now()
        };
        HashMap.put(reportQueue, Text.equal, queueId, updatedItem);
        updateQueueStats("report", #dequeue);
        logQueueHistory("report", queueId, #dequeue);
        ?updatedItem
    };

    public shared(msg) func dequeueSubmission() : async ?Types.QueueItem<Types.ReportSubmission> {
        let items = HashMap.entries(submissionQueue);
        let pendingItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem<Types.ReportSubmission>)) : Bool {
            item.status == #pending
        });
        if (Array.size(pendingItems) == 0) {
            return null
        };
        let sortedItems = Array.sort(pendingItems, func((id1, item1) : (Text, Types.QueueItem<Types.ReportSubmission>), (id2, item2) : (Text, Types.QueueItem<Types.ReportSubmission>)) : Order.Order {
            if (item1.priority > item2.priority) { #greater }
            else if (item1.priority < item2.priority) { #less }
            else { #equal }
        });
        let (queueId, item) = Array.get(sortedItems, 0);
        let updatedItem = {
            item with
            status = #processing;
            updatedAt = Time.now()
        };
        HashMap.put(submissionQueue, Text.equal, queueId, updatedItem);
        updateQueueStats("submission", #dequeue);
        logQueueHistory("submission", queueId, #dequeue);
        ?updatedItem
    };

    public shared(msg) func dequeueNotification() : async ?Types.QueueItem<Types.Notification> {
        let items = HashMap.entries(notificationQueue);
        let pendingItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem<Types.Notification>)) : Bool {
            item.status == #pending
        });
        if (Array.size(pendingItems) == 0) {
            return null
        };
        let sortedItems = Array.sort(pendingItems, func((id1, item1) : (Text, Types.QueueItem<Types.Notification>), (id2, item2) : (Text, Types.QueueItem<Types.Notification>)) : Order.Order {
            if (item1.priority > item2.priority) { #greater }
            else if (item1.priority < item2.priority) { #less }
            else { #equal }
        });
        let (queueId, item) = Array.get(sortedItems, 0);
        let updatedItem = {
            item with
            status = #processing;
            updatedAt = Time.now()
        };
        HashMap.put(notificationQueue, Text.equal, queueId, updatedItem);
        updateQueueStats("notification", #dequeue);
        logQueueHistory("notification", queueId, #dequeue);
        ?updatedItem
    };

    public shared(msg) func dequeueAudit() : async ?Types.QueueItem<Types.Audit> {
        let items = HashMap.entries(auditQueue);
        let pendingItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem<Types.Audit>)) : Bool {
            item.status == #pending
        });
        if (Array.size(pendingItems) == 0) {
            return null
        };
        let sortedItems = Array.sort(pendingItems, func((id1, item1) : (Text, Types.QueueItem<Types.Audit>), (id2, item2) : (Text, Types.QueueItem<Types.Audit>)) : Order.Order {
            if (item1.priority > item2.priority) { #greater }
            else if (item1.priority < item2.priority) { #less }
            else { #equal }
        });
        let (queueId, item) = Array.get(sortedItems, 0);
        let updatedItem = {
            item with
            status = #processing;
            updatedAt = Time.now()
        };
        HashMap.put(auditQueue, Text.equal, queueId, updatedItem);
        updateQueueStats("audit", #dequeue);
        logQueueHistory("audit", queueId, #dequeue);
        ?updatedItem
    };

    public shared(msg) func updateQueueItemStatus(queueType : Text, queueId : Text, status : Types.QueueStatus) : async Result.Result<(), Text> {
        let queue = switch (queueType) {
            case ("report") { reportQueue };
            case ("submission") { submissionQueue };
            case ("notification") { notificationQueue };
            case ("audit") { auditQueue };
            case _ { return #err(Constants.ERROR_INVALID_QUEUE_TYPE) }
        };
        switch (HashMap.get(queue, Text.equal, queueId)) {
            case (?item) {
                let updatedItem = {
                    item with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(queue, Text.equal, queueId, updatedItem);
                if (status == #failed) {
                    updateQueueStats(queueType, #fail)
                };
                #ok()
            };
            case null { #err(Constants.ERROR_QUEUE_ITEM_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getQueueStats() : async [Types.QueueStats] {
        let stats = HashMap.entries(queueStats);
        Array.map(stats, func((id, s) : (Text, Types.QueueStats)) : Types.QueueStats { s })
    };

    public query func getQueueStatsByType(queueType : Text) : async ?Types.QueueStats {
        HashMap.get(queueStats, Text.equal, queueType)
    };

    public query func getQueueHistory() : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        Array.map(history, func((id, h) : (Text, Types.QueueHistory)) : Types.QueueHistory { h })
    };

    public query func getQueueHistoryByType(queueType : Text) : async [Types.QueueHistory] {
        let history = HashMap.entries(queueHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.QueueHistory)) : Bool {
            h.queueType == queueType
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