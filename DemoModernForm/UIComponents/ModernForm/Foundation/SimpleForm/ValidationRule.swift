//
//  ValidationRule.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import Foundation

struct ValidationRule {
    let validate: (Any) -> Bool
    let errorMessage: String
}

extension ValidationRule {
    static func email() -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let email = value as? String else { return false }
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
            },
            errorMessage: "Please enter a valid email address"
        )
    }

    static func minLength(_ length: Int) -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let text = value as? String else { return false }
                return text.count >= length
            },
            errorMessage: "Must be at least \(length) characters"
        )
    }

    static func containsUppercase() -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let text = value as? String else { return false }
                return text.contains { $0.isUppercase }
            },
            errorMessage: "Must contain at least one uppercase letter"
        )
    }

    static func containsDigit() -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let text = value as? String else { return false }
                return text.contains { $0.isNumber }
            },
            errorMessage: "Must contain at least one number"
        )
    }

    static func passwordStrength() -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let password = value as? String else { return false }

                // At least 8 characters with 1 uppercase, 1 lowercase, and 1 digit
                let hasMinLength = password.count >= 8
                let hasUppercase = password.contains { $0.isUppercase }
                let hasLowercase = password.contains { $0.isLowercase }
                let hasDigit = password.contains { $0.isNumber }

                return hasMinLength && hasUppercase && hasLowercase && hasDigit
            },
            errorMessage: "Password must be at least 8 characters with uppercase, lowercase, and number"
        )
    }

    static func matchesRegex(_ pattern: String, message: String) -> ValidationRule {
        ValidationRule(
            validate: { value in
                guard let text = value as? String else { return false }
                let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
                return predicate.evaluate(with: text)
            },
            errorMessage: message
        )
    }
}
