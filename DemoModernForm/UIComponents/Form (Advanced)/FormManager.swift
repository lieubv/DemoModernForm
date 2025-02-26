//
//  FormManager.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI
import Combine

/// Form Manager - handles form-wide state and validation
class FormManager: ObservableObject {
    @Published var isValid = false
    @Published var isDirty = false
    @Published var isSubmitting = false
    @Published var fields: [String: Any] = [:]
    @Published var errors: [String: String] = [:]

    /// Collection of field validators
    private var validators: [String: (Any) -> String?] = [:]

    /// Add or update a field value
    func updateField<T>(id: String, value: T) {
        fields[id] = value
        isDirty = true
        validateField(id: id)
        validateForm()
    }

    /// Register a field validator
    func registerValidator<T>(id: String, validator: @escaping (T) -> String?) {
        validators[id] = { value in
            guard let typedValue = value as? T else {
                return "Invalid type"
            }
            return validator(typedValue)
        }
    }

    /// Validate a specific field
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
