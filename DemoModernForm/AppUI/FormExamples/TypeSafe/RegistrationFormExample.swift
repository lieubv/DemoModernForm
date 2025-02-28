//
//  RegistrationFormExample.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct RegistrationData: FormData {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var acceptTerms: Bool = false

    static var requiredFields: [String] {
        return ["firstName", "lastName", "email", "password", "acceptTerms"]
    }
}

struct RegistrationFormExample: View {
    var body: some View {
        TypeSafeForm(
            title: "Create Account",
            initialData: RegistrationData(),
            onSubmit: { data in
                print("Form submitted with data:")
                print("Name: \(data.firstName) \(data.lastName)")
                print("Email: \(data.email)")
            }
        ) { formManager in
            // First Name
            TypeSafeTextField(
                keyPath: \.firstName,
                label: "First Name",
                placeholder: "Enter your first name",
                formManager: formManager,
                isRequired: true,
                validationRules: [.minLength(2)]
            )

            // Last Name
            TypeSafeTextField(
                keyPath: \.lastName,
                label: "Last Name",
                placeholder: "Enter your last name",
                formManager: formManager,
                isRequired: true,
                validationRules: [.minLength(2)]
            )

            // Email
            TypeSafeTextField(
                keyPath: \.email,
                label: "Email Address",
                placeholder: "you@example.com",
                formManager: formManager,
                isRequired: true,
                validationRules: [.email()],
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                autocapitalization: .never
            )

            // Password
            TypeSafeSecureField(
                keyPath: \.password,
                label: "Password",
                placeholder: "Create a password",
                formManager: formManager,
                isRequired: true,
                validationRules: [.minLength(8)]
            )

            // Confirm Password
            TypeSafeSecureField(
                keyPath: \.confirmPassword,
                label: "Confirm Password",
                placeholder: "Enter your password again",
                formManager: formManager,
                isRequired: true
            )
            .onAppear {
                // Special validator for password confirmation
                formManager.registerValidator(for: \.confirmPassword) { value -> String? in
                    if value != formManager.formData.password {
                        return "Passwords do not match"
                    }
                    return nil
                }
            }

            // Terms and Conditions
            TypeSafeFormField(
                keyPath: \.acceptTerms,
                formManager: formManager,
                isRequired: true,
                label: { EmptyView() },
                input: { binding in
                    Toggle(isOn: binding) {
                        Text("I accept the Terms and Conditions")
                            .font(.subheadline)
                    }
                }
            )
            .onAppear {
                formManager.registerValidator(for: \.acceptTerms) { value -> String? in
                    return value ? nil : "You must accept the terms to continue"
                }
            }
        }
        .navigationTitle("Sign Up")
    }
}
