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

// 6. Common Validation Rules
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
