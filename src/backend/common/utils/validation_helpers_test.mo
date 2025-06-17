import Time "mo:base/Time";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Array "mo:base/Array";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";

import ValidationHelpers "./validation_helpers";

module {
    func assertTrue(condition : Bool, message : Text) {
        if (not condition) {
            Debug.trap(message)
        }
    };

    func assertFalse(condition : Bool, message : Text) {
        if (condition) {
            Debug.trap(message)
        }
    };

    public func runTests() {
        testBasicValidation();
        testSecurityValidation();
        testFileValidation();
        testDateTimeValidation();
        testNetworkValidation();
        testColorValidation();
    };

    func testBasicValidation() {
        // Test text length validation
        assertTrue(ValidationHelpers.isValidLength("test", 1, 10), "Text length validation should pass");
        assertFalse(ValidationHelpers.isValidLength("", 1, 10), "Empty text should fail validation");
        assertFalse(ValidationHelpers.isValidLength("toolongtext", 1, 5), "Text too long should fail validation");

        // Test range validation
        assertTrue(ValidationHelpers.isInRange(5, 1, 10), "Range validation should pass");
        assertFalse(ValidationHelpers.isInRange(0, 1, 10), "Value below range should fail validation");
        assertFalse(ValidationHelpers.isInRange(11, 1, 10), "Value above range should fail validation");

        // Test alphanumeric validation
        assertTrue(ValidationHelpers.isAlphanumeric("abc123"), "Alphanumeric validation should pass");
        assertFalse(ValidationHelpers.isAlphanumeric("abc 123"), "Text with spaces should fail validation");
        assertFalse(ValidationHelpers.isAlphanumeric("abc@123"), "Text with special characters should fail validation");

        // Test alphabetic validation
        assertTrue(ValidationHelpers.isAlphabetic("abc"), "Alphabetic validation should pass");
        assertFalse(ValidationHelpers.isAlphabetic("abc123"), "Text with numbers should fail validation");
        assertFalse(ValidationHelpers.isAlphabetic("abc "), "Text with spaces should fail validation");

        // Test numeric validation
        assertTrue(ValidationHelpers.isNumeric("123"), "Numeric validation should pass");
        assertFalse(ValidationHelpers.isNumeric("123abc"), "Text with letters should fail validation");
        assertFalse(ValidationHelpers.isNumeric("123 "), "Text with spaces should fail validation");

        // Test whitespace validation
        assertTrue(ValidationHelpers.isWhitespace("   "), "Whitespace validation should pass");
        assertFalse(ValidationHelpers.isWhitespace("abc"), "Text without whitespace should fail validation");
        assertFalse(ValidationHelpers.isWhitespace("abc "), "Text with non-whitespace should fail validation");

        // Test blank validation
        assertTrue(ValidationHelpers.isBlank(""), "Empty text should be blank");
        assertTrue(ValidationHelpers.isBlank("   "), "Text with only whitespace should be blank");
        assertFalse(ValidationHelpers.isBlank("abc"), "Text with content should not be blank");
        assertFalse(ValidationHelpers.isBlank(" abc "), "Text with content and whitespace should not be blank");

        // Test contains validation
        assertTrue(ValidationHelpers.contains("hello world", "world"), "Contains validation should pass");
        assertFalse(ValidationHelpers.contains("hello world", "xyz"), "Text without substring should fail validation");

        // Test starts with validation
        assertTrue(ValidationHelpers.startsWith("hello world", "hello"), "Starts with validation should pass");
        assertFalse(ValidationHelpers.startsWith("hello world", "world"), "Text not starting with prefix should fail validation");

        // Test ends with validation
        assertTrue(ValidationHelpers.endsWith("hello world", "world"), "Ends with validation should pass");
        assertFalse(ValidationHelpers.endsWith("hello world", "hello"), "Text not ending with suffix should fail validation");
    };

    func testSecurityValidation() {
        // Test password complexity validation
        assertTrue(ValidationHelpers.meetsPasswordComplexity("Abc123!"), "Password complexity validation should pass");
        assertFalse(ValidationHelpers.meetsPasswordComplexity("abc123"), "Password without uppercase should fail validation");
        assertFalse(ValidationHelpers.meetsPasswordComplexity("ABC123"), "Password without lowercase should fail validation");
        assertFalse(ValidationHelpers.meetsPasswordComplexity("Abcdef"), "Password without numbers should fail validation");
        assertFalse(ValidationHelpers.meetsPasswordComplexity("Abc123"), "Password without special characters should fail validation");

        // Test password history validation
        let history = ["oldpass1", "oldpass2", "oldpass3"];
        assertTrue(ValidationHelpers.isPasswordInHistory("oldpass1", history), "Password in history should be detected");
        assertFalse(ValidationHelpers.isPasswordInHistory("newpass", history), "Password not in history should not be detected");

        // Test password reset token validation
        let now = Time.now();
        let future = now + 3600_000_000_000; // 1 hour in nanoseconds
        let past = now - 3600_000_000_000; // 1 hour in nanoseconds

        assertFalse(ValidationHelpers.isPasswordResetTokenExpired(future), "Future token should not be expired");
        assertTrue(ValidationHelpers.isPasswordResetTokenExpired(past), "Past token should be expired");

        assertTrue(ValidationHelpers.isPasswordResetTokenUsed(true), "Used token should be detected");
        assertFalse(ValidationHelpers.isPasswordResetTokenUsed(false), "Unused token should not be detected");

        assertTrue(ValidationHelpers.isPasswordResetTokenValid("token", "token"), "Valid token should be detected");
        assertFalse(ValidationHelpers.isPasswordResetTokenValid("token", "different"), "Invalid token should not be detected");
    };

    func testFileValidation() {
        // Test file path validation
        assertTrue(ValidationHelpers.isValidFilePath("/path/to/file.txt"), "Valid file path should pass validation");
        assertTrue(ValidationHelpers.isValidFilePath("file.txt"), "Valid file path should pass validation");

        // Test file name validation
        assertTrue(ValidationHelpers.isValidFileName("file.txt"), "Valid file name should pass validation");
        assertTrue(ValidationHelpers.isValidFileName("file"), "Valid file name should pass validation");

        // Test file extension validation
        assertTrue(ValidationHelpers.isValidFileExtension("txt"), "Valid file extension should pass validation");
        assertTrue(ValidationHelpers.isValidFileExtension("pdf"), "Valid file extension should pass validation");

        // Test MIME type validation
        assertTrue(ValidationHelpers.isValidMimeType("text/plain"), "Valid MIME type should pass validation");
        assertTrue(ValidationHelpers.isValidMimeType("application/pdf"), "Valid MIME type should pass validation");
    };

    func testDateTimeValidation() {
        // Test date string validation
        assertTrue(ValidationHelpers.isValidDateString("2024-03-20"), "Valid date string should pass validation");
        assertTrue(ValidationHelpers.isValidDateString("2024/03/20"), "Valid date string should pass validation");

        // Test time string validation
        assertTrue(ValidationHelpers.isValidTimeString("12:00:00"), "Valid time string should pass validation");
        assertTrue(ValidationHelpers.isValidTimeString("12:00"), "Valid time string should pass validation");

        // Test datetime string validation
        assertTrue(ValidationHelpers.isValidDateTimeString("2024-03-20T12:00:00"), "Valid datetime string should pass validation");
        assertTrue(ValidationHelpers.isValidDateTimeString("2024/03/20 12:00:00"), "Valid datetime string should pass validation");

        // Test timezone string validation
        assertTrue(ValidationHelpers.isValidTimezoneString("UTC"), "Valid timezone string should pass validation");
        assertTrue(ValidationHelpers.isValidTimezoneString("GMT+1"), "Valid timezone string should pass validation");
    };

    func testNetworkValidation() {
        // Test IP address validation
        assertTrue(ValidationHelpers.isValidIPAddress("192.168.1.1"), "Valid IP address should pass validation");
        assertTrue(ValidationHelpers.isValidIPAddress("::1"), "Valid IP address should pass validation");

        // Test MAC address validation
        assertTrue(ValidationHelpers.isValidMACAddress("00:11:22:33:44:55"), "Valid MAC address should pass validation");
        assertTrue(ValidationHelpers.isValidMACAddress("00-11-22-33-44-55"), "Valid MAC address should pass validation");

        // Test domain name validation
        assertTrue(ValidationHelpers.isValidDomainName("example.com"), "Valid domain name should pass validation");
        assertTrue(ValidationHelpers.isValidDomainName("sub.example.com"), "Valid domain name should pass validation");

        // Test hostname validation
        assertTrue(ValidationHelpers.isValidHostname("localhost"), "Valid hostname should pass validation");
        assertTrue(ValidationHelpers.isValidHostname("example.com"), "Valid hostname should pass validation");

        // Test port number validation
        assertTrue(ValidationHelpers.isValidPortNumber(80), "Valid port number should pass validation");
        assertTrue(ValidationHelpers.isValidPortNumber(65535), "Valid port number should pass validation");
        assertFalse(ValidationHelpers.isValidPortNumber(0), "Zero port number should fail validation");
        assertFalse(ValidationHelpers.isValidPortNumber(65536), "Port number too large should fail validation");
    };

    func testColorValidation() {
        // Test color code validation
        assertTrue(ValidationHelpers.isValidColorCode("#FF0000"), "Valid color code should pass validation");
        assertTrue(ValidationHelpers.isValidColorCode("red"), "Valid color code should pass validation");

        // Test hex color code validation
        assertTrue(ValidationHelpers.isValidHexColorCode("#FF0000"), "Valid hex color code should pass validation");
        assertTrue(ValidationHelpers.isValidHexColorCode("#F00"), "Valid hex color code should pass validation");

        // Test RGB color code validation
        assertTrue(ValidationHelpers.isValidRGBColorCode("rgb(255, 0, 0)"), "Valid RGB color code should pass validation");
        assertTrue(ValidationHelpers.isValidRGBColorCode("rgb(100%, 0%, 0%)"), "Valid RGB color code should pass validation");

        // Test RGBA color code validation
        assertTrue(ValidationHelpers.isValidRGBAColorCode("rgba(255, 0, 0, 1)"), "Valid RGBA color code should pass validation");
        assertTrue(ValidationHelpers.isValidRGBAColorCode("rgba(100%, 0%, 0%, 1)"), "Valid RGBA color code should pass validation");

        // Test HSL color code validation
        assertTrue(ValidationHelpers.isValidHSLColorCode("hsl(0, 100%, 50%)"), "Valid HSL color code should pass validation");
        assertTrue(ValidationHelpers.isValidHSLColorCode("hsl(360, 100%, 50%)"), "Valid HSL color code should pass validation");

        // Test HSLA color code validation
        assertTrue(ValidationHelpers.isValidHSLAColorCode("hsla(0, 100%, 50%, 1)"), "Valid HSLA color code should pass validation");
        assertTrue(ValidationHelpers.isValidHSLAColorCode("hsla(360, 100%, 50%, 1)"), "Valid HSLA color code should pass validation");
    };
}; 