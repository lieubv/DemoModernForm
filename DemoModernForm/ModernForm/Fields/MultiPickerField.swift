//
//  MultiPickerField.swift
//  DemoModernForm
//
//  Created by Chinh on 3/1/25.
//

import SwiftUI

struct MultiPickerField<T: FormData, V: Identifiable & Hashable>: View {
    // MARK: - Properties
    
    /// KeyPath to array field in form data
    let keyPath: WritableKeyPath<T, [V]>
    
    /// Field label
    let label: String
    
    /// Available options to select from
    let options: [V]
    
    /// Form manager instance
    @ObservedObject var formManager: ModernFormManager<T>
    
    /// Whether the field is required
    let isRequired: Bool
    
    /// Optional minimum number of selections required
    let minSelections: Int?
    
    /// Optional maximum number of selections allowed
    let maxSelections: Int?
    
    /// Function to display text for each option
    let displayText: (V) -> String
    
    // MARK: - State
    
    /// Controls whether the picker is shown
    @State private var isShowingPicker = false
    
    // MARK: - Initialization
    init(
        keyPath: WritableKeyPath<T, [V]>,
        label: String,
        options: [V],
        formManager: ModernFormManager<T>,
        isRequired: Bool = false,
        minSelections: Int? = nil,
        maxSelections: Int? = nil,
        displayText: @escaping (V) -> String
    ) {
        self.keyPath = keyPath
        self.label = label
        self.options = options
        self.formManager = formManager
        self.isRequired = isRequired
        self.minSelections = minSelections
        self.maxSelections = maxSelections
        self.displayText = displayText
        
        // Register field with form manager
        let keyPathString = String(describing: keyPath)
        if formManager.keyPathToFieldName[keyPathString] == nil {
            let fieldName = formManager.generateFieldName(from: keyPathString)
            formManager.registerField(keyPath, fieldName: fieldName)
        }
        
        // Register validator
        if let fieldId = formManager.getFieldName(for: keyPath) {
            formManager.registerValidator(id: fieldId) { (selections: [V]) -> String? in
                if isRequired && selections.isEmpty {
                    return "Please select at least one option"
                }
                
                if let minSelections = minSelections, selections.count < minSelections {
                    return "Please select at least \(minSelections) option\(minSelections > 1 ? "s" : "")"
                }
                
                if let maxSelections = maxSelections, selections.count > maxSelections {
                    return "Please select at most \(maxSelections) option\(maxSelections > 1 ? "s" : "")"
                }
                
                return nil
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ModernFormField(
            keyPath: keyPath,
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
            input: { binding in
                Button(action: {
                    isShowingPicker = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            if binding.wrappedValue.isEmpty {
                                Text("Select options")
                                    .foregroundColor(.gray)
                            } else {
                                Text(formatSelections(binding.wrappedValue))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $isShowingPicker) {
                    pickerView(binding)
                }
            }
        )
    }
    
    // MARK: - Helper Methods
    
    /// Format the selected options for display
    private func formatSelections(_ selections: [V]) -> String {
        if selections.isEmpty {
            return "None selected"
        } else if selections.count <= 3 {
            return selections.map(displayText).joined(separator: ", ")
        } else {
            return "\(selections.count) items selected"
        }
    }
    
    /// Create the multi-selection picker view
    @ViewBuilder
    private func pickerView(_ binding: Binding<[V]>) -> some View {
        NavigationView {
            List {
                ForEach(options) { option in
                    Button(action: {
                        toggleSelection(option, in: binding)
                    }) {
                        HStack {
                            Text(displayText(option))
                            Spacer()
                            if binding.wrappedValue.contains(where: { $0.id == option.id }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle(label)
            .navigationBarItems(
                trailing: Button("Done") {
                    isShowingPicker = false
                }
            )
        }
    }
    
    /// Toggle the selection state of an option
    private func toggleSelection(_ option: V, in binding: Binding<[V]>) {
        var currentSelections = binding.wrappedValue
        
        if let index = currentSelections.firstIndex(where: { $0.id == option.id }) {
            // Remove if already selected
            currentSelections.remove(at: index)
        } else {
            // Check if we're at the maximum selections
            if let maxSelections = maxSelections, currentSelections.count >= maxSelections {
                // If at max, don't add more
                return
            }
            
            // Add if not selected
            currentSelections.append(option)
        }
        
        binding.wrappedValue = currentSelections
    }
}

// MARK: - Preview
struct MultiPickerField_Previews: PreviewProvider {
    struct TestData: FormData {
        var selectedSkills: [Skill] = []
        static var requiredFields: [String] { [] }
    }
    
    static var previews: some View {
        Form {
            MultiPickerField(
                keyPath: \TestData.selectedSkills,
                label: "Skills",
                options: Skill.allSkills,
                formManager: ModernFormManager(initialData: TestData()),
                isRequired: true,
                minSelections: 1,
                maxSelections: Skill.allSkills.count
            ) { skill in
                skill.name
            }
        }
    }
}
