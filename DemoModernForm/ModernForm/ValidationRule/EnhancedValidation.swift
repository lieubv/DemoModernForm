//
//  EnhancedValidation.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Validation Result
/// Kết quả validation với thông tin thêm về lỗi
struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?

    static let valid = ValidationResult(isValid: true, errorMessage: nil)
    static func invalid(_ message: String) -> ValidationResult {
        return ValidationResult(isValid: false, errorMessage: message)
    }
}

// MARK: - Enhanced Validation Rule
/// Phiên bản nâng cao của ValidationRule
struct EnhancedValidationRule {
    let validate: (Any) -> ValidationResult
    let errorMessage: String

    // Chuyển đổi từ EnhancedValidationRule sang ValidationRule cũ
    func toBasicRule() -> ValidationRule {
        return ValidationRule(
            validate: { value in
                return self.validate(value).isValid
            },
            errorMessage: errorMessage
        )
    }
}

// MARK: - Validation Builder
/// Builder pattern để tạo và kết hợp validation rules
class ValidationBuilder {
    private var rules: [EnhancedValidationRule] = []

    func add(_ rule: EnhancedValidationRule) -> ValidationBuilder {
        rules.append(rule)
        return self
    }

    func add(_ rule: ValidationRule) -> ValidationBuilder {
        let enhancedRule = EnhancedValidationRule(
            validate: { value in
                let isValid = rule.validate(value)
                return isValid ? .valid : .invalid(rule.errorMessage)
            },
            errorMessage: rule.errorMessage
        )
        return add(enhancedRule)
    }

    func required(message: String = "This field is required") -> ValidationBuilder {
        add(EnhancedValidationRule(
            validate: { value in
                switch value {
                case let string as String:
                    return string.isEmpty ? .invalid(message) : .valid
                case let collection as any Collection:
                    return collection.isEmpty ? .invalid(message) : .valid
                case let optional as any OptionalProtocol:
                    return optional.isNil ? .invalid(message) : .valid
                case is NSNull:
                    return .invalid(message)
                case nil:
                    return .invalid(message)
                default:
                    return .valid
                }
            },
            errorMessage: message
        ))
        return self
    }

    func email(message: String = "Please enter a valid email address") -> ValidationBuilder {
        add(ValidationRule.email())
        return self
    }

    func minLength(_ length: Int, message: String? = nil) -> ValidationBuilder {
        add(ValidationRule.minLength(length))
        return self
    }

    func build() -> (Any) -> ValidationResult {
        return { value in
            for rule in self.rules {
                let result = rule.validate(value)
                if !result.isValid {
                    return result
                }
            }
            return .valid
        }
    }

    func buildValidator<T>() -> (T) -> ValidationResult {
        let baseValidator = build()
        return { value in
            return baseValidator(value)
        }
    }
}

// MARK: - Extension để kiểm tra Optional
/// Protocol để kiểm tra optional một cách tổng quát
protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
}

// MARK: - Extensions cho ValidationRule hiện tại
extension ValidationRule {
    /// Kết hợp validation rule với một rule khác
    func and(_ other: ValidationRule) -> ValidationRule {
        return ValidationRule(
            validate: { value in
                return self.validate(value) && other.validate(value)
            },
            errorMessage: self.errorMessage
        )
    }

    /// Sử dụng errorMessage mới nếu validation thất bại
    func withMessage(_ message: String) -> ValidationRule {
        return ValidationRule(
            validate: self.validate,
            errorMessage: message
        )
    }

    /// Tạo rule cho password mạnh hơn
    static func strongPassword(minLength: Int = 8) -> ValidationRule {
        return ValidationRule(
            validate: { value in
                guard let password = value as? String else { return false }

                // Ít nhất 8 ký tự với 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt
                let hasMinLength = password.count >= minLength
                let hasUppercase = password.contains { $0.isUppercase }
                let hasLowercase = password.contains { $0.isLowercase }
                let hasDigit = password.contains { $0.isNumber }
                let hasSpecialChar = password.contains { !$0.isLetter && !$0.isNumber }

                return hasMinLength && hasUppercase && hasLowercase && hasDigit && hasSpecialChar
            },
            errorMessage: "Password must be at least \(minLength) characters with uppercase, lowercase, number, and special character"
        )
    }

    /// Các regex patterns phổ biến
    static func phoneNumber() -> ValidationRule {
        return matchesRegex(
            "^\\(\\d{3}\\) \\d{3}-\\d{4}$",
            message: "Please enter a valid phone number: (XXX) XXX-XXXX"
        )
    }

    static func zipCode() -> ValidationRule {
        return matchesRegex(
            "^\\d{5}(-\\d{4})?$",
            message: "Please enter a valid ZIP code"
        )
    }
}
