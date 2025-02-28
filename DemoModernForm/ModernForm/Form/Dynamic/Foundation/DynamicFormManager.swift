//
//  DynamicFormManager.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Dynamic Form Manager
/// Manager cho form với các section có thể thay đổi động
class DynamicFormManager: ObservableObject {
    @Published var sections: [FormSectionDescriptor] = []
    @Published var values: [String: Any] = [:]
    @Published var errors: [String: String] = [:]
    @Published var isValid = false
    @Published var isSubmitting = false

    private var validators: [String: (Any) -> String?] = [:]

    /// Thêm một section mới
    func addSection(_ section: FormSectionDescriptor) {
        sections.append(section)
    }

    /// Xóa một section
    func removeSection(withId id: String) {
        sections.removeAll { $0.id == id }

        // Xóa các giá trị và lỗi của các field trong section
        for section in sections.filter({ $0.id == id }) {
            for field in section.fields {
                values.removeValue(forKey: field.id)
                errors.removeValue(forKey: field.id)
                validators.removeValue(forKey: field.id)
            }
        }

        validateForm()
    }

    /// Thêm field vào section
    func addField(_ field: FormFieldDescriptor, toSectionWithId sectionId: String) {
        guard let index = sections.firstIndex(where: { $0.id == sectionId }) else { return }
        sections[index].addField(field)
    }

    /// Xóa field khỏi section
    func removeField(withId fieldId: String, fromSectionWithId sectionId: String) {
        guard let index = sections.firstIndex(where: { $0.id == sectionId }) else { return }
        sections[index].removeField(withId: fieldId)

        // Xóa giá trị và lỗi của field
        values.removeValue(forKey: fieldId)
        errors.removeValue(forKey: fieldId)
        validators.removeValue(forKey: fieldId)

        validateForm()
    }

    /// Cập nhật giá trị của field
    func updateField(id: String, value: Any) {
        values[id] = value
        validateField(id: id)
        validateForm()
    }

    /// Đăng ký validator cho field
    func registerValidator<T>(id: String, validator: @escaping (T) -> String?) {
        validators[id] = { value in
            guard let typedValue = value as? T else {
                return "Invalid type"
            }
            return validator(typedValue)
        }
    }

    /// Validate một field cụ thể
    func validateField(id: String) {
        guard let validator = validators[id],
              let value = values[id] else {
            return
        }

        if let errorMessage = validator(value) {
            errors[id] = errorMessage
        } else {
            errors.removeValue(forKey: id)
        }
    }

    /// Validate toàn bộ form
    func validateForm() {
        for section in sections {
            for field in section.fields {
                if field.isRequired && (values[field.id] == nil || isEmptyValue(values[field.id])) {
                    errors[field.id] = "This field is required"
                    continue
                }

                validateField(id: field.id)
            }
        }

        isValid = errors.isEmpty
    }

    /// Kiểm tra giá trị rỗng
    private func isEmptyValue(_ value: Any?) -> Bool {
        guard let value = value else { return true }

        switch value {
        case let string as String:
            return string.isEmpty
        case let array as [Any]:
            return array.isEmpty
        case let dict as [AnyHashable: Any]:
            return dict.isEmpty
        case let set as Set<AnyHashable>:
            return set.isEmpty
        default:
            return false
        }
    }

    /// Submit form
    func submitForm(onSuccess: @escaping ([String: Any]) -> Void) {
        validateForm()

        guard isValid else { return }

        isSubmitting = true

        // Giả lập delay mạng
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 giây

            onSuccess(self.values)
            isSubmitting = false
        }
    }
}
