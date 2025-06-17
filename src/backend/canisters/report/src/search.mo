

actor class SearchCanister {
    // State variables
    private stable var reportIndex = HashMap.new<Text, Types.Report>();
    private stable var submissionIndex = HashMap.new<Text, Types.ReportSubmission>();
    private stable var categoryIndex = HashMap.new<Text, Types.ReportCategory>();
    private stable var attachmentIndex = HashMap.new<Text, Types.Attachment>();
    private stable var commentIndex = HashMap.new<Text, Types.Comment>();
    private stable var searchHistory = HashMap.new<Text, Types.SearchHistory>();

    // Private helper functions
    private func generateSearchId() : Text {
        "search_" # Nat.toText(Time.now())
    };

    private func updateSearchHistory(userId : Text, query : Text, results : [Text]) : () {
        let searchId = generateSearchId();
        let searchHistory = {
            id = searchId;
            userId = userId;
            query = query;
            results = results;
            timestamp = Time.now()
        };
        HashMap.put(searchHistory, Text.equal, searchId, searchHistory)
    };

    private func searchReports(query : Text) : [Types.Report] {
        let reports = HashMap.entries(reportIndex);
        let filteredReports = Array.filter(reports, func((id, report) : (Text, Types.Report)) : Bool {
            Text.contains(report.title, #text query) or
            Text.contains(report.description, #text query)
        });
        Array.map(filteredReports, func((id, report) : (Text, Types.Report)) : Types.Report { report })
    };

    private func searchSubmissions(query : Text) : [Types.ReportSubmission] {
        let submissions = HashMap.entries(submissionIndex);
        let filteredSubmissions = Array.filter(submissions, func((id, submission) : (Text, Types.ReportSubmission)) : Bool {
            Text.contains(submission.content, #text query)
        });
        Array.map(filteredSubmissions, func((id, submission) : (Text, Types.ReportSubmission)) : Types.ReportSubmission { submission })
    };

    private func searchCategories(query : Text) : [Types.ReportCategory] {
        let categories = HashMap.entries(categoryIndex);
        let filteredCategories = Array.filter(categories, func((id, category) : (Text, Types.ReportCategory)) : Bool {
            Text.contains(category.name, #text query) or
            Text.contains(category.description, #text query)
        });
        Array.map(filteredCategories, func((id, category) : (Text, Types.ReportCategory)) : Types.ReportCategory { category })
    };

    private func searchAttachments(query : Text) : [Types.Attachment] {
        let attachments = HashMap.entries(attachmentIndex);
        let filteredAttachments = Array.filter(attachments, func((id, attachment) : (Text, Types.Attachment)) : Bool {
            Text.contains(attachment.name, #text query) or
            Text.contains(attachment.type, #text query)
        });
        Array.map(filteredAttachments, func((id, attachment) : (Text, Types.Attachment)) : Types.Attachment { attachment })
    };

    private func searchComments(query : Text) : [Types.Comment] {
        let comments = HashMap.entries(commentIndex);
        let filteredComments = Array.filter(comments, func((id, comment) : (Text, Types.Comment)) : Bool {
            Text.contains(comment.content, #text query)
        });
        Array.map(filteredComments, func((id, comment) : (Text, Types.Comment)) : Types.Comment { comment })
    };

    // Public shared functions
    public shared(msg) func indexReport(report : Types.Report) : async Result.Result<(), Text> {
        HashMap.put(reportIndex, Text.equal, report.id, report);
        #ok()
    };

    public shared(msg) func indexSubmission(submission : Types.ReportSubmission) : async Result.Result<(), Text> {
        HashMap.put(submissionIndex, Text.equal, submission.id, submission);
        #ok()
    };

    public shared(msg) func indexCategory(category : Types.ReportCategory) : async Result.Result<(), Text> {
        HashMap.put(categoryIndex, Text.equal, category.id, category);
        #ok()
    };

    public shared(msg) func indexAttachment(attachment : Types.Attachment) : async Result.Result<(), Text> {
        HashMap.put(attachmentIndex, Text.equal, attachment.id, attachment);
        #ok()
    };

    public shared(msg) func indexComment(comment : Types.Comment) : async Result.Result<(), Text> {
        HashMap.put(commentIndex, Text.equal, comment.id, comment);
        #ok()
    };

    public shared(msg) func search(query : Text) : async Result.Result<Types.SearchResults, Text> {
        let userId = Principal.toText(msg.caller);
        let reports = searchReports(query);
        let submissions = searchSubmissions(query);
        let categories = searchCategories(query);
        let attachments = searchAttachments(query);
        let comments = searchComments(query);

        let results = {
            reports = reports;
            submissions = submissions;
            categories = categories;
            attachments = attachments;
            comments = comments;
            timestamp = Time.now()
        };

        updateSearchHistory(userId, query, Array.map(reports, func(r : Types.Report) : Text { r.id }));
        #ok(results)
    };

    public shared(msg) func searchReports(query : Text) : async Result.Result<[Types.Report], Text> {
        let userId = Principal.toText(msg.caller);
        let reports = searchReports(query);
        updateSearchHistory(userId, query, Array.map(reports, func(r : Types.Report) : Text { r.id }));
        #ok(reports)
    };

    public shared(msg) func searchSubmissions(query : Text) : async Result.Result<[Types.ReportSubmission], Text> {
        let userId = Principal.toText(msg.caller);
        let submissions = searchSubmissions(query);
        updateSearchHistory(userId, query, Array.map(submissions, func(s : Types.ReportSubmission) : Text { s.id }));
        #ok(submissions)
    };

    public shared(msg) func searchCategories(query : Text) : async Result.Result<[Types.ReportCategory], Text> {
        let userId = Principal.toText(msg.caller);
        let categories = searchCategories(query);
        updateSearchHistory(userId, query, Array.map(categories, func(c : Types.ReportCategory) : Text { c.id }));
        #ok(categories)
    };

    public shared(msg) func searchAttachments(query : Text) : async Result.Result<[Types.Attachment], Text> {
        let userId = Principal.toText(msg.caller);
        let attachments = searchAttachments(query);
        updateSearchHistory(userId, query, Array.map(attachments, func(a : Types.Attachment) : Text { a.id }));
        #ok(attachments)
    };

    public shared(msg) func searchComments(query : Text) : async Result.Result<[Types.Comment], Text> {
        let userId = Principal.toText(msg.caller);
        let comments = searchComments(query);
        updateSearchHistory(userId, query, Array.map(comments, func(c : Types.Comment) : Text { c.id }));
        #ok(comments)
    };

    // Query functions
    public query func getSearchHistory(userId : Text) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByQuery(query : Text) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            Text.contains(h.query, #text query)
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByUserAndTimeRange(userId : Text, startTime : Time.Time, endTime : Time.Time) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            h.userId == userId and h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByUserAndQuery(userId : Text, query : Text) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            h.userId == userId and Text.contains(h.query, #text query)
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByQueryAndTimeRange(query : Text, startTime : Time.Time, endTime : Time.Time) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            Text.contains(h.query, #text query) and h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };

    public query func getSearchHistoryByUserAndQueryAndTimeRange(userId : Text, query : Text, startTime : Time.Time, endTime : Time.Time) : async [Types.SearchHistory] {
        let history = HashMap.entries(searchHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.SearchHistory)) : Bool {
            h.userId == userId and Text.contains(h.query, #text query) and h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.SearchHistory)) : Types.SearchHistory { h })
    };
}; 