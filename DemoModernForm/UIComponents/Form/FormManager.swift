//
//  FormManager.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import SwiftUI
import Combine

// 1. Form Manager - handles form-wide state and validation
class FormManager: ObservableObject {
    @Published var isValid = false
    @Published var isDirty = false
    @Published var isSubmitting = false
    @Published var fields: [String: Any] = [:]
    @Published var errors: [String: String] = [:]

    // Collection of field validators
    private var validators: [String: (Any) -> String?] = [:]

    // Add or update a field value
    func updateField<T>(id: String, value: T) {
        fields[id] = value
        isDirty = true
        validateField(id: id)
        validateForm()
    }

    // Register a field validator
    func registerValidator<T>(id: String, validator: @escaping (T) -> String?) {
        validators[id] = { value in
            guard let typedValue = value as? T else {
                return "Invalid type"
            }
            return validator(typedValue)
        }
    }

    // Validate a specific field
    func validateField(id: String) {
        guard let validator = validators[id],
              let value = fields[id] else {
            return
        }

        if let errorMessage = validator(value) {
            errors[id] = errorMessage
        } else {
            errors.removeValue(forKey: id)
        }
    }

    // Validate the entire form
    func validateForm() {
        for id in fields.keys {
            validateField(id: id)
        }

        isValid = errors.isEmpty
    }

    // Reset the form
    func resetForm() {
        fields = [:]
        errors = [:]
        isDirty = false
        isValid = false
    }

    // Submit the form
    func submitForm(onSuccess: @escaping ([String: Any]) -> Void) {
        validateForm()

        guard isValid else { return }

        isSubmitting = true

        // Simulate network delay with a simple delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            onSuccess(self.fields)
            self.isSubmitting = false
        }
    }
}

// 2. Improved Form Field with FormManager integration
struct ManagedFormField<Label: View, Input: View>: View {
    let id: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool

    @ViewBuilder let label: () -> Label
    @ViewBuilder let input: () -> Input

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            label()
                .font(.caption)
                .foregroundColor(.secondary)

            input()
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let error = formManager.errors[id] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 4)
        .animation(.easeInOut, value: formManager.errors[id] != nil)
    }
}

// 3. Managed Text Field - integrated with form manager
struct ManagedTextField: View {
    let id: String
    let label: String
    let placeholder: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    let autocapitalization: TextInputAutocapitalization

    @State private var text: String = ""

    init(
        id: String,
        label: String,
        placeholder: String = "",
        formManager: FormManager,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.autocapitalization = autocapitalization

        // Register validator
        formManager.registerValidator(id: id) { (value: String) -> String? in
            if isRequired && value.isEmpty {
                return "This field is required"
            }

            for rule in validationRules {
                if !rule.validate(value) {
                    return rule.errorMessage
                }
            }

            return nil
        }
    }

    var body: some View {
        ManagedFormField(
            id: id,
            formManager: formManager,
            isRequired: isRequired,
            label: {
                HStack {
                    Text(label)
                    if isRequired {
                        Text("*")
                            .foregroundColor(.red)
                    }
                }
            },
            input: {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(autocapitalization)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .onChange(of: text) { newValue in
                        formManager.updateField(id: id, value: newValue)
                    }
                    .onAppear {
                        // Initialize with empty string
                        formManager.updateField(id: id, value: text)
                    }
            }
        )
    }
}

// 4. Managed Secure Field - for password input
struct ManagedSecureField: View {
    let id: String
    let label: String
    let placeholder: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool
    let contentType: UITextContentType?

    @State private var text: String = ""

    init(
        id: String,
        label: String,
        placeholder: String = "",
        formManager: FormManager,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        contentType: UITextContentType? = nil
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.contentType = contentType

        // Register validator
        formManager.registerValidator(id: id) { (value: String) -> String? in
            if isRequired && value.isEmpty {
                return "This field is required"
            }

            for rule in validationRules {
                if !rule.validate(value) {
                    return rule.errorMessage
                }
            }

            return nil
        }
    }

    var body: some View {
        ManagedFormField(
            id: id,
            formManager: formManager,
            isRequired: isRequired,
            label: {
                HStack {
                    Text(label)
                    if isRequired {
                        Text("*")
                            .foregroundColor(.red)
                    }
                }
            },
            input: {
                SecureField(placeholder, text: $text)
                    .textContentType(contentType)
                    .onChange(of: text) { newValue in
                        formManager.updateField(id: id, value: newValue)
                    }
                    .onAppear {
                        // Initialize with empty string
                        formManager.updateField(id: id, value: text)
                    }
            }
        )
    }
}

// 5. Enhanced Form Container with FormManager
struct ManagedForm<Content: View>: View {
    let title: String
    @StateObject var formManager = FormManager()
    let onSubmit: ([String: Any]) -> Void
    @ViewBuilder let content: (FormManager) -> Content

    @State private var showingSuccessMessage = false

    var body: some View {
        Form {
            Section(header: Text(title).font(.headline)) {
                content(formManager)
            }

            Section {
                Button(action: {
                    formManager.submitForm { data in
                        onSubmit(data)
                        showingSuccessMessage = true
                    }
                }) {
                    HStack {
                        Spacer()
                        if formManager.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Submit")
                        }
                        Spacer()
                    }
                }
                .disabled(!formManager.isValid || formManager.isSubmitting)
                .padding()
                .background(formManager.isValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .disabled(formManager.isSubmitting)
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("Success"),
                message: Text("Form submitted successfully"),
                dismissButton: .default(Text("OK")) {
                    formManager.resetForm()
                }
            )
        }
    }
}
