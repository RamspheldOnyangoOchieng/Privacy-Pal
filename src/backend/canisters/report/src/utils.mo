import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Array "mo:base/Array";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Types "../types";
import Constants "../constants";

module {
    // Text utilities
    public func isEmpty(text : Text) : Bool {
        Text.size(text) == 0
    };

    public func isNotEmpty(text : Text) : Bool {
        not isEmpty(text)
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

    public func principalToText(principal : Principal) : Text {
        Principal.toText(principal)
    };

    public func textToPrincipal(text : Text) : ?Principal {
        Principal.fromText(text)
    };

    // Option utilities
    public func isSome<T>(option : ?T) : Bool {
        Option.isSome(option)
    };

    public func isNone<T>(option : ?T) : Bool {
        Option.isNone(option)
    };

    public func getOr<T>(option : ?T, default : T) : T {
        Option.get(option, default)
    };

    // Result utilities
    public func isOk<T, E>(result : Result.Result<T, E>) : Bool {
        switch (result) {
            case (#ok(_)) true;
            case (#err(_)) false;
        }
    };

    public func isErr<T, E>(result : Result.Result<T, E>) : Bool {
        not isOk(result)
    };

    // Array utilities
    public func isEmpty<T>(array : [T]) : Bool {
        Array.size(array) == 0
    };

    public func isNotEmpty<T>(array : [T]) : Bool {
        not isEmpty(array)
    };

    public func contains<T>(array : [T], element : T, equal : (T, T) -> Bool) : Bool {
        Array.find(array, func(x : T) : Bool { equal(x, element) }) != null
    };

    // List utilities
    public func isEmpty<T>(list : List.List<T>) : Bool {
        List.isNil(list)
    };

    public func isNotEmpty<T>(list : List.List<T>) : Bool {
        not isEmpty(list)
    };

    public func contains<T>(list : List.List<T>, element : T, equal : (T, T) -> Bool) : Bool {
        List.find(list, func(x : T) : Bool { equal(x, element) }) != null
    };

    // Validation utilities
    public func isValidEmail(email : Text) : Bool {
        let pattern = Constants.EMAIL_PATTERN;
        Text.matches(email, #text pattern)
    };

    public func isValidPhone(phone : Text) : Bool {
        let pattern = Constants.PHONE_PATTERN;
        Text.matches(phone, #text pattern)
    };

    public func isValidUrl(url : Text) : Bool {
        let pattern = Constants.URL_PATTERN;
        Text.matches(url, #text pattern)
    };

    public func isValidUsername(username : Text) : Bool {
        let pattern = Constants.USERNAME_PATTERN;
        Text.matches(username, #text pattern)
    };

    public func isValidPassword(password : Text) : Bool {
        let pattern = Constants.PASSWORD_PATTERN;
        Text.matches(password, #text pattern)
    };

    // Error utilities
    public func createError(code : Nat, message : Text) : Types.Error {
        {
            code = code;
            message = message;
        }
    };

    public func getErrorMessage(error : Types.Error) : Text {
        error.message
    };

    public func getErrorCode(error : Types.Error) : Nat {
        error.code
    };

    // Debug utilities
    public func printInfo(message : Text) : () {
        Debug.print("INFO: " # message)
    };

    public func printWarn(message : Text) : () {
        Debug.print("WARN: " # message)
    };

    public func printError(message : Text) : () {
        Debug.print("ERROR: " # message)
    };

    // Report validation utilities
    public func isValidReportTitle(title : Text) : Bool {
        isNotEmpty(title) and Text.size(title) <= Constants.MAX_REPORT_TITLE_LENGTH
    };

    public func isValidReportDescription(description : Text) : Bool {
        isNotEmpty(description) and Text.size(description) <= Constants.MAX_REPORT_DESCRIPTION_LENGTH
    };

    public func isValidReportPriority(priority : Nat) : Bool {
        priority >= 0 and priority <= 10
    };

    // Submission validation utilities
    public func isValidSubmissionContent(content : Text) : Bool {
        isNotEmpty(content) and Text.size(content) <= Constants.MAX_SUBMISSION_CONTENT_LENGTH
    };

    public func isValidSubmissionPriority(priority : Nat) : Bool {
        priority >= 0 and priority <= 10
    };

    // Category validation utilities
    public func isValidCategoryName(name : Text) : Bool {
        isNotEmpty(name) and Text.size(name) <= Constants.MAX_CATEGORY_NAME_LENGTH
    };

    public func isValidCategoryDescription(description : Text) : Bool {
        isNotEmpty(description) and Text.size(description) <= Constants.MAX_CATEGORY_DESCRIPTION_LENGTH
    };

    // Attachment validation utilities
    public func isValidAttachmentName(name : Text) : Bool {
        isNotEmpty(name) and Text.size(name) <= Constants.MAX_ATTACHMENT_NAME_LENGTH
    };

    public func isValidAttachmentType(type : Text) : Bool {
        isNotEmpty(type) and Text.size(type) <= Constants.MAX_ATTACHMENT_TYPE_LENGTH
    };

    public func isValidAttachmentData(data : Text) : Bool {
        isNotEmpty(data) and Text.size(data) <= Constants.MAX_ATTACHMENT_DATA_LENGTH
    };

    // Comment validation utilities
    public func isValidCommentContent(content : Text) : Bool {
        isNotEmpty(content) and Text.size(content) <= Constants.MAX_COMMENT_CONTENT_LENGTH
    };

    public func isValidCommentPriority(priority : Nat) : Bool {
        priority >= 0 and priority <= 10
    };
}; 