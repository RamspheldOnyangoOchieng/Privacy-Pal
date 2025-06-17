

module {
    // Basic types
    public type ReportId = Text;
    public type SubmissionId = Text;
    public type CategoryId = Text;
    public type AttachmentId = Text;
    public type CommentId = Text;
    public type UserId = Principal;
    public type Timestamp = Time.Time;

    // Report types
    public type ReportStatus = {
        #pending;
        #under_review;
        #approved;
        #rejected;
        #archived;
    };

    public type Report = {
        id : ReportId;
        title : Text;
        description : Text;
        categories : [CategoryId];
        priority : Nat;
        status : ReportStatus;
        createdBy : UserId;
        createdAt : Timestamp;
        updatedAt : Timestamp;
    };

    // Submission types
    public type SubmissionStatus = {
        #pending;
        #under_review;
        #approved;
        #rejected;
    };

    public type ReportSubmission = {
        id : SubmissionId;
        reportId : ReportId;
        content : Text;
        priority : Nat;
        status : SubmissionStatus;
        createdBy : UserId;
        createdAt : Timestamp;
        updatedAt : Timestamp;
    };

    // Category types
    public type ReportCategory = {
        id : CategoryId;
        name : Text;
        description : Text;
        createdBy : UserId;
        createdAt : Timestamp;
        updatedAt : Timestamp;
    };

    // Attachment types
    public type Attachment = {
        id : AttachmentId;
        reportId : ReportId;
        name : Text;
        type : Text;
        data : Text;
        createdBy : UserId;
        createdAt : Timestamp;
        updatedAt : Timestamp;
    };

    // Comment types
    public type Comment = {
        id : CommentId;
        reportId : ReportId;
        content : Text;
        priority : Nat;
        createdBy : UserId;
        createdAt : Timestamp;
        updatedAt : Timestamp;
    };

    // Metrics types
    public type ReportMetrics = {
        views : Nat;
        submissions : Nat;
        attachments : Nat;
        comments : Nat;
        lastUpdated : Timestamp;
    };

    // History types
    public type HistoryAction = {
        action : Text;
        submissionId : Text;
        timestamp : Timestamp;
    };

    public type ReportHistory = {
        actions : [HistoryAction];
        lastUpdated : Timestamp;
    };

    // Error types
    public type Error = {
        code : Nat;
        message : Text;
    };

    // Result types
    public type Result<T, E> = {
        #ok : T;
        #err : E;
    };

    // Option types
    public type Option<T> = {
        #some : T;
        #none;
    };

    // List types
    public type List<T> = {
        #nil;
        #cons : (T, List<T>);
    };

    // Array types
    public type Array<T> = [T];

    // HashMap types
    public type HashMap<K, V> = [(K, V)];

    // Principal types
    public type Principal = Principal.Principal;

    // Time types
    public type Time = Time.Time;

    // Debug types
    public type Debug = {
        #info : Text;
        #warn : Text;
        #error : Text;
    };
}; 