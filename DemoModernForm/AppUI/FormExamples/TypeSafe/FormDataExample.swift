//
//  FormDataExample.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Struct cho dữ liệu cá nhân (Section 1)
struct PersonalInfo: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
}

// MARK: - Struct cho thông tin bổ sung (Section 2)
struct AdditionalInfo: Codable {
    var isSubscribed: Bool = false
    var favoriteColor: FavoriteColor?
    var skills: Set<Skill> = []
    var availableDays: Set<DayOfWeek> = []
}

// MARK: - Struct cho form đăng ký tổng hợp
struct RegistrationFormData: FormData {
    var personalInfo: PersonalInfo = PersonalInfo()
    var additionalInfo: AdditionalInfo = AdditionalInfo()
    var acceptTerms: Bool = false

    // Các trường bắt buộc trong form
    static var requiredFields: [String] {
        return [
            "personalInfo.firstName",
            "personalInfo.lastName",
            "personalInfo.email",
            "acceptTerms"
        ]
    }
}

// MARK: - Form Section Protocol để quản lý section
protocol FormSection {
    associatedtype SectionData
    var title: String { get }
    var data: SectionData { get }

    // Thêm các phương thức hữu ích cho section
    func validate() -> Bool
    func getErrorMessages() -> [String]
}

// MARK: - Personal Info Section
struct PersonalInfoSection: FormSection {
    let title: String = "Personal Information"
    var data: PersonalInfo

    func validate() -> Bool {
        let isFirstNameValid = !data.firstName.isEmpty && data.firstName.count >= 2
        let isLastNameValid = !data.lastName.isEmpty && data.lastName.count >= 2
        let isEmailValid = ValidationRule.email().validate(data.email)

        return isFirstNameValid && isLastNameValid && isEmailValid
    }

    func getErrorMessages() -> [String] {
        var errors: [String] = []

        if data.firstName.isEmpty || data.firstName.count < 2 {
            errors.append("First name must be at least 2 characters")
        }

        if data.lastName.isEmpty || data.lastName.count < 2 {
            errors.append("Last name must be at least 2 characters")
        }

        if !ValidationRule.email().validate(data.email) {
            errors.append("Please enter a valid email address")
        }

        return errors
    }
}

// MARK: - Additional Info Section
struct AdditionalInfoSection: FormSection {
    let title: String = "Additional Information"
    var data: AdditionalInfo

    func validate() -> Bool {
        // Mọi trường trong section này đều là tùy chọn
        return true
    }

    func getErrorMessages() -> [String] {
        return []
    }
}

// MARK: - Dynamic Field Collection Helper
class FormSectionCollection<T: FormSection> {
    private var sections: [T] = []

    func addSection(_ section: T) {
        sections.append(section)
    }

    func removeSection(at index: Int) {
        guard index < sections.count else { return }
        sections.remove(at: index)
    }

    func section(at index: Int) -> T? {
        guard index < sections.count else { return nil }
        return sections[index]
    }

    var count: Int {
        return sections.count
    }

    func validateAll() -> Bool {
        return sections.allSatisfy { $0.validate() }
    }

    func getAllErrors() -> [String] {
        return sections.flatMap { $0.getErrorMessages() }
    }
}
