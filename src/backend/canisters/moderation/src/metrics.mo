

actor class MetricsCanister {
    // State variables
    private stable var metrics = HashMap.new<Text, Types.Metrics>();
    private stable var moderatorMetrics = HashMap.new<Principal, Types.ModeratorMetrics>();
    private stable var reportMetrics = HashMap.new<Text, Types.ReportMetrics>();
    private stable var actionMetrics = HashMap.new<Text, Types.ActionMetrics>();
    private stable var ruleMetrics = HashMap.new<Text, Types.RuleMetrics>();
    private stable var filterMetrics = HashMap.new<Text, Types.FilterMetrics>();
    private stable var queueMetrics = HashMap.new<Text, Types.QueueMetrics>();
    private stable var appealMetrics = HashMap.new<Text, Types.AppealMetrics>();
    private stable var commentMetrics = HashMap.new<Text, Types.CommentMetrics>();
    private stable var attachmentMetrics = HashMap.new<Text, Types.AttachmentMetrics>();
    private stable var notificationMetrics = HashMap.new<Text, Types.NotificationMetrics>();
    private stable var alertMetrics = HashMap.new<Text, Types.AlertMetrics>();
    private stable var auditMetrics = HashMap.new<Text, Types.AuditMetrics>();

    // Private helper functions
    private func updateGlobalMetrics(metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, "global"), {
            totalReports = 0;
            resolvedReports = 0;
            pendingReports = 0;
            totalActions = 0;
            actionsByType = HashMap.new<Text, Nat>();
            averageResolutionTime = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            totalReports = currentMetrics.totalReports + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, "global", updatedMetrics)
    };

    private func updateModeratorMetrics(moderatorId : Principal, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(moderatorMetrics, Principal.equal, moderatorId), {
            totalReviewed = 0;
            accuracy = 0.0;
            averageResponseTime = 0;
            specialization = [];
            performance = 0.0
        });
        let updatedMetrics = {
            currentMetrics with
            totalReviewed = currentMetrics.totalReviewed + value;
            lastUpdated = Time.now()
        };
        HashMap.put(moderatorMetrics, Principal.equal, moderatorId, updatedMetrics)
    };

    private func updateReportMetrics(reportId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(reportMetrics, Text.equal, reportId), {
            views = 0;
            actions = 0;
            comments = 0;
            attachments = 0;
            appeals = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics)
    };

    private func updateActionMetrics(actionId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(actionMetrics, Text.equal, actionId), {
            views = 0;
            appeals = 0;
            comments = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(actionMetrics, Text.equal, actionId, updatedMetrics)
    };

    private func updateRuleMetrics(ruleId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(ruleMetrics, Text.equal, ruleId), {
            applications = 0;
            successes = 0;
            failures = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            applications = currentMetrics.applications + value;
            lastUpdated = Time.now()
        };
        HashMap.put(ruleMetrics, Text.equal, ruleId, updatedMetrics)
    };

    private func updateFilterMetrics(filterId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(filterMetrics, Text.equal, filterId), {
            applications = 0;
            matches = 0;
            falsePositives = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            applications = currentMetrics.applications + value;
            lastUpdated = Time.now()
        };
        HashMap.put(filterMetrics, Text.equal, filterId, updatedMetrics)
    };

    private func updateQueueMetrics(queueId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(queueMetrics, Text.equal, queueId), {
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
        HashMap.put(queueMetrics, Text.equal, queueId, updatedMetrics)
    };

    private func updateAppealMetrics(appealId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(appealMetrics, Text.equal, appealId), {
            views = 0;
            comments = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(appealMetrics, Text.equal, appealId, updatedMetrics)
    };

    private func updateCommentMetrics(commentId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(commentMetrics, Text.equal, commentId), {
            views = 0;
            replies = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(commentMetrics, Text.equal, commentId, updatedMetrics)
    };

    private func updateAttachmentMetrics(attachmentId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(attachmentMetrics, Text.equal, attachmentId), {
            downloads = 0;
            views = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            downloads = currentMetrics.downloads + value;
            lastUpdated = Time.now()
        };
        HashMap.put(attachmentMetrics, Text.equal, attachmentId, updatedMetrics)
    };

    private func updateNotificationMetrics(notificationId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(notificationMetrics, Text.equal, notificationId), {
            sent = 0;
            delivered = 0;
            read = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            sent = currentMetrics.sent + value;
            lastUpdated = Time.now()
        };
        HashMap.put(notificationMetrics, Text.equal, notificationId, updatedMetrics)
    };

    private func updateAlertMetrics(alertId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(alertMetrics, Text.equal, alertId), {
            triggered = 0;
            acknowledged = 0;
            resolved = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            triggered = currentMetrics.triggered + value;
            lastUpdated = Time.now()
        };
        HashMap.put(alertMetrics, Text.equal, alertId, updatedMetrics)
    };

    private func updateAuditMetrics(auditId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(auditMetrics, Text.equal, auditId), {
            views = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(auditMetrics, Text.equal, auditId, updatedMetrics)
    };

    // Public shared functions
    public shared(msg) func recordMetric(
        metricType : Text,
        metricId : Text,
        value : Nat
    ) : async Result.Result<(), Text> {
        switch (metricType) {
            case ("global") {
                updateGlobalMetrics(metricType, value);
                #ok()
            };
            case ("moderator") {
                switch (Utils.fromText(metricId)) {
                    case (#ok(principal)) {
                        updateModeratorMetrics(principal, metricType, value);
                        #ok()
                    };
                    case (#err(msg)) #err(msg)
                }
            };
            case ("report") {
                updateReportMetrics(metricId, metricType, value);
                #ok()
            };
            case ("action") {
                updateActionMetrics(metricId, metricType, value);
                #ok()
            };
            case ("rule") {
                updateRuleMetrics(metricId, metricType, value);
                #ok()
            };
            case ("filter") {
                updateFilterMetrics(metricId, metricType, value);
                #ok()
            };
            case ("queue") {
                updateQueueMetrics(metricId, metricType, value);
                #ok()
            };
            case ("appeal") {
                updateAppealMetrics(metricId, metricType, value);
                #ok()
            };
            case ("comment") {
                updateCommentMetrics(metricId, metricType, value);
                #ok()
            };
            case ("attachment") {
                updateAttachmentMetrics(metricId, metricType, value);
                #ok()
            };
            case ("notification") {
                updateNotificationMetrics(metricId, metricType, value);
                #ok()
            };
            case ("alert") {
                updateAlertMetrics(metricId, metricType, value);
                #ok()
            };
            case ("audit") {
                updateAuditMetrics(metricId, metricType, value);
                #ok()
            };
            case (_) #err("Invalid metric type")
        }
    };

    // Query functions
    public query func getGlobalMetrics() : async ?Types.Metrics {
        HashMap.get(metrics, Text.equal, "global")
    };

    public query func getModeratorMetrics(moderatorId : Principal) : async ?Types.ModeratorMetrics {
        HashMap.get(moderatorMetrics, Principal.equal, moderatorId)
    };

    public query func getReportMetrics(reportId : Text) : async ?Types.ReportMetrics {
        HashMap.get(reportMetrics, Text.equal, reportId)
    };

    public query func getActionMetrics(actionId : Text) : async ?Types.ActionMetrics {
        HashMap.get(actionMetrics, Text.equal, actionId)
    };

    public query func getRuleMetrics(ruleId : Text) : async ?Types.RuleMetrics {
        HashMap.get(ruleMetrics, Text.equal, ruleId)
    };

    public query func getFilterMetrics(filterId : Text) : async ?Types.FilterMetrics {
        HashMap.get(filterMetrics, Text.equal, filterId)
    };

    public query func getQueueMetrics(queueId : Text) : async ?Types.QueueMetrics {
        HashMap.get(queueMetrics, Text.equal, queueId)
    };

    public query func getAppealMetrics(appealId : Text) : async ?Types.AppealMetrics {
        HashMap.get(appealMetrics, Text.equal, appealId)
    };

    public query func getCommentMetrics(commentId : Text) : async ?Types.CommentMetrics {
        HashMap.get(commentMetrics, Text.equal, commentId)
    };

    public query func getAttachmentMetrics(attachmentId : Text) : async ?Types.AttachmentMetrics {
        HashMap.get(attachmentMetrics, Text.equal, attachmentId)
    };

    public query func getNotificationMetrics(notificationId : Text) : async ?Types.NotificationMetrics {
        HashMap.get(notificationMetrics, Text.equal, notificationId)
    };

    public query func getAlertMetrics(alertId : Text) : async ?Types.AlertMetrics {
        HashMap.get(alertMetrics, Text.equal, alertId)
    };

    public query func getAuditMetrics(auditId : Text) : async ?Types.AuditMetrics {
        HashMap.get(auditMetrics, Text.equal, auditId)
    };
}; 