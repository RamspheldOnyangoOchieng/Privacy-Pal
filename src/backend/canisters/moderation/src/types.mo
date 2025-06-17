

module {
    // Basic types
    public type ReportId = Text;
    public type ActionId = Text;
    public type RuleId = Text;
    public type ModeratorId = Principal;
    public type UserId = Principal;
    public type ContentId = Text;
    public type CategoryId = Text;
    public type FilterId = Text;
    public type MetricId = Text;
    public type TemplateId = Text;
    public type QueueId = Text;
    public type HistoryId = Text;
    public type AppealId = Text;
    public type CommentId = Text;
    public type AttachmentId = Text;
    public type NotificationId = Text;
    public type AlertId = Text;
    public type AuditId = Text;

    // Report types
    public type Report = {
        id : ReportId;
        title : Text;
        description : Text;
        category : ReportCategory;
        customCategory : ?Text;
        status : ReportStatus;
        priority : ReportPriority;
        submittedBy : Principal;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ReportCategory = {
        #harassment;
        #hate_speech;
        #violence;
        #spam;
        #fraud;
        #copyright;
        #other;
    };

    public type ReportStatus = {
        #pending;
        #under_review;
        #resolved;
        #rejected;
        #appealed;
    };

    public type ReportPriority = {
        #low;
        #medium;
        #high;
        #urgent;
    };

    // Action types
    public type Action = {
        id : ActionId;
        reportId : ReportId;
        type : ActionType;
        customType : ?Text;
        reason : Text;
        duration : ?Nat;
        takenBy : Principal;
        createdAt : Time.Time;
    };

    public type ActionType = {
        #warn;
        #suspend;
        #ban;
        #custom;
    };

    // Rule types
    public type Rule = {
        id : RuleId;
        name : Text;
        description : Text;
        type : RuleType;
        customType : ?Text;
        conditions : [Condition];
        actions : [Action];
        createdBy : Principal;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type RuleType = {
        #content;
        #behavior;
        #spam;
        #custom;
    };

    public type Condition = {
        field : Text;
        operator : Operator;
        value : Text;
    };

    public type Operator = {
        #equals;
        #contains;
        #starts_with;
        #ends_with;
        #greater_than;
        #less_than;
        #matches;
    };

    // Moderator types
    public type Moderator = {
        id : ModeratorId;
        name : Text;
        email : Text;
        specialization : [Text];
        languages : [Text];
        regions : [Text];
        status : ModeratorStatus;
        joinedAt : Time.Time;
        lastActive : Time.Time;
        metrics : ModeratorMetrics;
    };

    public type ModeratorStatus = {
        #active;
        #inactive;
        #suspended;
    };

    public type ModeratorMetrics = {
        totalReviewed : Nat;
        accuracy : Float;
        averageResponseTime : Nat;
        specialization : [Text];
        performance : Float;
    };

    // Content types
    public type Content = {
        id : ContentId;
        type : ContentType;
        data : Text;
        metadata : [(Text, Text)];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ContentType = {
        #text;
        #image;
        #video;
        #audio;
        #document;
        #other;
    };

    // Category types
    public type Category = {
        id : CategoryId;
        name : Text;
        description : Text;
        parentId : ?CategoryId;
        rules : [RuleId];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    // Filter types
    public type Filter = {
        id : FilterId;
        name : Text;
        type : FilterType;
        pattern : Text;
        action : FilterAction;
        priority : Nat;
        enabled : Bool;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type FilterType = {
        #keyword;
        #regex;
        #ml;
        #custom;
    };

    public type FilterAction = {
        #flag;
        #block;
        #notify;
        #custom;
    };

    // Metric types
    public type Metrics = {
        totalReports : Nat;
        resolvedReports : Nat;
        pendingReports : Nat;
        totalActions : Nat;
        actionsByType : HashMap.HashMap<Text, Nat>;
        averageResolutionTime : Nat;
        lastUpdated : Time.Time;
    };

    // Template types
    public type Template = {
        id : TemplateId;
        name : Text;
        type : TemplateType;
        content : Text;
        variables : [Text];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type TemplateType = {
        #email;
        #notification;
        #message;
        #custom;
    };

    // Queue types
    public type Queue = {
        id : QueueId;
        name : Text;
        type : QueueType;
        status : QueueStatus;
        items : [QueueItem];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type QueueType = {
        #reports;
        #appeals;
        #notifications;
        #custom;
    };

    public type QueueStatus = {
        #active;
        #paused;
        #error;
    };

    public type QueueItem = {
        id : Text;
        type : QueueItemType;
        data : Text;
        priority : Nat;
        status : QueueItemStatus;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type QueueItemType = {
        #report;
        #appeal;
        #notification;
        #custom;
    };

    public type QueueItemStatus = {
        #pending;
        #processing;
        #completed;
        #failed;
    };

    // History types
    public type History = {
        id : HistoryId;
        type : HistoryType;
        data : Text;
        user : Principal;
        moderator : ?Principal;
        createdAt : Time.Time;
    };

    public type HistoryType = {
        #report;
        #action;
        #appeal;
        #custom;
    };

    // Appeal types
    public type Appeal = {
        id : AppealId;
        reportId : ReportId;
        reason : Text;
        status : AppealStatus;
        submittedBy : Principal;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type AppealStatus = {
        #pending;
        #approved;
        #rejected;
    };

    // Comment types
    public type Comment = {
        id : CommentId;
        content : Text;
        user : Principal;
        parentId : ?CommentId;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    // Attachment types
    public type Attachment = {
        id : AttachmentId;
        name : Text;
        type : Text;
        size : Nat;
        url : Text;
        createdAt : Time.Time;
    };

    // Notification types
    public type Notification = {
        id : NotificationId;
        type : NotificationType;
        title : Text;
        content : Text;
        user : Principal;
        status : NotificationStatus;
        createdAt : Time.Time;
    };

    public type NotificationType = {
        #report;
        #action;
        #appeal;
        #custom;
    };

    public type NotificationStatus = {
        #pending;
        #sent;
        #read;
        #failed;
    };

    // Alert types
    public type Alert = {
        id : AlertId;
        type : AlertType;
        message : Text;
        severity : AlertSeverity;
        status : AlertStatus;
        createdAt : Time.Time;
    };

    public type AlertType = {
        #system;
        #security;
        #performance;
        #custom;
    };

    public type AlertSeverity = {
        #low;
        #medium;
        #high;
        #critical;
    };

    public type AlertStatus = {
        #active;
        #acknowledged;
        #resolved;
    };

    // Audit types
    public type Audit = {
        id : AuditId;
        type : AuditType;
        action : Text;
        user : Principal;
        details : Text;
        createdAt : Time.Time;
    };

    public type AuditType = {
        #create;
        #read;
        #update;
        #delete;
    };

    // Error types
    public type Error = {
        code : Nat;
        message : Text;
        details : ?Text;
    };

    // Result types
    public type Result<T, E> = Result.Result<T, E>;

    // Option types
    public type Option<T> = Option.Option<T>;

    // List types
    public type List<T> = List.List<T>;

    // Array types
    public type Array<T> = Array.Array<T>;

    // HashMap types
    public type HashMap<K, V> = HashMap.HashMap<K, V>;

    // Principal types
    public type Principal = Principal.Principal;

    // Time types
    public type Time = Time.Time;

    // Debug types
    public type Debug = Debug.Debug;
}; 