import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import List "mo:base/List";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Types "../types";
import Utils "../utils";
import Constants "../constants";

actor class QueueCanister {
    // State variables
    private stable var queues = HashMap.new<Text, Types.Queue>();
    private stable var items = HashMap.new<Text, Types.QueueItem>();
    private stable var processors = HashMap.new<Principal, Types.QueueProcessor>();
    private stable var metrics = HashMap.new<Text, Types.QueueMetrics>();
    private stable var history = HashMap.new<Text, Types.QueueHistory>();

    // Private helper functions
    private func generateQueueId() : Text {
        "queue_" # Nat.toText(Time.now())
    };

    private func generateItemId() : Text {
        "item_" # Nat.toText(Time.now())
    };

    private func validateQueue(queue : Types.Queue) : Result.Result<(), Text> {
        if (Utils.isEmpty(queue.name)) {
            #err("Queue name cannot be empty")
        } else if (Utils.isEmpty(queue.description)) {
            #err("Queue description cannot be empty")
        } else if (queue.priority < 0 or queue.priority > 10) {
            #err("Queue priority must be between 0 and 10")
        } else if (queue.maxItems < 1) {
            #err("Queue max items must be greater than 0")
        } else if (queue.maxRetries < 0) {
            #err("Queue max retries must be greater than or equal to 0")
        } else if (queue.timeout < 0) {
            #err("Queue timeout must be greater than or equal to 0")
        } else {
            #ok()
        }
    };

    private func validateItem(item : Types.QueueItem) : Result.Result<(), Text> {
        if (Utils.isEmpty(item.data)) {
            #err("Item data cannot be empty")
        } else if (item.priority < 0 or item.priority > 10) {
            #err("Item priority must be between 0 and 10")
        } else if (item.retries < 0) {
            #err("Item retries must be greater than or equal to 0")
        } else {
            #ok()
        }
    };

    private func validateProcessor(processor : Types.QueueProcessor) : Result.Result<(), Text> {
        if (Utils.isEmpty(processor.name)) {
            #err("Processor name cannot be empty")
        } else if (Utils.isEmpty(processor.description)) {
            #err("Processor description cannot be empty")
        } else if (processor.maxConcurrent < 1) {
            #err("Processor max concurrent must be greater than 0")
        } else {
            #ok()
        }
    };

    private func updateQueueMetrics(queueId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, queueId), {
            items = 0;
            processed = 0;
            failed = 0;
            averageProcessingTime = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            items = currentMetrics.items + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, queueId, updatedMetrics)
    };

    private func updateQueueHistory(queueId : Text, action : Text, itemId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, queueId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            itemId = itemId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, queueId, updatedHistory)
    };

    // Public shared functions
    public shared(msg) func createQueue(queue : Types.Queue) : async Result.Result<Text, Text> {
        switch (validateQueue(queue)) {
            case (#ok()) {
                let queueId = generateQueueId();
                let newQueue = {
                    queue with
                    id = queueId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(queues, Text.equal, queueId, newQueue);
                updateQueueMetrics(queueId, "created", 1);
                updateQueueHistory(queueId, "created", "");
                #ok(queueId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func addItem(queueId : Text, item : Types.QueueItem) : async Result.Result<Text, Text> {
        switch (HashMap.get(queues, Text.equal, queueId)) {
            case (?queue) {
                switch (validateItem(item)) {
                    case (#ok()) {
                        let itemId = generateItemId();
                        let newItem = {
                            item with
                            id = itemId;
                            queueId = queueId;
                            status = #pending;
                            createdBy = msg.caller;
                            createdAt = Time.now();
                            updatedAt = Time.now()
                        };
                        HashMap.put(items, Text.equal, itemId, newItem);
                        updateQueueMetrics(queueId, "added", 1);
                        updateQueueHistory(queueId, "added", itemId);
                        #ok(itemId)
                    };
                    case (#err(msg)) #err(msg)
                }
            };
            case null #err("Queue not found")
        }
    };

    public shared(msg) func registerProcessor(processor : Types.QueueProcessor) : async Result.Result<(), Text> {
        switch (validateProcessor(processor)) {
            case (#ok()) {
                let newProcessor = {
                    processor with
                    id = msg.caller;
                    status = #active;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(processors, Principal.equal, msg.caller, newProcessor);
                #ok()
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func processItem(queueId : Text, itemId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(queues, Text.equal, queueId)) {
            case (?queue) {
                switch (HashMap.get(items, Text.equal, itemId)) {
                    case (?item) {
                        if (item.status == #pending) {
                            let updatedItem = {
                                item with
                                status = #processing;
                                processedBy = msg.caller;
                                processedAt = Time.now();
                                updatedAt = Time.now()
                            };
                            HashMap.put(items, Text.equal, itemId, updatedItem);
                            updateQueueMetrics(queueId, "processing", 1);
                            updateQueueHistory(queueId, "processing", itemId);
                            #ok()
                        } else {
                            #err("Item is not pending")
                        }
                    };
                    case null #err("Item not found")
                }
            };
            case null #err("Queue not found")
        }
    };

    public shared(msg) func completeItem(queueId : Text, itemId : Text, result : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(queues, Text.equal, queueId)) {
            case (?queue) {
                switch (HashMap.get(items, Text.equal, itemId)) {
                    case (?item) {
                        if (item.status == #processing) {
                            let updatedItem = {
                                item with
                                status = #completed;
                                result = result;
                                completedAt = Time.now();
                                updatedAt = Time.now()
                            };
                            HashMap.put(items, Text.equal, itemId, updatedItem);
                            updateQueueMetrics(queueId, "completed", 1);
                            updateQueueHistory(queueId, "completed", itemId);
                            #ok()
                        } else {
                            #err("Item is not processing")
                        }
                    };
                    case null #err("Item not found")
                }
            };
            case null #err("Queue not found")
        }
    };

    public shared(msg) func failItem(queueId : Text, itemId : Text, error : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(queues, Text.equal, queueId)) {
            case (?queue) {
                switch (HashMap.get(items, Text.equal, itemId)) {
                    case (?item) {
                        if (item.status == #processing) {
                            let updatedItem = {
                                item with
                                status = #failed;
                                error = error;
                                retries = item.retries + 1;
                                failedAt = Time.now();
                                updatedAt = Time.now()
                            };
                            HashMap.put(items, Text.equal, itemId, updatedItem);
                            updateQueueMetrics(queueId, "failed", 1);
                            updateQueueHistory(queueId, "failed", itemId);
                            #ok()
                        } else {
                            #err("Item is not processing")
                        }
                    };
                    case null #err("Item not found")
                }
            };
            case null #err("Queue not found")
        }
    };

    // Query functions
    public query func getQueue(queueId : Text) : async ?Types.Queue {
        HashMap.get(queues, Text.equal, queueId)
    };

    public query func getItem(itemId : Text) : async ?Types.QueueItem {
        HashMap.get(items, Text.equal, itemId)
    };

    public query func getProcessor(processorId : Principal) : async ?Types.QueueProcessor {
        HashMap.get(processors, Principal.equal, processorId)
    };

    public query func getQueueMetrics(queueId : Text) : async ?Types.QueueMetrics {
        HashMap.get(metrics, Text.equal, queueId)
    };

    public query func getQueueHistory(queueId : Text) : async ?Types.QueueHistory {
        HashMap.get(history, Text.equal, queueId)
    };

    public query func getQueueItems(queueId : Text, status : ?Types.QueueItemStatus) : async [Types.QueueItem] {
        let items = HashMap.entries(items);
        let filteredItems = Array.filter(items, func((id, item) : (Text, Types.QueueItem)) : Bool {
            item.queueId == queueId and
            switch (status) {
                case (?s) item.status == s;
                case null true
            }
        });
        Array.map(filteredItems, func((id, item) : (Text, Types.QueueItem)) : Types.QueueItem { item })
    };

    public query func getQueueProcessors(queueId : Text) : async [Types.QueueProcessor] {
        let processors = HashMap.entries(processors);
        let filteredProcessors = Array.filter(processors, func((id, processor) : (Principal, Types.QueueProcessor)) : Bool {
            processor.status == #active
        });
        Array.map(filteredProcessors, func((id, processor) : (Principal, Types.QueueProcessor)) : Types.QueueProcessor { processor })
    };
}; 