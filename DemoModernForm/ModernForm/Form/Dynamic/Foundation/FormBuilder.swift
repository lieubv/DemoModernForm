//
//  FormBuilder.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Form Builder Helper
/// Builder để tạo form một cách rõ ràng, dễ đọc
class FormBuilder {
    private var sections: [FormSectionDescriptor] = []
    private var currentSectionId: String?

    /// Tạo một section mới
    func section(id: String, title: String) -> FormBuilder {
        currentSectionId = id
        sections.append(FormSectionDescriptor(id: id, title: title, fields: []))
        return self
    }

    /// Thêm field vào section hiện tại
    func field(id: String, label: String, type: FormFieldDescriptor.FormFieldType, isRequired: Bool = false, validationRules: [ValidationRule] = []) -> FormBuilder {
        guard let sectionId = currentSectionId,
              let index = sections.firstIndex(where: { $0.id == sectionId }) else {
            return self
        }

        let field = FormFieldDescriptor(
            id: id,
            label: label,
            type: type,
            isRequired: isRequired,
            validationRules: validationRules
        )

        sections[index].fields.append(field)
        return self
    }

    /// Tạo DynamicFormManager với các section đã định nghĩa
    func build() -> DynamicFormManager {
        let manager = DynamicFormManager()
        for section in sections {
            manager.addSection(section)
        }
        return manager
    }
}
