

actor class FilterCanister {
    // State variables
    private stable var filters = HashMap.new<Text, Types.Filter>();
    private stable var rules = HashMap.new<Text, Types.Rule>();
    private stable var patterns = HashMap.new<Text, Types.Pattern>();
    private stable var metrics = HashMap.new<Text, Types.FilterMetrics>();
    private stable var history = HashMap.new<Text, Types.FilterHistory>();

    // Private helper functions
    private func generateFilterId() : Text {
        "filter_" # Nat.toText(Time.now())
    };

    private func generateRuleId() : Text {
        "rule_" # Nat.toText(Time.now())
    };

    private func generatePatternId() : Text {
        "pattern_" # Nat.toText(Time.now())
    };

    private func validateFilter(filter : Types.Filter) : Result.Result<(), Text> {
        if (Utils.isEmpty(filter.name)) {
            #err("Filter name cannot be empty")
        } else if (Utils.isEmpty(filter.description)) {
            #err("Filter description cannot be empty")
        } else if (filter.priority < 0 or filter.priority > 10) {
            #err("Filter priority must be between 0 and 10")
        } else if (Array.size(filter.rules) == 0) {
            #err("Filter must have at least one rule")
        } else {
            #ok()
        }
    };

    private func validateRule(rule : Types.Rule) : Result.Result<(), Text> {
        if (Utils.isEmpty(rule.name)) {
            #err("Rule name cannot be empty")
        } else if (Utils.isEmpty(rule.description)) {
            #err("Rule description cannot be empty")
        } else if (rule.priority < 0 or rule.priority > 10) {
            #err("Rule priority must be between 0 and 10")
        } else if (Array.size(rule.patterns) == 0) {
            #err("Rule must have at least one pattern")
        } else {
            #ok()
        }
    };

    private func validatePattern(pattern : Types.Pattern) : Result.Result<(), Text> {
        if (Utils.isEmpty(pattern.pattern)) {
            #err("Pattern cannot be empty")
        } else if (pattern.type == #regex and not Utils.isValidRegex(pattern.pattern)) {
            #err("Invalid regex pattern")
        } else {
            #ok()
        }
    };

    private func updateFilterMetrics(filterId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, filterId), {
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
        HashMap.put(metrics, Text.equal, filterId, updatedMetrics)
    };

    private func updateFilterHistory(filterId : Text, action : Text, ruleId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, filterId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            ruleId = ruleId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, filterId, updatedHistory)
    };

    private func applyFilter(content : Text, filter : Types.Filter) : Result.Result<Bool, Text> {
        var matched = false;
        for (ruleId in filter.rules.vals()) {
            switch (HashMap.get(rules, Text.equal, ruleId)) {
                case (?rule) {
                    switch (applyRule(content, rule)) {
                        case (#ok(result)) {
                            if (result) {
                                matched := true;
                                break
                            }
                        };
                        case (#err(msg)) return #err(msg)
                    }
                };
                case null return #err("Rule not found")
            }
        };
        #ok(matched)
    };

    private func applyRule(content : Text, rule : Types.Rule) : Result.Result<Bool, Text> {
        var matched = false;
        for (patternId in rule.patterns.vals()) {
            switch (HashMap.get(patterns, Text.equal, patternId)) {
                case (?pattern) {
                    switch (applyPattern(content, pattern)) {
                        case (#ok(result)) {
                            if (result) {
                                matched := true;
                                break
                            }
                        };
                        case (#err(msg)) return #err(msg)
                    }
                };
                case null return #err("Pattern not found")
            }
        };
        #ok(matched)
    };

    private func applyPattern(content : Text, pattern : Types.Pattern) : Result.Result<Bool, Text> {
        switch (pattern.type) {
            case (#exact) {
                #ok(Text.contains(content, #text pattern.pattern))
            };
            case (#regex) {
                switch (Utils.matchRegex(content, pattern.pattern)) {
                    case (#ok(result)) #ok(result);
                    case (#err(msg)) #err(msg)
                }
            };
            case (#keyword) {
                let keywords = Text.split(pattern.pattern, #char ' ');
                var matched = false;
                for (keyword in keywords) {
                    if (Text.contains(content, #text keyword)) {
                        matched := true;
                        break
                    }
                };
                #ok(matched)
            }
        }
    };

    // Public shared functions
    public shared(msg) func createFilter(filter : Types.Filter) : async Result.Result<Text, Text> {
        switch (validateFilter(filter)) {
            case (#ok()) {
                let filterId = generateFilterId();
                let newFilter = {
                    filter with
                    id = filterId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(filters, Text.equal, filterId, newFilter);
                updateFilterMetrics(filterId, "created", 1);
                updateFilterHistory(filterId, "created", "");
                #ok(filterId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createRule(rule : Types.Rule) : async Result.Result<Text, Text> {
        switch (validateRule(rule)) {
            case (#ok()) {
                let ruleId = generateRuleId();
                let newRule = {
                    rule with
                    id = ruleId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(rules, Text.equal, ruleId, newRule);
                #ok(ruleId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createPattern(pattern : Types.Pattern) : async Result.Result<Text, Text> {
        switch (validatePattern(pattern)) {
            case (#ok()) {
                let patternId = generatePatternId();
                let newPattern = {
                    pattern with
                    id = patternId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(patterns, Text.equal, patternId, newPattern);
                #ok(patternId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func addRuleToFilter(filterId : Text, ruleId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(filters, Text.equal, filterId)) {
            case (?filter) {
                switch (HashMap.get(rules, Text.equal, ruleId)) {
                    case (?rule) {
                        let updatedFilter = {
                            filter with
                            rules = Array.append(filter.rules, [ruleId]);
                            updatedAt = Time.now()
                        };
                        HashMap.put(filters, Text.equal, filterId, updatedFilter);
                        updateFilterHistory(filterId, "rule_added", ruleId);
                        #ok()
                    };
                    case null #err("Rule not found")
                }
            };
            case null #err("Filter not found")
        }
    };

    public shared(msg) func addPatternToRule(ruleId : Text, patternId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(rules, Text.equal, ruleId)) {
            case (?rule) {
                switch (HashMap.get(patterns, Text.equal, patternId)) {
                    case (?pattern) {
                        let updatedRule = {
                            rule with
                            patterns = Array.append(rule.patterns, [patternId]);
                            updatedAt = Time.now()
                        };
                        HashMap.put(rules, Text.equal, ruleId, updatedRule);
                        #ok()
                    };
                    case null #err("Pattern not found")
                }
            };
            case null #err("Rule not found")
        }
    };

    public shared(msg) func checkContent(content : Text, filterId : Text) : async Result.Result<Bool, Text> {
        switch (HashMap.get(filters, Text.equal, filterId)) {
            case (?filter) {
                switch (applyFilter(content, filter)) {
                    case (#ok(matched)) {
                        updateFilterMetrics(filterId, "checked", 1);
                        if (matched) {
                            updateFilterMetrics(filterId, "matched", 1)
                        };
                        #ok(matched)
                    };
                    case (#err(msg)) #err(msg)
                }
            };
            case null #err("Filter not found")
        }
    };

    // Query functions
    public query func getFilter(filterId : Text) : async ?Types.Filter {
        HashMap.get(filters, Text.equal, filterId)
    };

    public query func getRule(ruleId : Text) : async ?Types.Rule {
        HashMap.get(rules, Text.equal, ruleId)
    };

    public query func getPattern(patternId : Text) : async ?Types.Pattern {
        HashMap.get(patterns, Text.equal, patternId)
    };

    public query func getFilterMetrics(filterId : Text) : async ?Types.FilterMetrics {
        HashMap.get(metrics, Text.equal, filterId)
    };

    public query func getFilterHistory(filterId : Text) : async ?Types.FilterHistory {
        HashMap.get(history, Text.equal, filterId)
    };

    public query func getFilterRules(filterId : Text) : async [Types.Rule] {
        switch (HashMap.get(filters, Text.equal, filterId)) {
            case (?filter) {
                let rules = Array.map(filter.rules, func(ruleId : Text) : ?Types.Rule {
                    HashMap.get(rules, Text.equal, ruleId)
                });
                Array.filterMap(rules, func(rule : ?Types.Rule) : ?Types.Rule { rule })
            };
            case null []
        }
    };

    public query func getRulePatterns(ruleId : Text) : async [Types.Pattern] {
        switch (HashMap.get(rules, Text.equal, ruleId)) {
            case (?rule) {
                let patterns = Array.map(rule.patterns, func(patternId : Text) : ?Types.Pattern {
                    HashMap.get(patterns, Text.equal, patternId)
                });
                Array.filterMap(patterns, func(pattern : ?Types.Pattern) : ?Types.Pattern { pattern })
            };
            case null []
        }
    };
}; 