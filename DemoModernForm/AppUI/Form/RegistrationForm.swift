//
//  RegistrationForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import SwiftUI

struct RegistrationForm: View {
    var body: some View {
        ManagedForm(
            title: "Create Account",
            onSubmit: { data in
                // Handle form submission with validated data
                print("Form submitted with data:")
                data.forEach { key, value in
                    print("\(key): \(value)")
                }

                // In a real app, you would call your registration API here
            }
        ) { formManager in
            // First Name
            ManagedTextField(
                id: "firstName",
                label: "First Name",
                placeholder: "Enter your first name",
                formManager: formManager,
                isRequired: true,
                validationRules: [.minLength(2)]
            )

            // Last Name
            ManagedTextField(
                id: "lastName",
                label: "Last Name",
                placeholder: "Enter your last name",
                formManager: formManager,
                isRequired: true,
                validationRules: [.minLength(2)]
            )

            // Email - with email keyboard and content type
            ManagedTextField(
                id: "email",
                label: "Email Address",
                placeholder: "you@example.com",
                formManager: formManager,
                isRequired: true,
                validationRules: [.email()],
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                autocapitalization: .never
            )

            // Phone Number - with phone keyboard
            ManagedTextField(
                id: "phone",
                label: "Phone Number",
                placeholder: "(123) 456-7890",
                formManager: formManager,
                validationRules: [
                    .matchesRegex(
                        "^\\(\\d{3}\\) \\d{3}-\\d{4}$",
                        message: "Enter a valid phone number: (XXX) XXX-XXXX"
                    )
                ],
                keyboardType: .phonePad,
                contentType: .telephoneNumber
            )

            // Password with strength validation
            ManagedSecureField(
                id: "password",
                label: "Password",
                placeholder: "Create a strong password",
                formManager: formManager,
                isRequired: true,
                validationRules: [
                    .minLength(8),
                    .containsUppercase(),
                    .containsDigit()
                ],
                contentType: .newPassword
            )

            // Confirm Password
            ManagedSecureField(
                id: "confirmPassword",
                label: "Confirm Password",
                placeholder: "Confirm your password",
                formManager: formManager,
                isRequired: true,
                validationRules: [
                    ValidationRule(
                        validate: { value in
                            guard let confirmPassword = value as? String,
                                  let password = formManager.fields["password"] as? String else {
                                return false
                            }
                            return confirmPassword == password
                        },
                        errorMessage: "Passwords do not match"
                    )
                ],
                contentType: .newPassword
            )

            // Terms and Conditions Agreement
            VStack(alignment: .leading, spacing: 4) {
                Toggle(isOn: Binding<Bool>(
                    get: {
                        formManager.fields["termsAgreed"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "termsAgreed", value: newValue)
                    }
                )) {
                    Text("I agree to the Terms and Conditions")
                        .font(.caption)
                }
                .onAppear {
                    formManager.registerValidator(id: "termsAgreed") { (value: Bool) -> String? in
                        return value ? nil : "You must agree to the terms and conditions"
                    }
                    formManager.updateField(id: "termsAgreed", value: false)
                }

                if let error = formManager.errors["termsAgreed"] {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 4)

            // Marketing preferences
            VStack(alignment: .leading, spacing: 4) {
                Text("Communication Preferences")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Toggle(isOn: Binding<Bool>(
                    get: {
                        formManager.fields["emailMarketing"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "emailMarketing", value: newValue)
                    }
                )) {
                    Text("Email me about product updates")
                        .font(.caption)
                }
                .onAppear {
                    formManager.updateField(id: "emailMarketing", value: false)
                }

                Toggle(isOn: Binding<Bool>(
                    get: {
                        formManager.fields["smsMarketing"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "smsMarketing", value: newValue)
                    }
                )) {
                    Text("Send me SMS notifications")
                        .font(.caption)
                }
                .onAppear {
                    formManager.updateField(id: "smsMarketing", value: false)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Sign Up")
    }
}

// Preview provider
struct RegistrationForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegistrationForm()
        }
    }
}
