//
//  UserFormView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct UserForm: FormData {
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var acceptTerms: Bool = false

    static var requiredFields: [String] {
        return [
            "firstName",
            "lastName",
            "phoneNumber",
            "email",
            "password",
            "acceptTerms"
        ]
    }
}

// Create a form view
struct UserFormView: View {
    @StateObject private var formManager = TypeSafeFormManager(initialData: UserForm())

    var body: some View {
        NavigationView {
            TypeSafeSectionedForm(
                title: "User info",
                formManager: formManager
            ) { data in
                print(data)
            }
        }
        .onAppear {
            setupForm()
        }
    }

    // MARK: - Setup form
    private func setupForm() {
        personalSection()
        securitySection()
        termSection()
    }

    // MARK: - Setup form's sections
    private func personalSection() {
        var personalSection = FormSection<UserForm>(
            id: "personal",
            title: "Personal Information",
            description: "Basic information about you"
        )

        personalSection.setContent { formManager in
            VStack {
                TypeSafeTextField(
                    keyPath: \.firstName,
                    label: "First name",
                    placeholder: "Your name",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.minLength(2)],
                    contentType: .givenName
                )

                TypeSafeTextField(
                    keyPath: \.lastName,
                    label: "Last name",
                    placeholder: "Your last name",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.minLength(2)],
                    contentType: .familyName
                )

                TypeSafeTextField(
                    keyPath: \.phoneNumber,
                    label: "Phone number",
                    placeholder: "Enter your phone number",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.vietnamesePhoneNumber()],
                    keyboardType: .phonePad,
                    contentType: .telephoneNumber
                )

                TypeSafeTextField(
                    keyPath: \.email,
                    label: "Email",
                    placeholder: "Enter your email",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.email()],
                    keyboardType: .emailAddress,
                    contentType: .emailAddress
                )
            }
        }

        formManager.addSection(personalSection)
    }

    private func securitySection() {
        var securitySection = FormSection<UserForm>(
            id: "security",
            title: "Security"
        )

        securitySection.setContent { formManager in
            VStack {
                TypeSafeSecureField(
                    keyPath: \.password,
                    label: "Password",
                    placeholder: "Create a password",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.minLength(8)]
                )

                TypeSafeSecureField(
                    keyPath: \.confirmPassword,
                    label: "Confirm Password",
                    placeholder: "Enter your password again",
                    formManager: formManager,
                    isRequired: true
                )
            }
        }

        formManager.addSection(securitySection)
    }

    private func termSection() {
        var termSection = FormSection<UserForm>(
            id: "tern",
            title: "Terms & conditions"
        )

        termSection.setContent { formManager in
            VStack {
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
        }

        formManager.addSection(termSection)
    }
}

// Preview provider
struct UserFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserFormView()
        }
    }
}
