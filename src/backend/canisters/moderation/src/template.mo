

actor class TemplateCanister {
    // State variables
    private stable var templates = HashMap.new<Text, Types.Template>();
    private stable var variables = HashMap.new<Text, Types.TemplateVariable>();
    private stable var categories = HashMap.new<Text, Types.TemplateCategory>();
    private stable var metrics = HashMap.new<Text, Types.TemplateMetrics>();
    private stable var history = HashMap.new<Text, Types.TemplateHistory>();

    // Private helper functions
    private func generateTemplateId() : Text {
        "template_" # Nat.toText(Time.now())
    };

    private func generateVariableId() : Text {
        "variable_" # Nat.toText(Time.now())
    };

    private func generateCategoryId() : Text {
        "category_" # Nat.toText(Time.now())
    };

    private func validateTemplate(template : Types.Template) : Result.Result<(), Text> {
        if (Utils.isEmpty(template.name)) {
            #err("Template name cannot be empty")
        } else if (Utils.isEmpty(template.description)) {
            #err("Template description cannot be empty")
        } else if (Utils.isEmpty(template.content)) {
            #err("Template content cannot be empty")
        } else if (template.priority < 0 or template.priority > 10) {
            #err("Template priority must be between 0 and 10")
        } else if (Array.size(template.variables) == 0) {
            #err("Template must have at least one variable")
        } else {
            #ok()
        }
    };

    private func validateVariable(variable : Types.TemplateVariable) : Result.Result<(), Text> {
        if (Utils.isEmpty(variable.name)) {
            #err("Variable name cannot be empty")
        } else if (Utils.isEmpty(variable.description)) {
            #err("Variable description cannot be empty")
        } else if (Utils.isEmpty(variable.type)) {
            #err("Variable type cannot be empty")
        } else if (variable.required and Utils.isEmpty(variable.defaultValue)) {
            #err("Required variable must have a default value")
        } else {
            #ok()
        }
    };

    private func validateCategory(category : Types.TemplateCategory) : Result.Result<(), Text> {
        if (Utils.isEmpty(category.name)) {
            #err("Category name cannot be empty")
        } else if (Utils.isEmpty(category.description)) {
            #err("Category description cannot be empty")
        } else {
            #ok()
        }
    };

    private func updateTemplateMetrics(templateId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, templateId), {
            uses = 0;
            errors = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            uses = currentMetrics.uses + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, templateId, updatedMetrics)
    };

    private func updateTemplateHistory(templateId : Text, action : Text, variableId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, templateId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            variableId = variableId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, templateId, updatedHistory)
    };

    private func processTemplate(template : Types.Template, variables : [(Text, Text)]) : Result.Result<Text, Text> {
        var content = template.content;
        for ((name, value) in variables.vals()) {
            let placeholder = "{{" # name # "}}";
            if (Text.contains(content, #text placeholder)) {
                content := Text.replace(content, #text placeholder, value)
            } else {
                return #err("Variable " # name # " not found in template")
            }
        };
        #ok(content)
    };

    // Public shared functions
    public shared(msg) func createTemplate(template : Types.Template) : async Result.Result<Text, Text> {
        switch (validateTemplate(template)) {
            case (#ok()) {
                let templateId = generateTemplateId();
                let newTemplate = {
                    template with
                    id = templateId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(templates, Text.equal, templateId, newTemplate);
                updateTemplateMetrics(templateId, "created", 1);
                updateTemplateHistory(templateId, "created", "");
                #ok(templateId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createVariable(variable : Types.TemplateVariable) : async Result.Result<Text, Text> {
        switch (validateVariable(variable)) {
            case (#ok()) {
                let variableId = generateVariableId();
                let newVariable = {
                    variable with
                    id = variableId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(variables, Text.equal, variableId, newVariable);
                #ok(variableId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createCategory(category : Types.TemplateCategory) : async Result.Result<Text, Text> {
        switch (validateCategory(category)) {
            case (#ok()) {
                let categoryId = generateCategoryId();
                let newCategory = {
                    category with
                    id = categoryId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(categories, Text.equal, categoryId, newCategory);
                #ok(categoryId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func addVariableToTemplate(templateId : Text, variableId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(templates, Text.equal, templateId)) {
            case (?template) {
                switch (HashMap.get(variables, Text.equal, variableId)) {
                    case (?variable) {
                        let updatedTemplate = {
                            template with
                            variables = Array.append(template.variables, [variableId]);
                            updatedAt = Time.now()
                        };
                        HashMap.put(templates, Text.equal, templateId, updatedTemplate);
                        updateTemplateHistory(templateId, "variable_added", variableId);
                        #ok()
                    };
                    case null #err("Variable not found")
                }
            };
            case null #err("Template not found")
        }
    };

    public shared(msg) func addTemplateToCategory(templateId : Text, categoryId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(templates, Text.equal, templateId)) {
            case (?template) {
                switch (HashMap.get(categories, Text.equal, categoryId)) {
                    case (?category) {
                        let updatedTemplate = {
                            template with
                            categoryId = categoryId;
                            updatedAt = Time.now()
                        };
                        HashMap.put(templates, Text.equal, templateId, updatedTemplate);
                        updateTemplateHistory(templateId, "category_added", categoryId);
                        #ok()
                    };
                    case null #err("Category not found")
                }
            };
            case null #err("Template not found")
        }
    };

    public shared(msg) func renderTemplate(templateId : Text, variables : [(Text, Text)]) : async Result.Result<Text, Text> {
        switch (HashMap.get(templates, Text.equal, templateId)) {
            case (?template) {
                switch (processTemplate(template, variables)) {
                    case (#ok(content)) {
                        updateTemplateMetrics(templateId, "rendered", 1);
                        #ok(content)
                    };
                    case (#err(msg)) {
                        updateTemplateMetrics(templateId, "error", 1);
                        #err(msg)
                    }
                }
            };
            case null #err("Template not found")
        }
    };

    // Query functions
    public query func getTemplate(templateId : Text) : async ?Types.Template {
        HashMap.get(templates, Text.equal, templateId)
    };

    public query func getVariable(variableId : Text) : async ?Types.TemplateVariable {
        HashMap.get(variables, Text.equal, variableId)
    };

    public query func getCategory(categoryId : Text) : async ?Types.TemplateCategory {
        HashMap.get(categories, Text.equal, categoryId)
    };

    public query func getTemplateMetrics(templateId : Text) : async ?Types.TemplateMetrics {
        HashMap.get(metrics, Text.equal, templateId)
    };

    public query func getTemplateHistory(templateId : Text) : async ?Types.TemplateHistory {
        HashMap.get(history, Text.equal, templateId)
    };

    public query func getTemplateVariables(templateId : Text) : async [Types.TemplateVariable] {
        switch (HashMap.get(templates, Text.equal, templateId)) {
            case (?template) {
                let variables = Array.map(template.variables, func(variableId : Text) : ?Types.TemplateVariable {
                    HashMap.get(variables, Text.equal, variableId)
                });
                Array.filterMap(variables, func(variable : ?Types.TemplateVariable) : ?Types.TemplateVariable { variable })
            };
            case null []
        }
    };

    public query func getCategoryTemplates(categoryId : Text) : async [Types.Template] {
        let templates = HashMap.entries(templates);
        let filteredTemplates = Array.filter(templates, func((id, template) : (Text, Types.Template)) : Bool {
            template.categoryId == categoryId
        });
        Array.map(filteredTemplates, func((id, template) : (Text, Types.Template)) : Types.Template { template })
    };
}; 