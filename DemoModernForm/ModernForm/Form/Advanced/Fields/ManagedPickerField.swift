//
//  ManagedPickerField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

/// A managed version of the single-selection picker field that works with FormManager
struct ManagedPickerField<T: Hashable & Codable>: View {
    let id: String
    let label: String
    let placeholder: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool
    let options: [T]
    let optionLabels: [T: String]

    @State private var selectedOption: T?

    init(
        id: String,
        label: String,
        placeholder: String = "Select an option",
        formManager: FormManager,
        isRequired: Bool = false,
        options: [T],
        optionLabels: [T: String] = [:],
        initialSelection: T? = nil
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.options = options
        self.optionLabels = optionLabels
        self._selectedOption = State(initialValue: initialSelection)

        // Register validator for this field
        formManager.registerValidator(id: id) { (value: T?) -> String? in
            if isRequired && value == nil {
                return "Please select an option"
            }
            return nil
        }

        // Initialize with initial value if provided
        if let initialSelection = initialSelection {
            formManager.updateField(id: id, value: initialSelection)
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
                Menu {
                    // "None" option if not required
                    if !isRequired {
                        Button("None") {
                            selectedOption = nil
                            formManager.updateField(id: id, value: nil as T?)
                        }
                    }

                    // Menu items for each option
                    ForEach(options, id: \.self) { option in
                        Button(optionLabels[option] ?? "\(option)") {
                            selectedOption = option
                            formManager.updateField(id: id, value: option)
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
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        )
    }
}
