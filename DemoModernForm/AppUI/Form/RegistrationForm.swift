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
                                  let password = formManager.fields["password"] as? String
                            else { return false }

                            return confirmPassword == password
                        },
                        errorMessage: "Passwords must match"
                    )
                ],
                contentType: .newPassword
            )

            // Terms of Service agreement
            VStack(alignment: .leading, spacing: 4) {
                Toggle("I agree to the Terms of Service", isOn: Binding(
                    get: {
                        formManager.fields["agreeToTerms"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "agreeToTerms", value: newValue)
                    }
                ))
                .onAppear {
                    // Initialize with false
                    formManager.updateField(id: "agreeToTerms", value: false)

                    // Register validator
                    formManager.registerValidator(id: "agreeToTerms") { (value: Bool) -> String? in
                        return value ? nil : "You must agree to the Terms of Service"
                    }
                }

                if let error = formManager.errors["agreeToTerms"] {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 4)

            // Marketing preferences
            VStack(alignment: .leading, spacing: 4) {
                Text("Marketing Preferences")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Toggle("Receive email updates", isOn: Binding(
                    get: {
                        formManager.fields["emailUpdates"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "emailUpdates", value: newValue)
                    }
                ))
                .onAppear {
                    // Initialize with false
                    formManager.updateField(id: "emailUpdates", value: false)
                }
            }
            .padding(.vertical, 4)

            // Birth date (custom component example)
            VStack(alignment: .leading, spacing: 4) {
                Text("Date of Birth")
                    .font(.caption)
                    .foregroundColor(.secondary)

                DatePicker(
                    "",
                    selection: Binding(
                        get: {
                            (formManager.fields["birthDate"] as? Date) ?? Date()
                        },
                        set: { newValue in
                            formManager.updateField(id: "birthDate", value: newValue)
                        }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .frame(maxHeight: 160)
                .onAppear {
                    // Initialize with current date
                    formManager.updateField(id: "birthDate", value: Date())

                    // Register validator to check age
                    formManager.registerValidator(id: "birthDate") { (value: Date) -> String? in
                        let calendar = Calendar.current
                        let ageComponents = calendar.dateComponents([.year], from: value, to: Date())
                        let age = ageComponents.year ?? 0

                        return age >= 18 ? nil : "You must be at least 18 years old"
                    }
                }

                if let error = formManager.errors["birthDate"] {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Register")
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
