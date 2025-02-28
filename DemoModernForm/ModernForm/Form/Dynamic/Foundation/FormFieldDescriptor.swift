//
//  FormFieldDescriptor.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import Foundation

// MARK: - Form Field Descriptor
/// Mô tả một field trong form
struct FormFieldDescriptor: Identifiable {
    let id: String
    let label: String
    let type: FormFieldType
    let isRequired: Bool
    let validationRules: [ValidationRule]

    enum FormFieldType {
        case text
        case secure
        case toggle
        case picker(options: [AnyHashable])
        case multiPicker(options: [AnyHashable])
        case date
        case custom
    }
}
