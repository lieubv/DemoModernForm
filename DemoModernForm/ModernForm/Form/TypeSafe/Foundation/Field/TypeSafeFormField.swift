//
//  TypeSafeFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

// MARK: - Base Form Field Component
/// Base component for type-safe form fields
struct TypeSafeFormField<T: FormData, V, Label: View, Input: View>: View {
    // MARK: - Properties

    /// KeyPath to the field in form data
    let keyPath: WritableKeyPath<T, V>

    /// Form manager instance
    @ObservedObject var formManager: TypeSafeFormManager<T>

    /// Whether the field is required
    let isRequired: Bool

    /// View builder for the field label
    @ViewBuilder let label: () -> Label

    /// View builder for the input control, receives a binding to the field value
    @ViewBuilder let input: (Binding<V>) -> Input

    // MARK: - Computed Properties

    /// Field ID used for validation and errors
    var fieldId: String {
        return formManager.getFieldName(for: keyPath) ?? "unknown"
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Field label
            label()
                .font(.caption)
                .foregroundColor(.secondary)

            // Input control with binding
            input(Binding<V>(
                get: { formManager.formData[keyPath: keyPath] },
                set: { formManager.updateField(keyPath, value: $0) }
            ))
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            // Error message if any
            if let error = formManager.errors[fieldId] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 4)
        .animation(.easeInOut, value: formManager.errors[fieldId] != nil)
    }
}
