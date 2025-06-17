

actor class AuditCanister {
    // State variables
    private stable var logs = HashMap.new<Text, Types.AuditLog>();
    private stable var events = HashMap.new<Text, Types.AuditEvent>();
    private stable var metrics = HashMap.new<Text, Types.AuditMetrics>();
    private stable var history = HashMap.new<Text, Types.AuditHistory>();

    // Private helper functions
    private func generateLogId() : Text {
        "log_" # Nat.toText(Time.now())
    };

    private func generateEventId() : Text {
        "event_" # Nat.toText(Time.now())
    };

    private func validateLog(log : Types.AuditLog) : Result.Result<(), Text> {
        if (Utils.isEmpty(log.action)) {
            #err("Log action cannot be empty")
        } else if (Utils.isEmpty(log.details)) {
            #err("Log details cannot be empty")
        } else if (log.severity < 0 or log.severity > 10) {
            #err("Log severity must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateEvent(event : Types.AuditEvent) : Result.Result<(), Text> {
        if (Utils.isEmpty(event.type)) {
            #err("Event type cannot be empty")
        } else if (Utils.isEmpty(event.details)) {
            #err("Event details cannot be empty")
        } else if (event.severity < 0 or event.severity > 10) {
            #err("Event severity must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func updateAuditMetrics(logId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, logId), {
            views = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, logId, updatedMetrics)
    };

    private func updateAuditHistory(logId : Text, action : Text, eventId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, logId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            eventId = eventId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, logId, updatedHistory)
    };

    // Public shared functions
    public shared(msg) func createLog(log : Types.AuditLog) : async Result.Result<Text, Text> {
        switch (validateLog(log)) {
            case (#ok()) {
                let logId = generateLogId();
                let newLog = {
                    log with
                    id = logId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(logs, Text.equal, logId, newLog);
                updateAuditMetrics(logId, "created", 1);
                updateAuditHistory(logId, "created", "");
                #ok(logId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createEvent(event : Types.AuditEvent) : async Result.Result<Text, Text> {
        switch (validateEvent(event)) {
            case (#ok()) {
                let eventId = generateEventId();
                let newEvent = {
                    event with
                    id = eventId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(events, Text.equal, eventId, newEvent);
                updateAuditHistory(event.logId, "event_created", eventId);
                #ok(eventId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func updateLogSeverity(logId : Text, severity : Nat) : async Result.Result<(), Text> {
        switch (HashMap.get(logs, Text.equal, logId)) {
            case (?log) {
                if (severity < 0 or severity > 10) {
                    #err("Severity must be between 0 and 10")
                } else {
                    let updatedLog = {
                        log with
                        severity = severity;
                        updatedAt = Time.now()
                    };
                    HashMap.put(logs, Text.equal, logId, updatedLog);
                    updateAuditHistory(logId, "severity_updated", "");
                    #ok()
                }
            };
            case null #err("Log not found")
        }
    };

    public shared(msg) func updateEventSeverity(eventId : Text, severity : Nat) : async Result.Result<(), Text> {
        switch (HashMap.get(events, Text.equal, eventId)) {
            case (?event) {
                if (severity < 0 or severity > 10) {
                    #err("Severity must be between 0 and 10")
                } else {
                    let updatedEvent = {
                        event with
                        severity = severity;
                        updatedAt = Time.now()
                    };
                    HashMap.put(events, Text.equal, eventId, updatedEvent);
                    updateAuditHistory(event.logId, "event_severity_updated", eventId);
                    #ok()
                }
            };
            case null #err("Event not found")
        }
    };

    // Query functions
    public query func getLog(logId : Text) : async ?Types.AuditLog {
        HashMap.get(logs, Text.equal, logId)
    };

    public query func getEvent(eventId : Text) : async ?Types.AuditEvent {
        HashMap.get(events, Text.equal, eventId)
    };

    public query func getAuditMetrics(logId : Text) : async ?Types.AuditMetrics {
        HashMap.get(metrics, Text.equal, logId)
    };

    public query func getAuditHistory(logId : Text) : async ?Types.AuditHistory {
        HashMap.get(history, Text.equal, logId)
    };

    public query func getLogEvents(logId : Text) : async [Types.AuditEvent] {
        let events = HashMap.entries(events);
        let filteredEvents = Array.filter(events, func((id, event) : (Text, Types.AuditEvent)) : Bool {
            event.logId == logId
        });
        Array.map(filteredEvents, func((id, event) : (Text, Types.AuditEvent)) : Types.AuditEvent { event })
    };

    public query func getLogsBySeverity(minSeverity : Nat, maxSeverity : Nat) : async [Types.AuditLog] {
        let logs = HashMap.entries(logs);
        let filteredLogs = Array.filter(logs, func((id, log) : (Text, Types.AuditLog)) : Bool {
            log.severity >= minSeverity and log.severity <= maxSeverity
        });
        Array.map(filteredLogs, func((id, log) : (Text, Types.AuditLog)) : Types.AuditLog { log })
    };

    public query func getEventsByType(eventType : Text) : async [Types.AuditEvent] {
        let events = HashMap.entries(events);
        let filteredEvents = Array.filter(events, func((id, event) : (Text, Types.AuditEvent)) : Bool {
            event.type == eventType
        });
        Array.map(filteredEvents, func((id, event) : (Text, Types.AuditEvent)) : Types.AuditEvent { event })
    };

    public query func getLogsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.AuditLog] {
        let logs = HashMap.entries(logs);
        let filteredLogs = Array.filter(logs, func((id, log) : (Text, Types.AuditLog)) : Bool {
            log.createdAt >= startTime and log.createdAt <= endTime
        });
        Array.map(filteredLogs, func((id, log) : (Text, Types.AuditLog)) : Types.AuditLog { log })
    };

    public query func getEventsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.AuditEvent] {
        let events = HashMap.entries(events);
        let filteredEvents = Array.filter(events, func((id, event) : (Text, Types.AuditEvent)) : Bool {
            event.createdAt >= startTime and event.createdAt <= endTime
        });
        Array.map(filteredEvents, func((id, event) : (Text, Types.AuditEvent)) : Types.AuditEvent { event })
    };
}; 