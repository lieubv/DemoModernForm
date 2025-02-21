//
//  UserProfileForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

struct UserProfileForm: View {
    // Form state
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var bio = ""
    @State private var isNotificationsEnabled = false

    // Field validation status
    @State private var showValidationMessages = false

    var body: some View {
        ReusableForm(
            title: "User Profile",
            onSubmit: submitForm
        ) {
            // First Name field
            TextFormField(
                id: "firstName",
                label: "First Name",
                placeholder: "Enter your first name",
                text: $firstName,
                isRequired: true,
                validationRules: [.minLength(2)]
            ).makeInputView()

            // Last Name field
            TextFormField(
                id: "lastName",
                label: "Last Name",
                placeholder: "Enter your last name",
                text: $lastName,
                isRequired: true,
                validationRules: [.minLength(2)]
            ).makeInputView()

            // Email field with validation
            TextFormField(
                id: "email",
                label: "Email Address",
                placeholder: "you@example.com",
                text: $email,
                isRequired: true,
                validationRules: [.email()]
            ).makeInputView()

            // Phone number with regex validation
            TextFormField(
                id: "phone",
                label: "Phone Number",
                placeholder: "(123) 456-7890",
                text: $phone,
                validationRules: [
                    .matchesRegex("^\\(\\d{3}\\) \\d{3}-\\d{4}$", message: "Please enter a valid phone number")
                ]
            ).makeInputView()

            // Notifications toggle
            Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                .padding(.vertical, 8)

            // Bio text editor
            VStack(alignment: .leading) {
                Text("Bio")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextEditor(text: $bio)
                    .frame(height: 100)
                    .padding(4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Edit Profile")
        .alert(isPresented: $showValidationMessages) {
            Alert(
                title: Text("Validation Error"),
                message: Text("Please fix the errors in the form before submitting."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func submitForm() {
        // Validate all fields
        let isFirstNameValid = !firstName.isEmpty && firstName.count >= 2
        let isLastNameValid = !lastName.isEmpty && lastName.count >= 2
        let isEmailValid = !email.isEmpty && isValidEmail(email)

        let isFormValid = isFirstNameValid && isLastNameValid && isEmailValid
        // Note: phone is optional so we don't check it here

        if isFormValid {
            // Handle successful form submission
            print("Form submitted successfully:")
            print("Name: \(firstName) \(lastName)")
            print("Email: \(email)")
            print("Phone: \(phone)")
            print("Bio: \(bio)")
            print("Notifications enabled: \(isNotificationsEnabled)")

            // Here you would typically save the data or call an API
        } else {
            showValidationMessages = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// Preview provider
struct UserProfileForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileForm()
        }
    }
}
