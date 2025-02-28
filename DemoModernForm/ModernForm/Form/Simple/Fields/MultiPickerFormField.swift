//
//  MultiPickerFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

// MARK: - Multi-Selection Picker Field
/// A form field that allows selecting multiple options from a list of choices
struct MultiPickerFormField<T: Hashable>: FormFieldProtocol {
    var id: String
    var label: String
    var placeholder: String
    var isRequired: Bool
    var validationRules: [ValidationRule]
    var options: [T]                  // Array of available options
    var optionLabels: [T: String]     // Mapping from option to display label
    @Binding var selectedOptions: Set<T> // Currently selected options

    /// Initialize a new multi-selection picker form field
    /// - Parameters:
    ///   - id: Unique identifier for the field
    ///   - label: Display label for the field
    ///   - placeholder: Placeholder text when no options are selected
    ///   - isRequired: Whether at least one selection is required
    ///   - validationRules: Additional validation rules
    ///   - options: Array of available options
    ///   - optionLabels: Mapping from options to display labels
    ///   - selectedOptions: Binding to the currently selected options
    init(
        id: String,
        label: String,
        placeholder: String = "Select options",
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        options: [T],
        optionLabels: [T: String],
        selectedOptions: Binding<Set<T>>
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.options = options
        self.optionLabels = optionLabels
        self._selectedOptions = selectedOptions
    }

    /// Check if the field's value is valid
    var isValid: Bool {
        if isRequired && selectedOptions.isEmpty {
            return false
        }

        // Run validation rules on the set of selected options
        return validationRules.allSatisfy { $0.validate(selectedOptions) }
    }

    /// Create the input view for this multi-selection picker field
    func makeInputView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Field label
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            // Display selected options
            VStack(alignment: .leading) {
                if selectedOptions.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // ScrollView for selected options
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(selectedOptions), id: \.self) { option in
                                // Chip for each selected option
                                HStack {
                                    Text(optionLabels[option] ?? "\(option)")
                                        .font(.footnote)

                                    Button(action: {
                                        selectedOptions.remove(option)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.footnote)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)

            // Add options button
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        if selectedOptions.contains(option) {
                            selectedOptions.remove(option)
                        } else {
                            selectedOptions.insert(option)
                        }
                    }) {
                        HStack {
                            Text(optionLabels[option] ?? "\(option)")
                            if selectedOptions.contains(option) {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Add/Remove Options")
                        .font(.footnote)
                    Image(systemName: "plus.circle.fill")
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }

            // Error message
            if !isValid {
                Text(getErrorMessage())
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }

    /// Get appropriate error message based on validation state
    private func getErrorMessage() -> String {
        if isRequired && selectedOptions.isEmpty {
            return "Please select at least one option"
        }

        for rule in validationRules {
            if !rule.validate(selectedOptions) {
                return rule.errorMessage
            }
        }

        return ""
    }
}
