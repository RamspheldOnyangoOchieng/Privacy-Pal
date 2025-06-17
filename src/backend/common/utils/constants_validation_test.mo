

module {
    // ===== Test Helper Functions =====

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

    func assertOk(result : Result.Result<(), Text>, message : Text) {
        switch (result) {
            case (#ok) {};
            case (#err(error)) {
                Debug.trap(message # ": " # error)
            }
        }
    };

    func assertErr(result : Result.Result<(), Text>, message : Text) {
        switch (result) {
            case (#ok) {
                Debug.trap(message # ": Expected error but got ok")
            };
            case (#err(_)) {}
        }
    };

    // ===== Test Cases =====

    public func runTests() {
        testSecurityValidation();
        testTextValidation();
    };

    func testSecurityValidation() {
        // Test password validation
        assertOk(ValidationUtils.validatePassword("ValidPass123!"), "Valid password should pass validation");
        assertErr(ValidationUtils.validatePassword(""), "Empty password should fail validation");
        assertErr(ValidationUtils.validatePassword("short"), "Short password should fail validation");

        // Test username validation
        assertOk(ValidationUtils.validateUsername("validuser"), "Valid username should pass validation");
        assertErr(ValidationUtils.validateUsername(""), "Empty username should fail validation");
        assertErr(ValidationUtils.validateUsername("invalid@user"), "Invalid username should fail validation");

        // Test email validation
        assertOk(ValidationUtils.validateEmail("test@example.com"), "Valid email should pass validation");
        assertErr(ValidationUtils.validateEmail(""), "Empty email should fail validation");
        assertErr(ValidationUtils.validateEmail("invalid-email"), "Invalid email should fail validation");

        // Test phone validation
        assertOk(ValidationUtils.validatePhone("+1234567890"), "Valid phone should pass validation");
        assertErr(ValidationUtils.validatePhone(""), "Empty phone should fail validation");
        assertErr(ValidationUtils.validatePhone("invalid-phone"), "Invalid phone should fail validation");

        // Test URL validation
        assertOk(ValidationUtils.validateUrl("https://example.com"), "Valid URL should pass validation");
        assertErr(ValidationUtils.validateUrl(""), "Empty URL should fail validation");
        assertErr(ValidationUtils.validateUrl("invalid-url"), "Invalid URL should fail validation");
    };

    func testTextValidation() {
        // Test text length validation
        assertOk(ValidationUtils.validateText("test", 1, 10), "Text length validation should pass");
        assertErr(ValidationUtils.validateText("", 1, 10), "Empty text should fail validation");
        assertErr(ValidationUtils.validateText("toolongtext", 1, 5), "Text too long should fail validation");

        // Test name validation
        assertOk(ValidationUtils.validateName("John Doe"), "Valid name should pass validation");
        assertErr(ValidationUtils.validateName(""), "Empty name should fail validation");

        // Test description validation
        assertOk(ValidationUtils.validateDescription("A valid description"), "Valid description should pass validation");
        assertErr(ValidationUtils.validateDescription(""), "Empty description should fail validation");

        // Test comment validation
        assertOk(ValidationUtils.validateComment("A valid comment"), "Valid comment should pass validation");
        assertErr(ValidationUtils.validateComment(""), "Empty comment should fail validation");

        // Test title validation
        assertOk(ValidationUtils.validateTitle("A valid title"), "Valid title should pass validation");
        assertErr(ValidationUtils.validateTitle(""), "Empty title should fail validation");

        // Test summary validation
        assertOk(ValidationUtils.validateSummary("A valid summary"), "Valid summary should pass validation");
        assertErr(ValidationUtils.validateSummary(""), "Empty summary should fail validation");
    };
}; 