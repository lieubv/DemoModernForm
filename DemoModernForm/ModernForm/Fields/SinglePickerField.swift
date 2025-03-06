//
//  SinglePickerField.swift
//  DemoModernForm
//
//  Created by Chinh on 3/1/25.
//

import SwiftUI

/// A type-safe picker field for selecting a single option from a list of choices
struct SinglePickerField<T: FormData, V: Hashable & CaseIterable>: View {
    // MARK: - Properties
    
    /// KeyPath to the field in form data
    let keyPath: WritableKeyPath<T, V>
    
    /// Field label
    let label: String
    
    /// Form manager instance
    @ObservedObject var formManager: ModernFormManager<T>
    
    /// Whether the field is required
    let isRequired: Bool
    
    /// Function to get display text for each option
    let displayText: (V) -> String
    
    // MARK: - State
    
    /// Controls whether the picker is shown
    @State private var isShowingPicker = false
    
    // MARK: - Initialization
    init(
        keyPath: WritableKeyPath<T, V>,
        label: String,
        formManager: ModernFormManager<T>,
        isRequired: Bool = false,
        displayText: @escaping (V) -> String
    ) {
        self.keyPath = keyPath
        self.label = label
        self.formManager = formManager
        self.isRequired = isRequired
        self.displayText = displayText
        
        // Register field with form manager
        let keyPathString = String(describing: keyPath)
        if formManager.keyPathToFieldName[keyPathString] == nil {
            let fieldName = formManager.generateFieldName(from: keyPathString)
            formManager.registerField(keyPath, fieldName: fieldName)
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
                        Text(displayText(binding.wrappedValue))
                            .foregroundColor(.primary)
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
    
    /// Create the picker view inside a sheet
    @ViewBuilder
    private func pickerView(_ binding: Binding<V>) -> some View {
        NavigationView {
            List {
                ForEach(Array(V.allCases), id: \.self) { item in
                    Button(action: {
                        binding.wrappedValue = item
                        isShowingPicker = false
                    }) {
                        HStack {
                            Text(displayText(item))
                            Spacer()
                            if binding.wrappedValue == item {
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
}

// MARK: - Convenience Extensions for String-based Enums
extension SinglePickerField where V: RawRepresentable, V.RawValue == String {
    /// Convenience initializer for enums with String raw values
    init(
        keyPath: WritableKeyPath<T, V>,
        label: String,
        formManager: ModernFormManager<T>,
        isRequired: Bool = false
    ) {
        self.init(
            keyPath: keyPath,
            label: label,
            formManager: formManager,
            isRequired: isRequired,
            displayText: { $0.rawValue.capitalized }
        )
    }
}

// MARK: - Preview
struct SinglePickerField_Previews: PreviewProvider {
    // Define a simple enum for testing that properly conforms to Codable
    enum TestColor: String, CaseIterable, Hashable, Codable {
        case red, green, blue, yellow, purple
    }
    
    // Define a test form data structure that properly conforms to all required protocols
    struct TestData: FormData {
        var selectedColor: TestColor = .blue
        
        static var requiredFields: [String] { [] }
    }
    
    static var previews: some View {
        Form {
            SinglePickerField(
                keyPath: \TestData.selectedColor,
                label: "Favorite Color",
                formManager: ModernFormManager(initialData: TestData())
            ) { color in
                color.rawValue.capitalized
            }
        }
    }
}

// MARK: - Helper comment for FavoriteColor
// Note: FavoriteColor should already conform to CaseIterable from your implementation
// If not, make sure FavoriteColor conforms to Codable and CaseIterable
