//
//  UserFormView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct UserForm: FormData {
    var name: String = ""
    var email: String = ""

    static var requiredFields: [String] {
        return ["name", "email"]
    }
}

// Create a form view
struct UserFormView: View {
    @StateObject private var formManager = TypeSafeFormManager(initialData: UserForm())

    var body: some View {
        Form {
            // Register fields in onAppear
            TypeSafeTextField(
                keyPath: \.name,
                label: "Name",
                placeholder: "Enter your name",
                formManager: formManager,
                isRequired: true
            )
            .onAppear {
                formManager.registerField(\.name, fieldName: "name")
            }

            TypeSafeTextField(
                keyPath: \.email,
                label: "Email",
                placeholder: "Enter your email",
                formManager: formManager,
                isRequired: true
            )
            .onAppear {
                formManager.registerField(\.email, fieldName: "email")
            }

            Button("Submit") {
                formManager.validateForm()
                if formManager.isValid {
                    print("Form is valid: \(formManager.formData)")
                }
            }
        }
    }
}
