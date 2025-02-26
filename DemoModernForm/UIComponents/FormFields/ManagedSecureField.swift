//
//  ManagedSecureField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI

// 4. Managed Secure Field - for password input
struct ManagedSecureField: View {
    let id: String
    let label: String
    let placeholder: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool
    let contentType: UITextContentType?

    @State private var text: String = ""

    init(
        id: String,
        label: String,
        placeholder: String = "",
        formManager: FormManager,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        contentType: UITextContentType? = nil
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.contentType = contentType

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
                SecureField(placeholder, text: $text)
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
    ManagedSecureField(
        id: "ManagedSecureField",
        label: "ManagedSecureField",
        formManager: FormManager()
    )
}
