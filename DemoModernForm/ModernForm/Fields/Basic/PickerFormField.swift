//
//  PickerFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

// MARK: - Single Selection Picker Field

/// A form field that allows selecting a single option from a list of choices
/// Generic type `T` allows for flexibility in the type of data being selected
struct PickerFormField<T: Hashable>: FormFieldProtocol {
    var id: String
    var label: String
    var placeholder: String
    var isRequired: Bool
    var validationRules: [ValidationRule]
    var options: [T]                // Array of available options
    var optionLabels: [T: String]   // Mapping from option to display label
    @Binding var selectedOption: T? // Currently selected option

    /// Initialize a new picker form field
    /// - Parameters:
    ///   - id: Unique identifier for the field
    ///   - label: Display label for the field
    ///   - placeholder: Placeholder text when no option is selected
    ///   - isRequired: Whether a selection is required
    ///   - validationRules: Additional validation rules
    ///   - options: Array of available options
    ///   - optionLabels: Mapping from options to display labels
    ///   - selectedOption: Binding to the currently selected option
    init(
        id: String,
        label: String,
        placeholder: String = "Select an option",
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        options: [T],
        optionLabels: [T: String],
        selectedOption: Binding<T?>
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.options = options
        self.optionLabels = optionLabels
        self._selectedOption = selectedOption
    }

    /// Check if the field's value is valid
    var isValid: Bool {
        if isRequired && selectedOption == nil {
            return false
        }

        // If we have a selected option, run it through validation rules
        if let selected = selectedOption {
            return validationRules.allSatisfy { $0.validate(selected) }
        }

        // If not required and nothing selected, that's valid
        return true
    }

    /// Create the input view for this picker field
    func makeInputView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Field label
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            // Picker with menu
            Menu {
                // "None" option if not required
                if !isRequired {
                    Button("None") {
                        selectedOption = nil
                    }
                }

                // Menu items for each option
                ForEach(options, id: \.self) { option in
                    Button(optionLabels[option] ?? "\(option)") {
                        selectedOption = option
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption.flatMap { optionLabels[$0] } ?? placeholder)
                        .foregroundColor(selectedOption == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding()
                .background(Color(.systemGray6))
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
        if isRequired && selectedOption == nil {
            return "Please select an option"
        }

        if let selected = selectedOption {
            for rule in validationRules {
                if !rule.validate(selected) {
                    return rule.errorMessage
                }
            }
        }

        return ""
    }
}
