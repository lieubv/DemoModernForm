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
    
    var birthDate: Date = Date()
    var skills: [Skill] = []
    var jobPosition: JobPosition = .developer

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

struct UserFormView: View {
    @StateObject private var formManager = ModernFormManager(initialData: UserForm())
    
    @ObservedObject private var dataManager = UserDataManager.shared
    
    @State private var showingSavedConfirmation = false

    var body: some View {
        NavigationView {
            ModernFormContainer(
                title: "User info",
                formManager: formManager
            ) { data in
                self.dataManager.addSubmission(formData: data)
                print("Form data saved successfully!")
            }
        }
        .onAppear {
            setupForm()
        }
    }

    // MARK: - Setup form
    private func setupForm() {
        personalSection()
        additionalInfoSection()
//        securitySection()
        termSection()
    }

    // MARK: - Setup form's sections
    private func personalSection() {
        var personalSection = ModernSection<UserForm>(
            id: "personal",
            title: "Personal Information",
            description: "Basic information about you"
        )

        personalSection.setContent { formManager in
            VStack {
                ModernTextField(
                    formManager: formManager,
                    keyPath: \.firstName,
                    label: "First name",
                    placeholder: "Your name",
                    isRequired: true,
                    validationRules: [.minLength(2)],
                    contentType: .givenName
                )

                ModernTextField(
                    formManager: formManager,
                    keyPath: \.lastName,
                    label: "Last name",
                    placeholder: "Your last name",
                    isRequired: true,
                    validationRules: [.minLength(2)],
                    contentType: .familyName
                )

                ModernTextField(
                    formManager: formManager,
                    keyPath: \.phoneNumber,
                    label: "Phone number",
                    placeholder: "Enter your phone number",
                    isRequired: true,
                    validationRules: [.vietnamesePhoneNumber()],
                    keyboardType: .phonePad,
                    contentType: .telephoneNumber
                )

                ModernTextField(
                    formManager: formManager,
                    keyPath: \.email,
                    label: "Email",
                    placeholder: "Enter your email",
                    isRequired: true,
                    validationRules: [.email()],
                    keyboardType: .emailAddress,
                    contentType: .emailAddress
                )
            }
        }

        formManager.addSection(personalSection)
    }
    
    private func additionalInfoSection() {
        var infoSection = ModernSection<UserForm>(
            id: "additional",
            title: "Additional Information",
            description: "More details about you"
        )
        
        infoSection.setContent { formManager in
            VStack {
                DatePickerField(
                    formManager: formManager,
                    keyPath: \.birthDate,
                    label: "Date of Birth",
                    isRequired: false,
                    displayMode: .date,
                    minDate: Calendar.current.date(byAdding: .year, value: -100, to: Date()),
                    maxDate: Calendar.current.date(byAdding: .year, value: -18, to: Date())
                )
                
                MultiPickerField(
                    formManager: formManager,
                    keyPath: \.skills,
                    label: "Skills",
                    options: Skill.allSkills,
                    minSelections: 1,
                    maxSelections: 3
                ) { skill in
                    skill.name
                }
                
                SinglePickerField(
                    formManager: formManager,
                    keyPath: \.jobPosition,
                    label: "Job Position"
                ) { color in
                    color.displayName
                }
            }
        }
        
        formManager.addSection(infoSection)
    }

    private func securitySection() {
        var securitySection = ModernSection<UserForm>(
            id: "security",
            title: "Security"
        )

        securitySection.setContent { formManager in
            VStack {
                SecureTextField(
                    formManager: formManager,
                    keyPath: \.password,
                    label: "Password",
                    placeholder: "Create a password",
                    isRequired: true,
                    validationRules: [.minLength(8)]
                )

                SecureTextField(
                    formManager: formManager,
                    keyPath: \.confirmPassword,
                    label: "Confirm Password",
                    placeholder: "Enter your password again",
                    isRequired: true
                )
            }
        }

        formManager.addSection(securitySection)
    }

    private func termSection() {
        var termSection = ModernSection<UserForm>(
            id: "tern",
            title: "Terms & conditions"
        )

        termSection.setContent { formManager in
            ModernToggleField(
                formManager: formManager,
                keyPath: \.acceptTerms,
                label: "Accept Terms & Conditions",
                isRequired: true,
                description: "You must accept the terms to continue"
            )
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
