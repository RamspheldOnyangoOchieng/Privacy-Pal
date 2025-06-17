

module {
    // Basic types
    public type UserId = Text;
    public type ReportId = Text;
    public type ReviewId = Text;
    public type CommentId = Text;
    public type AttachmentId = Text;
    public type SessionId = Text;
    public type TokenId = Text;
    public type NotificationId = Text;
    public type TemplateId = Text;
    public type ChannelId = Text;
    public type SchemaId = Text;
    public type ValidatorId = Text;
    public type RuleId = Text;
    public type ConfigId = Text;
    public type MetricId = Text;
    public type AlertId = Text;
    public type DashboardId = Text;
    public type BackupId = Text;
    public type LogId = Text;
    public type EventId = Text;
    public type QueueId = Text;
    public type CacheId = Text;
    public type PolicyId = Text;
    public type IncidentId = Text;
    public type AuditId = Text;

    // User types
    public type User = {
        id : UserId;
        username : Text;
        email : Text;
        phone : ?Text;
        status : UserStatus;
        role : UserRole;
        permissions : [Permission];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type UserStatus = {
        #active;
        #inactive;
        #suspended;
        #deleted;
    };

    public type UserRole = {
        #user;
        #reviewer;
        #admin;
        #super;
    };

    public type Permission = {
        #read;
        #write;
        #delete;
        #admin;
    };

    // Report types
    public type Report = {
        id : ReportId;
        userId : UserId;
        title : Text;
        description : Text;
        category : ReportCategory;
        status : ReportStatus;
        priority : ReportPriority;
        attachments : [AttachmentId];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ReportCategory = {
        #security;
        #privacy;
        #compliance;
        #other;
    };

    public type ReportStatus = {
        #draft;
        #submitted;
        #under_review;
        #resolved;
        #closed;
    };

    public type ReportPriority = {
        #low;
        #medium;
        #high;
        #critical;
    };

    // Review types
    public type Review = {
        id : ReviewId;
        reportId : ReportId;
        reviewerId : UserId;
        rating : Nat;
        comments : Text;
        status : ReviewStatus;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ReviewStatus = {
        #pending;
        #in_progress;
        #completed;
        #rejected;
    };

    // Comment types
    public type Comment = {
        id : CommentId;
        userId : UserId;
        content : Text;
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

    // Session types
    public type Session = {
        id : SessionId;
        userId : UserId;
        token : Text;
        expiresAt : Time.Time;
        createdAt : Time.Time;
    };

    // Token types
    public type Token = {
        id : TokenId;
        userId : UserId;
        type : TokenType;
        value : Text;
        expiresAt : Time.Time;
        createdAt : Time.Time;
    };

    public type TokenType = {
        #access;
        #refresh;
        #reset;
        #verify;
    };

    // Notification types
    public type Notification = {
        id : NotificationId;
        userId : UserId;
        type : NotificationType;
        title : Text;
        content : Text;
        priority : NotificationPriority;
        status : NotificationStatus;
        createdAt : Time.Time;
    };

    public type NotificationType = {
        #alert;
        #info;
        #warning;
        #error;
    };

    public type NotificationPriority = {
        #low;
        #medium;
        #high;
        #urgent;
    };

    public type NotificationStatus = {
        #pending;
        #sent;
        #delivered;
        #read;
        #failed;
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
        #sms;
        #push;
        #in_app;
    };

    // Channel types
    public type Channel = {
        id : ChannelId;
        name : Text;
        type : ChannelType;
        config : ChannelConfig;
        status : ChannelStatus;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ChannelType = {
        #email;
        #sms;
        #push;
        #in_app;
        #webhook;
    };

    public type ChannelConfig = {
        endpoint : Text;
        credentials : Text;
        options : [(Text, Text)];
    };

    public type ChannelStatus = {
        #active;
        #inactive;
        #error;
    };

    // Schema types
    public type Schema = {
        id : SchemaId;
        name : Text;
        fields : [Field];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type Field = {
        name : Text;
        type : FieldType;
        required : Bool;
        constraints : [Constraint];
    };

    public type FieldType = {
        #string;
        #number;
        #boolean;
        #date;
        #array;
        #object;
    };

    public type Constraint = {
        type : ConstraintType;
        value : Text;
    };

    public type ConstraintType = {
        #min;
        #max;
        #pattern;
        #enum;
        #custom;
    };

    // Validator types
    public type Validator = {
        id : ValidatorId;
        name : Text;
        type : ValidatorType;
        rules : [Rule];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ValidatorType = {
        #schema;
        #custom;
        #composite;
    };

    public type Rule = {
        id : RuleId;
        name : Text;
        type : RuleType;
        condition : Text;
        message : Text;
    };

    public type RuleType = {
        #validation;
        #transformation;
        #sanitization;
    };

    // Config types
    public type Config = {
        id : ConfigId;
        key : Text;
        value : Text;
        type : ConfigType;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type ConfigType = {
        #string;
        #number;
        #boolean;
        #json;
    };

    // Metric types
    public type Metric = {
        id : MetricId;
        name : Text;
        type : MetricType;
        value : Float;
        tags : [(Text, Text)];
        timestamp : Time.Time;
    };

    public type MetricType = {
        #counter;
        #gauge;
        #histogram;
        #summary;
    };

    // Alert types
    public type Alert = {
        id : AlertId;
        name : Text;
        condition : Text;
        severity : AlertSeverity;
        status : AlertStatus;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type AlertSeverity = {
        #info;
        #warning;
        #error;
        #critical;
    };

    public type AlertStatus = {
        #active;
        #acknowledged;
        #resolved;
    };

    // Dashboard types
    public type Dashboard = {
        id : DashboardId;
        name : Text;
        widgets : [Widget];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type Widget = {
        id : Text;
        type : WidgetType;
        config : WidgetConfig;
    };

    public type WidgetType = {
        #chart;
        #gauge;
        #table;
        #text;
    };

    public type WidgetConfig = {
        title : Text;
        data : Text;
        options : [(Text, Text)];
    };

    // Backup types
    public type Backup = {
        id : BackupId;
        name : Text;
        type : BackupType;
        status : BackupStatus;
        size : Nat;
        createdAt : Time.Time;
    };

    public type BackupType = {
        #full;
        #incremental;
        #differential;
    };

    public type BackupStatus = {
        #pending;
        #in_progress;
        #completed;
        #failed;
    };

    // Log types
    public type Log = {
        id : LogId;
        level : LogLevel;
        message : Text;
        context : [(Text, Text)];
        timestamp : Time.Time;
    };

    public type LogLevel = {
        #debug;
        #info;
        #warning;
        #error;
        #fatal;
    };

    // Event types
    public type Event = {
        id : EventId;
        type : EventType;
        data : Text;
        timestamp : Time.Time;
    };

    public type EventType = {
        #user;
        #report;
        #review;
        #system;
    };

    // Queue types
    public type Queue = {
        id : QueueId;
        name : Text;
        type : QueueType;
        status : QueueStatus;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type QueueType = {
        #fifo;
        #priority;
        #delayed;
    };

    public type QueueStatus = {
        #active;
        #paused;
        #error;
    };

    // Cache types
    public type Cache = {
        id : CacheId;
        key : Text;
        value : Text;
        ttl : Nat;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    // Policy types
    public type Policy = {
        id : PolicyId;
        name : Text;
        type : PolicyType;
        rules : [PolicyRule];
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type PolicyType = {
        #access;
        #security;
        #privacy;
        #compliance;
    };

    public type PolicyRule = {
        id : Text;
        condition : Text;
        action : Text;
    };

    // Incident types
    public type Incident = {
        id : IncidentId;
        type : IncidentType;
        severity : IncidentSeverity;
        status : IncidentStatus;
        description : Text;
        createdAt : Time.Time;
        updatedAt : Time.Time;
    };

    public type IncidentType = {
        #security;
        #performance;
        #availability;
        #compliance;
    };

    public type IncidentSeverity = {
        #low;
        #medium;
        #high;
        #critical;
    };

    public type IncidentStatus = {
        #open;
        #investigating;
        #resolved;
        #closed;
    };

    // Audit types
    public type Audit = {
        id : AuditId;
        userId : UserId;
        action : AuditAction;
        resource : Text;
        details : Text;
        timestamp : Time.Time;
    };

    public type AuditAction = {
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