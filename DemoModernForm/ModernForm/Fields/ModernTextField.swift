//
//  ModernTextField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct ModernTextField<T: FormData>: View {
    // MARK: - Properties
    /// KeyPath to string field in form data
    let keyPath: WritableKeyPath<T, String>

    /// Field label
    let label: String

    /// Placeholder text
    let placeholder: String

    /// Form manager instance
    @ObservedObject var formManager: ModernFormManager<T>

    /// Whether the field is required
    let isRequired: Bool

    // UI properties
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    let autocapitalization: TextInputAutocapitalization

    // MARK: - Initialization
    init(
        keyPath: WritableKeyPath<T, String>,
        label: String,
        placeholder: String = "",
        formManager: ModernFormManager<T>,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.keyPath = keyPath
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.autocapitalization = autocapitalization

        // Register field with form manager if not already registered
        let keyPathString = String(describing: keyPath)
        if formManager.keyPathToFieldName[keyPathString] == nil {
            let fieldName = formManager.generateFieldName(from: keyPathString)
            formManager.registerField(keyPath, fieldName: fieldName)
        }

        // Register validator
        if let fieldId = formManager.getFieldName(for: keyPath) {
            formManager.registerValidator(id: fieldId) { (value: String) -> String? in
                if isRequired && value.isEmpty {
                    return "This field is required"
                }

                for rule in validationRules {
                    if !rule.validate(value) {
                        return rule.errorMessage
                    }
                }

                return nil
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ModernFormField(
            keyPath: keyPath,
            formManager: formManager,
            isRequired: isRequired,
            label: {
                HStack {
                    Text(label)
                    if isRequired {
                        Text("*")
                            .foregroundColor(.red)
                    }
                }
            },
            input: { binding in
                TextField(placeholder, text: binding)
                    .textInputAutocapitalization(autocapitalization)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
            }
        )
    }
}
