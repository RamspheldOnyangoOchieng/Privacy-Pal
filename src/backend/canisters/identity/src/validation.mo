import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Types "./types";
import Constants "./constants";

module {
    // Input Validation
    public func validateUserInput(input : Types.UserInput) : { #ok; #err : Text } {
        switch (validateUsername(input.username)) {
            case (#err(msg)) { #err(msg) };
            case (#ok) {
                switch (validateEmail(input.email)) {
                    case (#err(msg)) { #err(msg) };
                    case (#ok) {
                        switch (validatePassword(input.password)) {
                            case (#err(msg)) { #err(msg) };
                            case (#ok) { #ok }
                        }
                    }
                }
            }
        }
    };

    public func validateUsername(username : Text) : { #ok; #err : Text } {
        let length = Text.size(username);
        if (length < 3) {
            #err("Username must be at least 3 characters long")
        } else if (length > 30) {
            #err("Username must not exceed 30 characters")
        } else if (not Text.contains(username, #char 'a')) {
            #err("Username must contain at least one letter")
        } else {
            #ok
        }
    };

    public func validateEmail(email : Text) : { #ok; #err : Text } {
        if (not Text.contains(email, #char '@')) {
            #err("Invalid email format")
        } else if (not Text.contains(email, #char '.')) {
            #err("Invalid email format")
        } else {
            #ok
        }
    };

    public func validatePassword(password : Text) : { #ok; #err : Text } {
        let length = Text.size(password);
        if (length < Constants.MIN_PASSWORD_LENGTH) {
            #err("Password must be at least " # Nat.toText(Constants.MIN_PASSWORD_LENGTH) # " characters long")
        } else if (length > Constants.MAX_PASSWORD_LENGTH) {
            #err("Password must not exceed " # Nat.toText(Constants.MAX_PASSWORD_LENGTH) # " characters")
        } else if (not hasUpperCase(password)) {
            #err("Password must contain at least one uppercase letter")
        } else if (not hasLowerCase(password)) {
            #err("Password must contain at least one lowercase letter")
        } else if (not hasNumber(password)) {
            #err("Password must contain at least one number")
        } else if (not hasSpecialChar(password)) {
            #err("Password must contain at least one special character")
        } else {
            #ok
        }
    };

    // Session Validation
    public func validateSession(session : Types.Session) : { #ok; #err : Text } {
        if (Time.now() > session.expiresAt) {
            #err("Session has expired")
        } else if (session.status != #Active) {
            #err("Session is not active")
        } else {
            #ok
        }
    };

    public func validateDevice(device : Types.Device) : { #ok; #err : Text } {
        if (Text.size(device.fingerprint) != Constants.DEVICE_FINGERPRINT_LENGTH) {
            #err("Invalid device fingerprint")
        } else if (device.status != #Active) {
            #err("Device is not active")
        } else {
            #ok
        }
    };

    // Trust Score Validation
    public func validateTrustScore(score : Float) : { #ok; #err : Text } {
        if (score < Constants.MIN_TRUST_SCORE) {
            #err("Trust score below minimum")
        } else if (score > Constants.MAX_TRUST_SCORE) {
            #err("Trust score above maximum")
        } else {
            #ok
        }
    };

    // Anonymity Validation
    public func validateAnonymityScore(score : Float) : { #ok; #err : Text } {
        if (score < Constants.MIN_ANONYMITY_SCORE) {
            #err("Anonymity score below minimum")
        } else if (score > Constants.MAX_ANONYMITY_SCORE) {
            #err("Anonymity score above maximum")
        } else {
            #ok
        }
    };

    public func validateProtectionLevel(level : Nat) : { #ok; #err : Text } {
        if (level < Constants.MIN_PROTECTION_LEVEL) {
            #err("Protection level below minimum")
        } else if (level > Constants.MAX_PROTECTION_LEVEL) {
            #err("Protection level above maximum")
        } else {
            #ok
        }
    };

    // Community Validation
    public func validateReviewerScore(score : Float) : { #ok; #err : Text } {
        if (score < Constants.MIN_REVIEWER_SCORE) {
            #err("Reviewer score below minimum")
        } else if (score > Constants.MAX_REVIEWER_SCORE) {
            #err("Reviewer score above maximum")
        } else {
            #ok
        }
    };

    public func validateReview(review : Types.Review) : { #ok; #err : Text } {
        if (Text.size(review.content) < 10) {
            #err("Review content too short")
        } else if (Text.size(review.content) > 1000) {
            #err("Review content too long")
        } else if (review.rating < 1 or review.rating > 5) {
            #err("Invalid rating")
        } else {
            #ok
        }
    };

    // Helper Functions
    private func hasUpperCase(text : Text) : Bool {
        Text.contains(text, #char 'A') or
        Text.contains(text, #char 'B') or
        Text.contains(text, #char 'C') or
        Text.contains(text, #char 'D') or
        Text.contains(text, #char 'E') or
        Text.contains(text, #char 'F') or
        Text.contains(text, #char 'G') or
        Text.contains(text, #char 'H') or
        Text.contains(text, #char 'I') or
        Text.contains(text, #char 'J') or
        Text.contains(text, #char 'K') or
        Text.contains(text, #char 'L') or
        Text.contains(text, #char 'M') or
        Text.contains(text, #char 'N') or
        Text.contains(text, #char 'O') or
        Text.contains(text, #char 'P') or
        Text.contains(text, #char 'Q') or
        Text.contains(text, #char 'R') or
        Text.contains(text, #char 'S') or
        Text.contains(text, #char 'T') or
        Text.contains(text, #char 'U') or
        Text.contains(text, #char 'V') or
        Text.contains(text, #char 'W') or
        Text.contains(text, #char 'X') or
        Text.contains(text, #char 'Y') or
        Text.contains(text, #char 'Z')
    };

    private func hasLowerCase(text : Text) : Bool {
        Text.contains(text, #char 'a') or
        Text.contains(text, #char 'b') or
        Text.contains(text, #char 'c') or
        Text.contains(text, #char 'd') or
        Text.contains(text, #char 'e') or
        Text.contains(text, #char 'f') or
        Text.contains(text, #char 'g') or
        Text.contains(text, #char 'h') or
        Text.contains(text, #char 'i') or
        Text.contains(text, #char 'j') or
        Text.contains(text, #char 'k') or
        Text.contains(text, #char 'l') or
        Text.contains(text, #char 'm') or
        Text.contains(text, #char 'n') or
        Text.contains(text, #char 'o') or
        Text.contains(text, #char 'p') or
        Text.contains(text, #char 'q') or
        Text.contains(text, #char 'r') or
        Text.contains(text, #char 's') or
        Text.contains(text, #char 't') or
        Text.contains(text, #char 'u') or
        Text.contains(text, #char 'v') or
        Text.contains(text, #char 'w') or
        Text.contains(text, #char 'x') or
        Text.contains(text, #char 'y') or
        Text.contains(text, #char 'z')
    };

    private func hasNumber(text : Text) : Bool {
        Text.contains(text, #char '0') or
        Text.contains(text, #char '1') or
        Text.contains(text, #char '2') or
        Text.contains(text, #char '3') or
        Text.contains(text, #char '4') or
        Text.contains(text, #char '5') or
        Text.contains(text, #char '6') or
        Text.contains(text, #char '7') or
        Text.contains(text, #char '8') or
        Text.contains(text, #char '9')
    };

    private func hasSpecialChar(text : Text) : Bool {
        Text.contains(text, #char '!') or
        Text.contains(text, #char '@') or
        Text.contains(text, #char '#') or
        Text.contains(text, #char '$') or
        Text.contains(text, #char '%') or
        Text.contains(text, #char '^') or
        Text.contains(text, #char '&') or
        Text.contains(text, #char '*') or
        Text.contains(text, #char '(') or
        Text.contains(text, #char ')') or
        Text.contains(text, #char '-') or
        Text.contains(text, #char '_') or
        Text.contains(text, #char '+') or
        Text.contains(text, #char '=') or
        Text.contains(text, #char '{') or
        Text.contains(text, #char '}') or
        Text.contains(text, #char '[') or
        Text.contains(text, #char ']') or
        Text.contains(text, #char '|') or
        Text.contains(text, #char '\\') or
        Text.contains(text, #char ':') or
        Text.contains(text, #char ';') or
        Text.contains(text, #char '"') or
        Text.contains(text, #char ''') or
        Text.contains(text, #char '<') or
        Text.contains(text, #char '>') or
        Text.contains(text, #char ',') or
        Text.contains(text, #char '.') or
        Text.contains(text, #char '?') or
        Text.contains(text, #char '/')
    };
}; 