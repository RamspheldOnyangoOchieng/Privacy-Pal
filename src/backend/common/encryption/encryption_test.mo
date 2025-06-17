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
import Blob "mo:base/Blob";

import Encryption "../encryption/encryption";

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

    func assertEqual<T>(a : T, b : T, equal : (T, T) -> Bool, message : Text) {
        if (not equal(a, b)) {
            Debug.trap(message)
        }
    };

    public func runTests() {
        testKeyGeneration();
        testEncryptionDecryption();
        testTextConversion();
        testHashing();
        testSecureId();
    };

    func testKeyGeneration() {
        let key = await Encryption.generateKey();
        
        // Test key structure
        assertTrue(Array.size(key.key) == 32, "Key size should be 32 bytes");
        assertTrue(Array.size(key.iv) == 12, "IV size should be 12 bytes");
        assertTrue(key.createdAt > 0, "Created timestamp should be positive");
        assertTrue(Option.isSome(key.expiresAt), "Expiration should be set");
        
        // Test key expiration
        let expiresAt = Option.unwrap(key.expiresAt);
        assertTrue(expiresAt > key.createdAt, "Expiration should be after creation");
    };

    func testEncryptionDecryption() {
        let key = await Encryption.generateKey();
        let originalData = Encryption.textToBytes("Hello, World!");
        
        // Test encryption
        let encrypted = await Encryption.encrypt(originalData, key);
        assertTrue(Array.size(encrypted.ciphertext) > 0, "Ciphertext should not be empty");
        assertTrue(Array.size(encrypted.iv) == 12, "IV size should be 12 bytes");
        assertTrue(Array.size(encrypted.tag) == 16, "Tag size should be 16 bytes");
        
        // Test decryption
        let decrypted = await Encryption.decrypt(encrypted, key);
        assertTrue(decrypted.verified, "Decryption should be verified");
        assertEqual(decrypted.plaintext, originalData, Array.equal, "Decrypted data should match original");
        
        // Test decryption with wrong key
        let wrongKey = await Encryption.generateKey();
        let wrongDecrypted = await Encryption.decrypt(encrypted, wrongKey);
        assertFalse(wrongDecrypted.verified, "Decryption with wrong key should fail");
    };

    func testTextConversion() {
        let originalText = "Hello, World!";
        
        // Test text to bytes conversion
        let bytes = Encryption.textToBytes(originalText);
        assertTrue(Array.size(bytes) > 0, "Bytes should not be empty");
        
        // Test bytes to text conversion
        let convertedText = Encryption.bytesToText(bytes);
        assertEqual(convertedText, originalText, Text.equal, "Converted text should match original");
    };

    func testHashing() {
        let data = Encryption.textToBytes("Hello, World!");
        
        // Test SHA-256 hashing
        let hash = await Encryption.sha256(data);
        assertTrue(Array.size(hash) == 32, "Hash size should be 32 bytes");
        
        // Test hash consistency
        let hash2 = await Encryption.sha256(data);
        assertEqual(hash, hash2, Array.equal, "Hash should be consistent");
        
        // Test hash uniqueness
        let differentData = Encryption.textToBytes("Different data");
        let differentHash = await Encryption.sha256(differentData);
        assertFalse(Array.equal(hash, differentHash, Nat8.equal), "Different data should produce different hash");
    };

    func testSecureId() {
        // Test secure ID generation
        let id1 = await Encryption.generateSecureId();
        let id2 = await Encryption.generateSecureId();
        
        assertTrue(Text.size(id1) > 0, "Secure ID should not be empty");
        assertFalse(Text.equal(id1, id2), "Secure IDs should be unique");
    };
}; 