

module {
    public type ValidationError = {
        code: Nat;
        message: Text;
    };

    public func validateTextLength(text: Text, minLength: Nat, maxLength: Nat) : Result.Result<Text, ValidationError> {
        let length = Text.size(text);
        if (length < minLength) {
            #Err({
                code = 400;
                message = "Text is too short. Minimum length is " # Nat.toText(minLength);
            })
        } else if (length > maxLength) {
            #Err({
                code = 400;
                message = "Text is too long. Maximum length is " # Nat.toText(maxLength);
            })
        } else {
            #Ok(text)
        }
    };

    public func validateArrayLength<T>(array: [T], minLength: Nat, maxLength: Nat) : Result.Result<[T], ValidationError> {
        let length = Array.size(array);
        if (length < minLength) {
            #Err({
                code = 400;
                message = "Array is too short. Minimum length is " # Nat.toText(minLength);
            })
        } else if (length > maxLength) {
            #Err({
                code = 400;
                message = "Array is too long. Maximum length is " # Nat.toText(maxLength);
            })
        } else {
            #Ok(array)
        }
    };

    public func validateEmail(email: Text) : Result.Result<Text, ValidationError> {
        // Basic email validation
        if (Text.contains(email, #text "@") and Text.contains(email, #text ".")) {
            #Ok(email)
        } else {
            #Err({
                code = 400;
                message = "Invalid email format";
            })
        }
    };
}; 