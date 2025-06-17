

actor class AppealCanister {
    // State variables
    private stable var appeals = HashMap.new<Text, Types.Appeal>();
    private stable var reviews = HashMap.new<Text, Types.Review>();
    private stable var comments = HashMap.new<Text, Types.Comment>();
    private stable var attachments = HashMap.new<Text, Types.Attachment>();
    private stable var metrics = HashMap.new<Text, Types.AppealMetrics>();
    private stable var history = HashMap.new<Text, Types.AppealHistory>();

    // Private helper functions
    private func generateAppealId() : Text {
        "appeal_" # Nat.toText(Time.now())
    };

    private func generateReviewId() : Text {
        "review_" # Nat.toText(Time.now())
    };

    private func generateCommentId() : Text {
        "comment_" # Nat.toText(Time.now())
    };

    private func generateAttachmentId() : Text {
        "attachment_" # Nat.toText(Time.now())
    };

    private func validateAppeal(appeal : Types.Appeal) : Result.Result<(), Text> {
        if (Utils.isEmpty(appeal.reason)) {
            #err("Appeal reason cannot be empty")
        } else if (Utils.isEmpty(appeal.evidence)) {
            #err("Appeal evidence cannot be empty")
        } else if (appeal.priority < 0 or appeal.priority > 10) {
            #err("Appeal priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateReview(review : Types.Review) : Result.Result<(), Text> {
        if (Utils.isEmpty(review.decision)) {
            #err("Review decision cannot be empty")
        } else if (Utils.isEmpty(review.explanation)) {
            #err("Review explanation cannot be empty")
        } else if (review.priority < 0 or review.priority > 10) {
            #err("Review priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateComment(comment : Types.Comment) : Result.Result<(), Text> {
        if (Utils.isEmpty(comment.content)) {
            #err("Comment content cannot be empty")
        } else if (comment.priority < 0 or comment.priority > 10) {
            #err("Comment priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateAttachment(attachment : Types.Attachment) : Result.Result<(), Text> {
        if (Utils.isEmpty(attachment.name)) {
            #err("Attachment name cannot be empty")
        } else if (Utils.isEmpty(attachment.type)) {
            #err("Attachment type cannot be empty")
        } else if (Utils.isEmpty(attachment.data)) {
            #err("Attachment data cannot be empty")
        } else {
            #ok()
        }
    };

    private func updateAppealMetrics(appealId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, appealId), {
            views = 0;
            comments = 0;
            attachments = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, appealId, updatedMetrics)
    };

    private func updateAppealHistory(appealId : Text, action : Text, reviewId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, appealId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            reviewId = reviewId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, appealId, updatedHistory)
    };

    // Public shared functions
    public shared(msg) func createAppeal(appeal : Types.Appeal) : async Result.Result<Text, Text> {
        switch (validateAppeal(appeal)) {
            case (#ok()) {
                let appealId = generateAppealId();
                let newAppeal = {
                    appeal with
                    id = appealId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(appeals, Text.equal, appealId, newAppeal);
                updateAppealMetrics(appealId, "created", 1);
                updateAppealHistory(appealId, "created", "");
                #ok(appealId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createReview(review : Types.Review) : async Result.Result<Text, Text> {
        switch (validateReview(review)) {
            case (#ok()) {
                let reviewId = generateReviewId();
                let newReview = {
                    review with
                    id = reviewId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(reviews, Text.equal, reviewId, newReview);
                updateAppealHistory(review.appealId, "review_created", reviewId);
                #ok(reviewId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createComment(comment : Types.Comment) : async Result.Result<Text, Text> {
        switch (validateComment(comment)) {
            case (#ok()) {
                let commentId = generateCommentId();
                let newComment = {
                    comment with
                    id = commentId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(comments, Text.equal, commentId, newComment);
                updateAppealMetrics(comment.appealId, "comment_added", 1);
                #ok(commentId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createAttachment(attachment : Types.Attachment) : async Result.Result<Text, Text> {
        switch (validateAttachment(attachment)) {
            case (#ok()) {
                let attachmentId = generateAttachmentId();
                let newAttachment = {
                    attachment with
                    id = attachmentId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(attachments, Text.equal, attachmentId, newAttachment);
                updateAppealMetrics(attachment.appealId, "attachment_added", 1);
                #ok(attachmentId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func updateAppealStatus(appealId : Text, status : Types.AppealStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(appeals, Text.equal, appealId)) {
            case (?appeal) {
                let updatedAppeal = {
                    appeal with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(appeals, Text.equal, appealId, updatedAppeal);
                updateAppealHistory(appealId, "status_updated", "");
                #ok()
            };
            case null #err("Appeal not found")
        }
    };

    public shared(msg) func updateReviewStatus(reviewId : Text, status : Types.ReviewStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(reviews, Text.equal, reviewId)) {
            case (?review) {
                let updatedReview = {
                    review with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(reviews, Text.equal, reviewId, updatedReview);
                updateAppealHistory(review.appealId, "review_status_updated", reviewId);
                #ok()
            };
            case null #err("Review not found")
        }
    };

    // Query functions
    public query func getAppeal(appealId : Text) : async ?Types.Appeal {
        HashMap.get(appeals, Text.equal, appealId)
    };

    public query func getReview(reviewId : Text) : async ?Types.Review {
        HashMap.get(reviews, Text.equal, reviewId)
    };

    public query func getComment(commentId : Text) : async ?Types.Comment {
        HashMap.get(comments, Text.equal, commentId)
    };

    public query func getAttachment(attachmentId : Text) : async ?Types.Attachment {
        HashMap.get(attachments, Text.equal, attachmentId)
    };

    public query func getAppealMetrics(appealId : Text) : async ?Types.AppealMetrics {
        HashMap.get(metrics, Text.equal, appealId)
    };

    public query func getAppealHistory(appealId : Text) : async ?Types.AppealHistory {
        HashMap.get(history, Text.equal, appealId)
    };

    public query func getAppealReviews(appealId : Text) : async [Types.Review] {
        let reviews = HashMap.entries(reviews);
        let filteredReviews = Array.filter(reviews, func((id, review) : (Text, Types.Review)) : Bool {
            review.appealId == appealId
        });
        Array.map(filteredReviews, func((id, review) : (Text, Types.Review)) : Types.Review { review })
    };

    public query func getAppealComments(appealId : Text) : async [Types.Comment] {
        let comments = HashMap.entries(comments);
        let filteredComments = Array.filter(comments, func((id, comment) : (Text, Types.Comment)) : Bool {
            comment.appealId == appealId
        });
        Array.map(filteredComments, func((id, comment) : (Text, Types.Comment)) : Types.Comment { comment })
    };

    public query func getAppealAttachments(appealId : Text) : async [Types.Attachment] {
        let attachments = HashMap.entries(attachments);
        let filteredAttachments = Array.filter(attachments, func((id, attachment) : (Text, Types.Attachment)) : Bool {
            attachment.appealId == appealId
        });
        Array.map(filteredAttachments, func((id, attachment) : (Text, Types.Attachment)) : Types.Attachment { attachment })
    };
}; 