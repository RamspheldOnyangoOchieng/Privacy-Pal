import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import List "mo:base/List";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Types "../types";

module {
    // Text utilities
    public func isEmpty(text : Text) : Bool {
        Text.size(text) == 0
    };

    public func isNotEmpty(text : Text) : Bool {
        Text.size(text) > 0
    };

    public func contains(text : Text, substring : Text) : Bool {
        Text.contains(text, #text substring)
    };

    public func startsWith(text : Text, prefix : Text) : Bool {
        Text.startsWith(text, #text prefix)
    };

    public func endsWith(text : Text, suffix : Text) : Bool {
        Text.endsWith(text, #text suffix)
    };

    // Number utilities
    public func isPositive(n : Nat) : Bool {
        n > 0
    };

    public func isNegative(n : Int) : Bool {
        n < 0
    };

    public func isZero(n : Nat) : Bool {
        n == 0
    };

    public func max(a : Nat, b : Nat) : Nat {
        if (a > b) a else b
    };

    public func min(a : Nat, b : Nat) : Nat {
        if (a < b) a else b
    };

    // Time utilities
    public func isExpired(timestamp : Time.Time) : Bool {
        Time.now() > timestamp
    };

    public func isFuture(timestamp : Time.Time) : Bool {
        Time.now() < timestamp
    };

    public func addSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        timestamp + (seconds * 1_000_000_000)
    };

    public func subtractSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        timestamp - (seconds * 1_000_000_000)
    };

    // Principal utilities
    public func isAnonymous(principal : Principal) : Bool {
        Principal.isAnonymous(principal)
    };

    public func toText(principal : Principal) : Text {
        Principal.toText(principal)
    };

    public func fromText(text : Text) : Result.Result<Principal, Text> {
        try {
            #ok(Principal.fromText(text))
        } catch (e) {
            #err("Invalid principal: " # Error.message(e))
        }
    };

    // Option utilities
    public func isSome<T>(option : Option.Option<T>) : Bool {
        Option.isSome(option)
    };

    public func isNone<T>(option : Option.Option<T>) : Bool {
        Option.isNone(option)
    };

    public func getOrElse<T>(option : Option.Option<T>, default : T) : T {
        Option.get(option, default)
    };

    // Result utilities
    public func isOk<T, E>(result : Result.Result<T, E>) : Bool {
        Result.isOk(result)
    };

    public func isErr<T, E>(result : Result.Result<T, E>) : Bool {
        Result.isErr(result)
    };

    public func getOrElse<T, E>(result : Result.Result<T, E>, default : T) : T {
        switch (result) {
            case (#ok(value)) value;
            case (#err(_)) default;
        }
    };

    // Array utilities
    public func isEmpty<T>(array : [T]) : Bool {
        Array.size(array) == 0
    };

    public func isNotEmpty<T>(array : [T]) : Bool {
        Array.size(array) > 0
    };

    public func contains<T>(array : [T], element : T, equal : (T, T) -> Bool) : Bool {
        Array.find(array, func(x : T) : Bool { equal(x, element) }) != null
    };

    // List utilities
    public func isEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) == 0
    };

    public func isNotEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) > 0
    };

    public func contains<T>(list : List.List<T>, element : T, equal : (T, T) -> Bool) : Bool {
        List.find(list, func(x : T) : Bool { equal(x, element) }) != null
    };

    // Validation utilities
    public func isValidEmail(email : Text) : Bool {
        let pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        Text.matches(email, #text pattern)
    };

    public func isValidPhone(phone : Text) : Bool {
        let pattern = "^\\+?[1-9]\\d{1,14}$";
        Text.matches(phone, #text pattern)
    };

    public func isValidUrl(url : Text) : Bool {
        let pattern = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";
        Text.matches(url, #text pattern)
    };

    public func isValidUsername(username : Text) : Bool {
        let pattern = "^[a-zA-Z0-9_-]{3,16}$";
        Text.matches(username, #text pattern)
    };

    public func isValidPassword(password : Text) : Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
        Text.matches(password, #text pattern)
    };

    // Error utilities
    public func createError(code : Nat, message : Text, details : ?Text) : Types.Error {
        {
            code = code;
            message = message;
            details = details;
        }
    };

    public func getErrorMessage(error : Types.Error) : Text {
        switch (error.details) {
            case (null) error.message;
            case (?details) error.message # ": " # details;
        }
    };

    // Debug utilities
    public func debug<T>(value : T) : () {
        Debug.print(debug_show(value))
    };

    public func debugError(error : Types.Error) : () {
        Debug.print("Error: " # getErrorMessage(error))
    };

    // Report utilities
    public func validateReport(report : Types.Report) : Result.Result<(), Text> {
        if (isEmpty(report.title)) {
            return #err("Report title cannot be empty")
        };
        if (isEmpty(report.description)) {
            return #err("Report description cannot be empty")
        };
        if (report.category == #other and isNone(report.customCategory)) {
            return #err("Custom category is required for 'other' category")
        };
        #ok()
    };

    // Action utilities
    public func validateAction(action : Types.Action) : Result.Result<(), Text> {
        if (isEmpty(action.reason)) {
            return #err("Action reason cannot be empty")
        };
        if (action.type == #custom and isNone(action.customType)) {
            return #err("Custom type is required for 'custom' action type")
        };
        #ok()
    };

    // Rule utilities
    public func validateRule(rule : Types.Rule) : Result.Result<(), Text> {
        if (isEmpty(rule.name)) {
            return #err("Rule name cannot be empty")
        };
        if (isEmpty(rule.description)) {
            return #err("Rule description cannot be empty")
        };
        if (rule.type == #custom and isNone(rule.customType)) {
            return #err("Custom type is required for 'custom' rule type")
        };
        if (isEmpty(rule.conditions)) {
            return #err("Rule must have at least one condition")
        };
        if (isEmpty(rule.actions)) {
            return #err("Rule must have at least one action")
        };
        #ok()
    };

    // Moderator utilities
    public func validateModerator(moderator : Types.Moderator) : Result.Result<(), Text> {
        if (isEmpty(moderator.name)) {
            return #err("Moderator name cannot be empty")
        };
        if (not isValidEmail(moderator.email)) {
            return #err("Invalid email address")
        };
        if (isEmpty(moderator.specialization)) {
            return #err("Moderator must have at least one specialization")
        };
        if (isEmpty(moderator.languages)) {
            return #err("Moderator must have at least one language")
        };
        if (isEmpty(moderator.regions)) {
            return #err("Moderator must have at least one region")
        };
        #ok()
    };

    // Content utilities
    public func validateContent(content : Types.Content) : Result.Result<(), Text> {
        if (isEmpty(content.data)) {
            return #err("Content data cannot be empty")
        };
        if (isEmpty(content.metadata)) {
            return #err("Content must have at least one metadata field")
        };
        #ok()
    };

    // Category utilities
    public func validateCategory(category : Types.Category) : Result.Result<(), Text> {
        if (isEmpty(category.name)) {
            return #err("Category name cannot be empty")
        };
        if (isEmpty(category.description)) {
            return #err("Category description cannot be empty")
        };
        #ok()
    };

    // Filter utilities
    public func validateFilter(filter : Types.Filter) : Result.Result<(), Text> {
        if (isEmpty(filter.name)) {
            return #err("Filter name cannot be empty")
        };
        if (isEmpty(filter.pattern)) {
            return #err("Filter pattern cannot be empty")
        };
        if (isZero(filter.priority)) {
            return #err("Filter priority must be greater than zero")
        };
        #ok()
    };

    // Template utilities
    public func validateTemplate(template : Types.Template) : Result.Result<(), Text> {
        if (isEmpty(template.name)) {
            return #err("Template name cannot be empty")
        };
        if (isEmpty(template.content)) {
            return #err("Template content cannot be empty")
        };
        if (isEmpty(template.variables)) {
            return #err("Template must have at least one variable")
        };
        #ok()
    };

    // Queue utilities
    public func validateQueue(queue : Types.Queue) : Result.Result<(), Text> {
        if (isEmpty(queue.name)) {
            return #err("Queue name cannot be empty")
        };
        if (isEmpty(queue.items)) {
            return #err("Queue must have at least one item")
        };
        #ok()
    };

    // Appeal utilities
    public func validateAppeal(appeal : Types.Appeal) : Result.Result<(), Text> {
        if (isEmpty(appeal.reason)) {
            return #err("Appeal reason cannot be empty")
        };
        #ok()
    };

    // Comment utilities
    public func validateComment(comment : Types.Comment) : Result.Result<(), Text> {
        if (isEmpty(comment.content)) {
            return #err("Comment content cannot be empty")
        };
        #ok()
    };

    // Notification utilities
    public func validateNotification(notification : Types.Notification) : Result.Result<(), Text> {
        if (isEmpty(notification.title)) {
            return #err("Notification title cannot be empty")
        };
        if (isEmpty(notification.content)) {
            return #err("Notification content cannot be empty")
        };
        #ok()
    };

    // Alert utilities
    public func validateAlert(alert : Types.Alert) : Result.Result<(), Text> {
        if (isEmpty(alert.message)) {
            return #err("Alert message cannot be empty")
        };
        #ok()
    };

    // Audit utilities
    public func validateAudit(audit : Types.Audit) : Result.Result<(), Text> {
        if (isEmpty(audit.action)) {
            return #err("Audit action cannot be empty")
        };
        if (isEmpty(audit.details)) {
            return #err("Audit details cannot be empty")
        };
        #ok()
    };
}; 