//
//  LoginForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import SwiftUI

/// The form created by using `SimpleForm`
struct LoginForm: View {
    // Form state
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false

    // UI state
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ReusableForm(
            title: "Login",
            onSubmit: handleLogin
        ) {
            // Email field
            TextFormField(
                id: "loginEmail",
                label: "Email",
                placeholder: "Enter your email",
                text: $email,
                isRequired: true,
                validationRules: [.email()]
            ).makeInputView()

            // Password field (custom implementation for secure field)
            VStack(alignment: .leading) {
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.secondary)

                SecureField("Enter your password", text: $password)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                if password.isEmpty {
                    Text("Password is required")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 4)

            // Remember me toggle
            Toggle("Remember me", isOn: $rememberMe)
                .padding(.vertical, 8)

            // Forgot password link
            Button("Forgot Password?") {
                // Handle forgot password action
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.caption)
            .padding(.top, 4)
        }
        .navigationTitle("Sign In")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Login"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleLogin() {
        let isEmailValid = !email.isEmpty && ValidationRule.email().validate(email)
        let isPasswordValid = !password.isEmpty

        if isEmailValid && isPasswordValid {
            // Simulate successful login
            alertMessage = "Login successful!"
            showingAlert = true

            // Here you would typically authenticate with a server
            print("Login attempt with:")
            print("Email: \(email)")
            print("Remember me: \(rememberMe)")
        } else {
            // Show validation errors
            alertMessage = "Please enter a valid email and password."
            showingAlert = true
        }
    }
}

// Preview provider
struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginForm()
        }
    }
}
