//
//  ManagedMultiPickerField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

/// A managed version of the multi-selection picker field that works with FormManager
struct ManagedMultiPickerField<T: Hashable & Codable>: View {
    let id: String
    let label: String
    let placeholder: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool
    let options: [T]
    let optionLabels: [T: String]
    let minSelections: Int
    let maxSelections: Int?

    @State private var selectedOptions: Set<T> = []

    init(
        id: String,
        label: String,
        placeholder: String = "Select options",
        formManager: FormManager,
        isRequired: Bool = false,
        options: [T],
        optionLabels: [T: String] = [:],
        initialSelections: Set<T> = [],
        minSelections: Int = 0,
        maxSelections: Int? = nil
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.formManager = formManager
        self.isRequired = isRequired
        self.options = options
        self.optionLabels = optionLabels
        self.minSelections = minSelections
        self.maxSelections = maxSelections
        self._selectedOptions = State(initialValue: initialSelections)

        // Register validator for this field
        formManager.registerValidator(id: id) { (value: Set<T>) -> String? in
            if isRequired && value.isEmpty {
                return "Please select at least one option"
            }

            if value.count < minSelections {
                return "Please select at least \(minSelections) options"
            }

            if let max = maxSelections, value.count > max {
                return "Please select no more than \(max) options"
            }

            return nil
        }

        // Initialize with initial selections if provided
        if !initialSelections.isEmpty {
            formManager.updateField(id: id, value: initialSelections)
        } else {
            formManager.updateField(id: id, value: Set<T>())
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
                VStack(alignment: .leading) {
                    // Display selected options
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
                                            formManager.updateField(id: id, value: selectedOptions)
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

                    // Add options button
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    // Check if adding would exceed max selections
                                    if let max = maxSelections, selectedOptions.count >= max {
                                        return
                                    }
                                    selectedOptions.insert(option)
                                }
                                formManager.updateField(id: id, value: selectedOptions)
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
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        )
    }
}
