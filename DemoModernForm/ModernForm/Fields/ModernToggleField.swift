//
//  ModernToggleField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 7/3/25.
//

import SwiftUI

struct ModernToggleField<T: FormData>: View {
    // MARK: - Properties

    /// KeyPath to boolean field in form data
    let keyPath: WritableKeyPath<T, Bool>

    /// Field label
    let label: String

    /// Form manager instance
    @ObservedObject var formManager: ModernFormManager<T>

    /// Whether the field is required
    let isRequired: Bool

    /// Additional description text
    let description: String?

    // MARK: - Initialization
    init(
        formManager: ModernFormManager<T>,
        keyPath: WritableKeyPath<T, Bool>,
        label: String,
        isRequired: Bool = false,
        description: String? = nil
    ) {
        self.keyPath = keyPath
        self.label = label
        self.formManager = formManager
        self.isRequired = isRequired
        self.description = description

        // Register field with form manager if not already registered
        let keyPathString = String(describing: keyPath)
        if formManager.keyPathToFieldName[keyPathString] == nil {
            let fieldName = formManager.generateFieldName(from: keyPathString)
            formManager.registerField(keyPath, fieldName: fieldName)
        }

        // Register validator
        if let fieldId = formManager.getFieldName(for: keyPath) {
            formManager.registerValidator(id: fieldId) { (value: Bool) -> String? in
                if isRequired && !value {
                    return "This field is required"
                }
                return nil
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ModernFormField(
            formManager: formManager,
            keyPath: keyPath,
            isRequired: isRequired,
            label: {
                EmptyView()
            },
            input: { binding in
                Toggle(isOn: binding) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(label)
                                .font(.subheadline)
                            if isRequired {
                                Text("*")
                                    .foregroundColor(.red)
                            }
                        }
                        if let description = description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        )
    }
}

// MARK: - Preview
struct ModernToggleField_Previews: PreviewProvider {
    struct TestData: FormData {
        var isEnabled: Bool = false
        var acceptTerms: Bool = false
        static var requiredFields: [String] { [] }
    }

    static var previews: some View {
        Form {
            ModernToggleField(
                formManager: ModernFormManager(initialData: TestData()),
                keyPath: \TestData.isEnabled,
                label: "Enable Feature",
                description: "Turn this on to enable the feature"
            )

            ModernToggleField(
                formManager: ModernFormManager(initialData: TestData()),
                keyPath: \TestData.acceptTerms,
                label: "Accept Terms & Conditions",
                isRequired: true,
                description: "You must accept the terms to continue"
            )
        }
    }
}
