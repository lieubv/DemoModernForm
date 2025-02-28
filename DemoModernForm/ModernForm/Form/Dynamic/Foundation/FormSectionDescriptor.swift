//
//  FormSectionDescriptor.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Form Section Descriptor
/// Mô tả một section trong form
struct FormSectionDescriptor: Identifiable {
    let id: String
    let title: String
    var fields: [FormFieldDescriptor]
    var isOptional: Bool = false

    mutating func addField(_ field: FormFieldDescriptor) {
        fields.append(field)
    }

    mutating func removeField(withId id: String) {
        fields.removeAll { $0.id == id }
    }
}
