//
//  ManagedTextField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI

// 3. Managed Text Field - integrated with form manager
struct ManagedTextField: View {
    let id: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool

    // Các thuộc tính UI
    let label: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    let autocapitalization: UITextAutocapitalizationType

    @State private var text: String = ""

    init(
        id: String,
        label: String,
        placeholder: String = "",
        formManager: FormManager,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil,
        autocapitalization: UITextAutocapitalizationType = .sentences
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.autocapitalization = autocapitalization

        // Register validator
        formManager.registerValidator(id: id) { (value: String) -> String? in
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

    var body: some View {
        ManagedFormField(
            id: id,
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
            input: {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(autocapitalization)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .onChange(of: text) { newValue in
                        formManager.updateField(id: id, value: newValue)
                    }
                    .onAppear {
                        // Initialize with empty string
                        formManager.updateField(id: id, value: text)
                    }
            }
        )
    }
}

#Preview {
    ManagedTextField(id: "", label: "", formManager: FormManager())
}
