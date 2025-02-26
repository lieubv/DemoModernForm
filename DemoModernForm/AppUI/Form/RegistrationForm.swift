//
//  RegistrationForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
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
                autocapitalization: .none
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
                contentType: .newPassword
            )

            // Confirm Password
            ManagedSecureField(
                id: "confirmPassword",
                label: "Confirm Password",
                placeholder: "Enter your password again",
                formManager: formManager,
                isRequired: true,
                validationRules: []
            )

            // Custom validator for password confirmation
            .onAppear {
                formManager.registerValidator(id: "confirmPassword") { (value: String) -> String? in
                    guard let password = formManager.fields["password"] as? String else {
                        return "Please enter your password first"
                    }

                    if value != password {
                        return "Passwords do not match"
                    }

                    return nil
                }
            }

            // Terms and Conditions acceptance
            VStack(alignment: .leading) {
                Toggle(isOn: Binding(
                    get: {
                        formManager.fields["acceptTerms"] as? Bool ?? false
                    },
                    set: { newValue in
                        formManager.updateField(id: "acceptTerms", value: newValue)
                    }
                )) {
                    Text("I accept the Terms and Conditions")
                        .font(.subheadline)
                }
                .padding(.vertical, 8)

                if let error = formManager.errors["acceptTerms"] {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                formManager.registerValidator(id: "acceptTerms") { (value: Bool) -> String? in
                    return value ? nil : "You must accept the terms to continue"
                }
                formManager.updateField(id: "acceptTerms", value: false)
            }
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

//#Preview {
//    RegistrationForm()
//}
