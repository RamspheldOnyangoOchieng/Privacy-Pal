import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Text "mo:base/Text";
import Time "mo:base/Time";
import List "mo:base/List";
import Result "mo:base/Result";

import CommonTypes "common/types/common_types";
import Types "../types";
import Utils "../utils";
import Constants "../constants";

actor class ModerationCanister() {
    // State
    private var reports = HashMap.HashMap<Text, Types.Report>(0, Text.equal, Text.hash);
    private var moderators = HashMap.HashMap<Principal, Types.Moderator>(0, Principal.equal, Principal.hash);
    private var moderationQueue = HashMap.HashMap<Text, Types.ModerationTask>(0, Text.equal, Text.hash);
    private var moderationHistory = HashMap.HashMap<Text, [Types.ModerationDecision]>(0, Text.equal, Text.hash);
    private var contentFilters = HashMap.HashMap<Text, Types.ContentFilter>(0, Text.equal, Text.hash);
    private var ngoPartners = HashMap.HashMap<Text, Types.NGOPartner>(0, Text.equal, Text.hash);
    private var moderationMetrics = HashMap.HashMap<Text, Types.ModerationMetrics>(0, Text.equal, Text.hash);
    private var actions = HashMap.HashMap<Text, Types.Action>(0, Text.equal, Text.hash);
    private var rules = HashMap.HashMap<Text, Types.Rule>(0, Text.equal, Text.hash);

    // Types
    private type Report = {
        id: Text;
        content: CommonTypes.ReportContent;
        metadata: CommonTypes.ReportMetadata;
        status: CommonTypes.ReportStatus;
        submittedAt: Int;
        moderatedAt: ?Int;
        moderatorId: ?Principal;
        decision: ?CommonTypes.ModerationDecision;
        appealStatus: ?Types.AppealStatus;
    };

    private type Moderator = {
        id: Principal;
        name: Text;
        email: Text;
        specialization: [Text];
        languages: [Text];
        regions: [Text];
        status: Types.ModeratorStatus;
        joinedAt: Int;
        lastActive: Int;
        metrics: Types.ModeratorMetrics;
    };

    private type ModeratorStatus = {
        #Active;
        #Inactive;
        #Suspended;
    };

    private type ModeratorMetrics = {
        totalReviewed: Nat;
        accuracy: Float;
        averageResponseTime: Float;
        specialization: [Text];
        performance: Float;
    };

    private type ModerationTask = {
        reportId: Text;
        assignedTo: ?Principal;
        priority: CommonTypes.ReportPriority;
        status: Types.TaskStatus;
        createdAt: Int;
        deadline: Int;
        notes: ?Text;
    };

    private type TaskStatus = {
        #Pending;
        #Assigned;
        #InProgress;
        #Completed;
        #Escalated;
    };

    private type ContentFilter = {
        id: Text;
        type: Types.FilterType;
        pattern: Text;
        action: Types.FilterAction;
        priority: Nat;
        enabled: Bool;
        createdAt: Int;
        updatedAt: Int;
    };

    private type FilterType = {
        #Keyword;
        #Regex;
        #AI;
        #Custom;
    };

    private type FilterAction = {
        #Flag;
        #Block;
        #Review;
        #Notify;
    };

    private type NGOPartner = {
        id: Text;
        name: Text;
        specialization: [Text];
        regions: [Text];
        contact: Types.ContactInfo;
        status: Types.PartnerStatus;
        joinedAt: Int;
        lastActive: Int;
    };

    private type ContactInfo = {
        email: Text;
        phone: ?Text;
        address: ?Text;
        website: ?Text;
    };

    private type PartnerStatus = {
        #Active;
        #Inactive;
        #Pending;
    };

    private type AppealStatus = {
        #Pending;
        #Approved;
        #Rejected;
        #UnderReview;
    };

    private type ModerationMetrics = {
        totalReports: Nat;
        pendingReports: Nat;
        resolvedReports: Nat;
        averageResponseTime: Float;
        accuracy: Float;
        specialization: [Text];
        regions: [Text];
    };

    // Constants
    private let MAX_REPORTS_PER_MODERATOR = 10;
    private let MODERATION_DEADLINE = 24 * 60 * 60 * 1_000_000_000; // 24 hours
    private let MIN_ACCURACY_THRESHOLD = 0.8;
    private let MAX_APPEAL_WINDOW = 7 * 24 * 60 * 60 * 1_000_000_000; // 7 days

    // Helper Functions
    private func generateReportId() : Text {
        "REP-" # Nat.toText(Time.now())
    };

    private func generateActionId() : Text {
        "ACT-" # Nat.toText(Time.now())
    };

    private func generateRuleId() : Text {
        "RUL-" # Nat.toText(Time.now())
    };

    private func calculateModeratorWorkload(moderatorId: Principal) : Nat {
        var count = 0;
        for ((_, task) in moderationQueue.entries()) {
            if (task.assignedTo == ?moderatorId and task.status == #Assigned) {
                count += 1;
            };
        };
        count
    };

    private func findAvailableModerator(
        specialization: [Text],
        language: Text,
        region: ?Text
    ) : ?Principal {
        var bestMatch: ?Principal = null;
        var bestScore = 0;

        for ((id, moderator) in moderators.entries()) {
            if (moderator.status == #Active) {
                let score = calculateModeratorMatchScore(moderator, specialization, language, region);
                if (score > bestScore) {
                    bestScore := score;
                    bestMatch := ?id;
                };
            };
        };

        bestMatch
    };

    private func calculateModeratorMatchScore(
        moderator: Types.Moderator,
        specialization: [Text],
        language: Text,
        region: ?Text
    ) : Nat {
        var score = 0;

        // Check specialization match
        for (spec in specialization.vals()) {
            if (Array.find<Text>(moderator.specialization, func(s: Text) : Bool { s == spec }) != null) {
                score += 2;
            };
        };

        // Check language match
        if (Array.find<Text>(moderator.languages, func(l: Text) : Bool { l == language }) != null) {
            score += 1;
        };

        // Check region match
        switch (region) {
            case (?r) {
                if (Array.find<Text>(moderator.regions, func(reg: Text) : Bool { reg == r }) != null) {
                    score += 1;
                };
            };
            case null {};
        };

        score
    };

    private func applyContentFilters(content: CommonTypes.ReportContent) : async [Types.ContentFilter] {
        var triggeredFilters = Buffer.Buffer<Types.ContentFilter>(0);

        for ((_, filter) in contentFilters.entries()) {
            if (filter.enabled) {
                let triggered = await checkContentFilter(content, filter);
                if (triggered) {
                    triggeredFilters.add(filter);
                };
            };
        };

        Buffer.toArray(triggeredFilters)
    };

    private func checkContentFilter(
        content: CommonTypes.ReportContent,
        filter: Types.ContentFilter
    ) : async Bool {
        switch (filter.type) {
            case (#Keyword) {
                Text.contains(content.title, #text filter.pattern) or
                Text.contains(content.description, #text filter.pattern)
            };
            case (#Regex) {
                // TODO: Implement regex matching
                false
            };
            case (#AI) {
                // TODO: Implement AI-based content analysis
                false
            };
            case (#Custom) {
                // TODO: Implement custom filter logic
                false
            };
        }
    };

    private func updateModerationMetrics() {
        var totalReports = 0;
        var pendingReports = 0;
        var resolvedReports = 0;
        var totalResponseTime = 0;
        var totalDecisions = 0;
        var correctDecisions = 0;

        let specializationSet = HashMap.HashMap<Text, Bool>(0, Text.equal, Text.hash);
        let regionSet = HashMap.HashMap<Text, Bool>(0, Text.equal, Text.hash);

        for ((_, report) in reports.entries()) {
            totalReports += 1;

            switch (report.status) {
                case (#Pending or #UnderReview) {
                    pendingReports += 1;
                };
                case (#Approved or #Rejected or #Archived) {
                    resolvedReports += 1;
                };
            };

            switch (report.moderatedAt, report.submittedAt) {
                case (?moderated, submitted) {
                    totalResponseTime += moderated - submitted;
                    totalDecisions += 1;
                };
                case (_, _) {};
            };

            // Track specializations and regions
            for (spec in report.metadata.tags.vals()) {
                HashMap.put(specializationSet, spec, true);
            };

            switch (report.metadata.location) {
                case (?loc) {
                    HashMap.put(regionSet, loc, true);
                };
                case null {};
            };
        };

        let metrics: Types.ModerationMetrics = {
            totalReports = totalReports;
            pendingReports = pendingReports;
            resolvedReports = resolvedReports;
            averageResponseTime = if (totalDecisions > 0) {
                Float.fromInt(totalResponseTime) / Float.fromInt(totalDecisions)
            } else {
                0.0
            };
            accuracy = if (totalDecisions > 0) {
                Float.fromInt(correctDecisions) / Float.fromInt(totalDecisions)
            } else {
                0.0
            };
            specialization = Iter.toArray(Iter.map(HashMap.keys(specializationSet), func(k: Text) : Text { k }));
            regions = Iter.toArray(Iter.map(HashMap.keys(regionSet), func(k: Text) : Text { k }));
        };

        moderationMetrics.put("global", metrics);
    };

    // Public Functions
    public shared(msg) func registerModerator(moderator : Types.Moderator) : async Result.Result<(), Text> {
        if (not isModerator(msg.caller)) {
            return #err("Only existing moderators can register new moderators")
        };
        HashMap.put(moderators, Principal.equal, msg.caller, moderator);
        #ok()
    };

    public shared(msg) func submitReport(report : Types.Report) : async Result.Result<Text, Text> {
        switch (validateReport(report)) {
            case (#err(msg)) return #err(msg);
            case (#ok()) {
                let reportId = generateReportId();
                let newReport = {
                    id = reportId;
                    title = report.title;
                    description = report.description;
                    category = report.category;
                    customCategory = report.customCategory;
                    status = #pending;
                    priority = report.priority;
                    submittedBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(reports, Text.equal, reportId, newReport);
                #ok(reportId)
            }
        }
    };

    public shared(msg) func takeAction(action : Types.Action) : async Result.Result<Text, Text> {
        if (not isModerator(msg.caller)) {
            return #err("Only moderators can take actions")
        };
        switch (validateAction(action)) {
            case (#err(msg)) return #err(msg);
            case (#ok()) {
                let actionId = generateActionId();
                let newAction = {
                    id = actionId;
                    reportId = action.reportId;
                    type = action.type;
                    customType = action.customType;
                    reason = action.reason;
                    duration = action.duration;
                    takenBy = msg.caller;
                    createdAt = Time.now()
                };
                HashMap.put(actions, Text.equal, actionId, newAction);
                // Update report status
                switch (HashMap.get(reports, Text.equal, action.reportId)) {
                    case (null) return #err("Report not found");
                    case (?report) {
                        let updatedReport = {
                            report with
                            status = #resolved;
                            updatedAt = Time.now()
                        };
                        HashMap.put(reports, Text.equal, action.reportId, updatedReport);
                    }
                };
                // Update metrics
                let currentMetrics = Option.get(HashMap.get(moderationMetrics, Text.equal, "global"), {
                    totalReports = 0;
                    resolvedReports = 0;
                    pendingReports = 0;
                    totalActions = 0;
                    actionsByType = HashMap.new<Text, Nat>();
                    averageResolutionTime = 0;
                    lastUpdated = Time.now()
                });
                let updatedMetrics = updateMetrics(currentMetrics, newAction);
                HashMap.put(moderationMetrics, Text.equal, "global", updatedMetrics);
                #ok(actionId)
            }
        }
    };

    public shared(msg) func createRule(rule : Types.Rule) : async Result.Result<Text, Text> {
        if (not isModerator(msg.caller)) {
            return #err("Only moderators can create rules")
        };
        switch (validateRule(rule)) {
            case (#err(msg)) return #err(msg);
            case (#ok()) {
                let ruleId = generateRuleId();
                let newRule = {
                    id = ruleId;
                    name = rule.name;
                    description = rule.description;
                    type = rule.type;
                    customType = rule.customType;
                    conditions = rule.conditions;
                    actions = rule.actions;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(rules, Text.equal, ruleId, newRule);
                #ok(ruleId)
            }
        }
    };

    public query func getModerator(principal : Principal) : async ?Types.Moderator {
        HashMap.get(moderators, Principal.equal, principal)
    };

    public query func getReport(reportId : Text) : async ?Types.Report {
        HashMap.get(reports, Text.equal, reportId)
    };

    public query func getAction(actionId : Text) : async ?Types.Action {
        HashMap.get(actions, Text.equal, actionId)
    };

    public query func getRule(ruleId : Text) : async ?Types.Rule {
        HashMap.get(rules, Text.equal, ruleId)
    };

    public query func getMetrics() : async ?Types.Metrics {
        HashMap.get(moderationMetrics, Text.equal, "global")
    };

    public query func listReports(status : ?Types.ReportStatus, category : ?Types.ReportCategory) : async [Types.Report] {
        let reportsList = HashMap.vals(reports);
        let filteredReports = Array.filter(reportsList, func(report : Types.Report) : Bool {
            let statusMatch = switch (status) {
                case (null) true;
                case (?s) report.status == s
            };
            let categoryMatch = switch (category) {
                case (null) true;
                case (?c) report.category == c
            };
            statusMatch and categoryMatch
        });
        Array.sort(filteredReports, func(a : Types.Report, b : Types.Report) : Order.Order {
            Nat.compare(b.createdAt, a.createdAt)
        })
    };

    public query func listActions(reportId : ?Text) : async [Types.Action] {
        let actionsList = HashMap.vals(actions);
        let filteredActions = Array.filter(actionsList, func(action : Types.Action) : Bool {
            switch (reportId) {
                case (null) true;
                case (?id) action.reportId == id
            }
        });
        Array.sort(filteredActions, func(a : Types.Action, b : Types.Action) : Order.Order {
            Nat.compare(b.createdAt, a.createdAt)
        })
    };

    public query func listRules() : async [Types.Rule] {
        let rulesList = HashMap.vals(rules);
        Array.sort(rulesList, func(a : Types.Rule, b : Types.Rule) : Order.Order {
            Nat.compare(b.createdAt, a.createdAt)
        })
    };

    // Private helper functions
    private func isModerator(principal : Principal) : Bool {
        Option.isSome(HashMap.get(moderators, Principal.equal, principal))
    };

    private func validateReport(report : Types.Report) : Result.Result<(), Text> {
        if (Utils.isEmpty(report.title)) {
            return #err("Report title cannot be empty")
        };
        if (Utils.isEmpty(report.description)) {
            return #err("Report description cannot be empty")
        };
        if (report.category == #other and Utils.isEmpty(report.customCategory)) {
            return #err("Custom category is required for 'other' category")
        };
        #ok()
    };

    private func validateAction(action : Types.Action) : Result.Result<(), Text> {
        if (Utils.isEmpty(action.reason)) {
            return #err("Action reason cannot be empty")
        };
        if (action.type == #custom and Utils.isEmpty(action.customType)) {
            return #err("Custom type is required for 'custom' action type")
        };
        #ok()
    };

    private func validateRule(rule : Types.Rule) : Result.Result<(), Text> {
        if (Utils.isEmpty(rule.name)) {
            return #err("Rule name cannot be empty")
        };
        if (Utils.isEmpty(rule.description)) {
            return #err("Rule description cannot be empty")
        };
        if (rule.type == #custom and Utils.isEmpty(rule.customType)) {
            return #err("Custom type is required for 'custom' rule type")
        };
        #ok()
    };

    private func updateMetrics(metrics : Types.Metrics, action : Types.Action) : Types.Metrics {
        let updatedMetrics = {
            totalReports = metrics.totalReports;
            resolvedReports = metrics.resolvedReports;
            pendingReports = metrics.pendingReports;
            totalActions = metrics.totalActions + 1;
            actionsByType = HashMap.new<Text, Nat>();
            averageResolutionTime = metrics.averageResolutionTime;
            lastUpdated = Time.now()
        };
        // Update actions by type
        let actionType = switch (action.type) {
            case (#warn) "warn";
            case (#suspend) "suspend";
            case (#ban) "ban";
            case (#custom) action.customType;
        };
        let currentCount = Option.get(HashMap.get(metrics.actionsByType, Text.equal, actionType), 0);
        HashMap.put(updatedMetrics.actionsByType, Text.equal, actionType, currentCount + 1);
        updatedMetrics
    };
} 