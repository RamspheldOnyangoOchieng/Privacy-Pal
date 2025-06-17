import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Types "../types";
import Utils "../utils";
import Constants "../constants";

actor class HistoryCanister {
    // State variables
    private stable var reportHistory = HashMap.new<Text, Types.ReportHistory>();
    private stable var submissionHistory = HashMap.new<Text, Types.ReportHistory>();
    private stable var categoryHistory = HashMap.new<Text, Types.ReportHistory>();
    private stable var attachmentHistory = HashMap.new<Text, Types.ReportHistory>();
    private stable var commentHistory = HashMap.new<Text, Types.ReportHistory>();
    private stable var userHistory = HashMap.new<Text, Types.ReportHistory>();

    // Private helper functions
    private func updateReportHistory(reportId : Text, action : Text, submissionId : Text) : () {
        let currentHistory = Option.get(HashMap.get(reportHistory, Text.equal, reportId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = submissionId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(reportHistory, Text.equal, reportId, updatedHistory)
    };

    private func updateSubmissionHistory(submissionId : Text, action : Text) : () {
        let currentHistory = Option.get(HashMap.get(submissionHistory, Text.equal, submissionId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = "";
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(submissionHistory, Text.equal, submissionId, updatedHistory)
    };

    private func updateCategoryHistory(categoryId : Text, action : Text) : () {
        let currentHistory = Option.get(HashMap.get(categoryHistory, Text.equal, categoryId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = "";
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(categoryHistory, Text.equal, categoryId, updatedHistory)
    };

    private func updateAttachmentHistory(attachmentId : Text, action : Text) : () {
        let currentHistory = Option.get(HashMap.get(attachmentHistory, Text.equal, attachmentId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = "";
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(attachmentHistory, Text.equal, attachmentId, updatedHistory)
    };

    private func updateCommentHistory(commentId : Text, action : Text) : () {
        let currentHistory = Option.get(HashMap.get(commentHistory, Text.equal, commentId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = "";
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(commentHistory, Text.equal, commentId, updatedHistory)
    };

    private func updateUserHistory(userId : Text, action : Text) : () {
        let currentHistory = Option.get(HashMap.get(userHistory, Text.equal, userId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = "";
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(userHistory, Text.equal, userId, updatedHistory)
    };

    // Public shared functions
    public shared(msg) func trackReportAction(reportId : Text, action : Text, submissionId : Text) : async () {
        updateReportHistory(reportId, action, submissionId);
        updateUserHistory(Principal.toText(msg.caller), "report_action")
    };

    public shared(msg) func trackSubmissionAction(submissionId : Text, action : Text) : async () {
        updateSubmissionHistory(submissionId, action);
        updateUserHistory(Principal.toText(msg.caller), "submission_action")
    };

    public shared(msg) func trackCategoryAction(categoryId : Text, action : Text) : async () {
        updateCategoryHistory(categoryId, action);
        updateUserHistory(Principal.toText(msg.caller), "category_action")
    };

    public shared(msg) func trackAttachmentAction(attachmentId : Text, action : Text) : async () {
        updateAttachmentHistory(attachmentId, action);
        updateUserHistory(Principal.toText(msg.caller), "attachment_action")
    };

    public shared(msg) func trackCommentAction(commentId : Text, action : Text) : async () {
        updateCommentHistory(commentId, action);
        updateUserHistory(Principal.toText(msg.caller), "comment_action")
    };

    public shared(msg) func trackUserAction(userId : Text, action : Text) : async () {
        updateUserHistory(userId, action)
    };

    // Query functions
    public query func getReportHistory(reportId : Text) : async ?Types.ReportHistory {
        HashMap.get(reportHistory, Text.equal, reportId)
    };

    public query func getSubmissionHistory(submissionId : Text) : async ?Types.ReportHistory {
        HashMap.get(submissionHistory, Text.equal, submissionId)
    };

    public query func getCategoryHistory(categoryId : Text) : async ?Types.ReportHistory {
        HashMap.get(categoryHistory, Text.equal, categoryId)
    };

    public query func getAttachmentHistory(attachmentId : Text) : async ?Types.ReportHistory {
        HashMap.get(attachmentHistory, Text.equal, attachmentId)
    };

    public query func getCommentHistory(commentId : Text) : async ?Types.ReportHistory {
        HashMap.get(commentHistory, Text.equal, commentId)
    };

    public query func getUserHistory(userId : Text) : async ?Types.ReportHistory {
        HashMap.get(userHistory, Text.equal, userId)
    };

    public query func getHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [(Text, Types.ReportHistory)] {
        let history = HashMap.entries(reportHistory);
        let filteredHistory = Array.filter(history, func((id, history) : (Text, Types.ReportHistory)) : Bool {
            history.lastUpdated >= startTime and history.lastUpdated <= endTime
        });
        filteredHistory
    };

    public query func getHistoryByAction(action : Text) : async [(Text, Types.ReportHistory)] {
        let history = HashMap.entries(reportHistory);
        let filteredHistory = Array.filter(history, func((id, history) : (Text, Types.ReportHistory)) : Bool {
            Array.find(history.actions, func(a : Types.HistoryAction) : Bool {
                a.action == action
            }) != null
        });
        filteredHistory
    };

    public query func getHistoryByUser(userId : Text) : async ?Types.ReportHistory {
        HashMap.get(userHistory, Text.equal, userId)
    };

    public query func getHistoryByReport(reportId : Text) : async ?Types.ReportHistory {
        HashMap.get(reportHistory, Text.equal, reportId)
    };

    public query func getHistoryBySubmission(submissionId : Text) : async ?Types.ReportHistory {
        HashMap.get(submissionHistory, Text.equal, submissionId)
    };

    public query func getHistoryByCategory(categoryId : Text) : async ?Types.ReportHistory {
        HashMap.get(categoryHistory, Text.equal, categoryId)
    };

    public query func getHistoryByAttachment(attachmentId : Text) : async ?Types.ReportHistory {
        HashMap.get(attachmentHistory, Text.equal, attachmentId)
    };

    public query func getHistoryByComment(commentId : Text) : async ?Types.ReportHistory {
        HashMap.get(commentHistory, Text.equal, commentId)
    };
}; 