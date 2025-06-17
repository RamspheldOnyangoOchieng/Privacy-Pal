

module {
    public class CommunityManager() {
        private var reviewers = HashMap.new<Text, Types.Reviewer>();
        private var reviews = HashMap.new<Text, Types.Review>();
        private var reviewAssignments = HashMap.new<Text, Types.ReviewAssignment>();
        private var reviewMetrics = HashMap.new<Text, Types.ReviewMetrics>();

        public func registerReviewer(
            category: Types.ReportCategory,
            expertise: [Types.ExpertiseArea]
        ) : Types.Reviewer {
            let reviewerId = Utils.generateSecureId();
            let now = Time.now();
            
            let reviewer : Types.Reviewer = {
                id = reviewerId;
                createdAt = now;
                lastActive = now;
                category = category;
                expertise = expertise;
                status = #Active;
                reviewsCompleted = 0;
                accuracyScore = 1.0;
                trustScore = 1.0;
                assignedReviews = [];
            };

            reviewers.put(reviewerId, reviewer);
            reviewer
        };

        public func assignReview(
            reportId: Text,
            category: Types.ReportCategory
        ) : ?[Types.ReviewAssignment] {
            let availableReviewers = findAvailableReviewers(category);
            if (Array.size(availableReviewers) == 0) {
                return null;
            };

            let assignments = Buffer.Buffer<Types.ReviewAssignment>(0);
            for (reviewer in availableReviewers.vals()) {
                let assignment : Types.ReviewAssignment = {
                    reportId = reportId;
                    reviewerId = reviewer.id;
                    assignedAt = Time.now();
                    deadline = Time.now() + Constants.REVIEW_DEADLINE;
                    status = #Pending;
                };

                assignments.add(assignment);
                
                // Update reviewer's assigned reviews
                let updatedReviews = Array.append(reviewer.assignedReviews, [reportId]);
                let updatedReviewer = {
                    reviewer with
                    assignedReviews = updatedReviews;
                };
                
                reviewers.put(reviewer.id, updatedReviewer);
            };

            let assignmentArray = Buffer.toArray(assignments);
            reviewAssignments.put(reportId, assignmentArray);
            ?assignmentArray
        };

        public func submitReview(
            reviewerId: Text,
            reportId: Text,
            decision: Types.ReviewDecision,
            comments: Text
        ) : ?Types.Review {
            switch(reviewers.get(reviewerId)) {
                case (?reviewer) {
                    let review : Types.Review = {
                        id = Utils.generateSecureId();
                        reportId = reportId;
                        reviewerId = reviewerId;
                        submittedAt = Time.now();
                        decision = decision;
                        comments = comments;
                        confidence = calculateConfidence(reviewer, decision);
                        verificationStatus = #Pending;
                    };

                    reviews.put(review.id, review);
                    
                    // Update reviewer metrics
                    let updatedReviewer = {
                        reviewer with
                        reviewsCompleted = reviewer.reviewsCompleted + 1;
                    };
                    
                    reviewers.put(reviewerId, updatedReviewer);
                    ?review
                };
                case null null;
            }
        };

        public func verifyReview(reviewId: Text) : ?Types.Review {
            switch(reviews.get(reviewId)) {
                case (?review) {
                    let updatedReview = {
                        review with
                        verificationStatus = #Verified;
                    };
                    
                    reviews.put(reviewId, updatedReview);
                    ?updatedReview
                };
                case null null;
            }
        };

        private func findAvailableReviewers(category: Types.ReportCategory) : [Types.Reviewer] {
            let available = Buffer.Buffer<Types.Reviewer>(0);
            
            for ((_, reviewer) in reviewers.entries()) {
                if (reviewer.category == category and 
                    reviewer.status == #Active and 
                    Array.size(reviewer.assignedReviews) < Constants.MAX_ASSIGNED_REVIEWS) {
                    available.add(reviewer);
                };
            };
            
            Buffer.toArray(available)
        };

        private func calculateConfidence(
            reviewer: Types.Reviewer,
            decision: Types.ReviewDecision
        ) : Float {
            // TODO: Implement confidence calculation based on reviewer's history and expertise
            reviewer.accuracyScore
        };

        public func getReviewerMetrics(reviewerId: Text) : ?Types.ReviewMetrics {
            switch(reviewers.get(reviewerId)) {
                case (?reviewer) {
                    let metrics : Types.ReviewMetrics = {
                        reviewerId = reviewerId;
                        reviewsCompleted = reviewer.reviewsCompleted;
                        accuracyScore = reviewer.accuracyScore;
                        trustScore = reviewer.trustScore;
                        averageResponseTime = calculateAverageResponseTime(reviewerId);
                        lastUpdated = Time.now();
                    };
                    
                    reviewMetrics.put(reviewerId, metrics);
                    ?metrics
                };
                case null null;
            }
        };

        private func calculateAverageResponseTime(reviewerId: Text) : Float {
            // TODO: Implement average response time calculation
            0.0
        };
    };
}; 