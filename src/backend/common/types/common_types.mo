module {
    // Report Status Types
    public type ReportStatus = {
        #Pending;
        #UnderReview;
        #Approved;
        #Rejected;
        #Archived;
    };

    // Report Category Types
    public type ReportCategory = {
        #Corruption;
        #HumanRights;
        #Environmental;
        #PublicHealth;
        #Education;
        #Infrastructure;
        #Other;
    };

    // Report Metadata
    public type ReportMetadata = {
        category: ReportCategory;
        priority: ReportPriority;
        visibility: ReportVisibility;
        location: ?Text;
        tags: [Text];
        language: Text;
        createdAt: Int;
        updatedAt: Int;
    };

    // Report Structure
    public type Report = {
        id: Text;
        content: Blob;
        category: ReportCategory;
        status: ReportStatus;
        metadata: ReportMetadata;
        encryptedContent: Blob;
    };

    // Vote Types
    public type Vote = {
        reportId: Text;
        voteType: VoteType;
        timestamp: Int;
        moderatorId: Text;
    };

    public type VoteType = {
        #Approve;
        #Reject;
        #NeedsMoreInfo;
    };

    // Result Types
    public type Result<T, E> = {
        #Ok : T;
        #Err : E;
    };

    public type Error = {
        code: Nat;
        message: Text;
    };

    public type SecurityLevel = {
        #Low;
        #Medium;
        #High;
        #Critical;
    };

    public type AnonymityLevel = {
        #Basic;
        #Enhanced;
        #Maximum;
    };

    public type ReportPriority = {
        #Low;
        #Medium;
        #High;
        #Urgent;
    };

    public type ReportVisibility = {
        #Public;
        #Restricted;
        #Private;
    };

    public type ReportContent = {
        title: Text;
        description: Text;
        evidence: [Evidence];
        attachments: [Attachment];
    };

    public type Evidence = {
        id: Text;
        type: EvidenceType;
        content: Text;
        hash: Text;
        timestamp: Int;
        verified: Bool;
    };

    public type EvidenceType = {
        #Document;
        #Image;
        #Video;
        #Audio;
        #Link;
        #Other;
    };

    public type Attachment = {
        id: Text;
        name: Text;
        type: Text;
        size: Nat;
        hash: Text;
        url: ?Text;
        uploadedAt: Int;
    };

    public type ModerationAction = {
        #Approve;
        #Reject;
        #Flag;
        #Escalate;
        #Archive;
    };

    public type ModerationReason = {
        #Inappropriate;
        #False;
        #Duplicate;
        #Incomplete;
        #Other;
    };

    public type ModerationDecision = {
        action: ModerationAction;
        reason: ModerationReason;
        notes: ?Text;
        timestamp: Int;
        moderatorId: Text;
    };

    public type StorageConfig = {
        maxFileSize: Nat;
        allowedTypes: [Text];
        encryptionEnabled: Bool;
        redundancyLevel: Nat;
        retentionPeriod: Int;
    };

    public type StorageMetrics = {
        totalFiles: Nat;
        totalSize: Nat;
        activeUsers: Nat;
        storageUsed: Nat;
        lastBackup: ?Int;
    };

    public type IdentityConfig = {
        minAnonymityLevel: AnonymityLevel;
        maxLinkedIdentities: Nat;
        sessionDuration: Int;
        trustThreshold: Float;
        securityLevel: SecurityLevel;
    };

    public type IdentityMetrics = {
        totalIdentities: Nat;
        activeSessions: Nat;
        trustScore: Float;
        riskLevel: SecurityLevel;
        lastActivity: Int;
    };
} 