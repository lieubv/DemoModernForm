//
//  DatePickerField.swift
//  DemoModernForm
//
//  Created by Chinh on 3/1/25.
//

import SwiftUI

/// A type-safe field component for selecting dates in forms
struct DatePickerField<T: FormData>: View {
    // MARK: - Properties
    
    /// KeyPath to date field in form data
    let keyPath: WritableKeyPath<T, Date>
    
    /// Field label
    let label: String
    
    /// Form manager instance
    @ObservedObject var formManager: ModernFormManager<T>
    
    /// Whether the field is required
    let isRequired: Bool
    
    /// Display mode for the date picker
    let displayMode: DatePickerComponents
    
    /// Optional minimum date
    let minDate: Date?
    
    /// Optional maximum date
    let maxDate: Date?
    
    // MARK: - Initialization
    init(
        keyPath: WritableKeyPath<T, Date>,
        label: String,
        formManager: ModernFormManager<T>,
        isRequired: Bool = false,
        displayMode: DatePickerComponents = .date,
        minDate: Date? = nil,
        maxDate: Date? = nil,
        validationRules: [ValidationRule] = []
    ) {
        self.keyPath = keyPath
        self.label = label
        self.formManager = formManager
        self.isRequired = isRequired
        self.displayMode = displayMode
        self.minDate = minDate
        self.maxDate = maxDate
        
        // Register field with form manager if not already registered
        let keyPathString = String(describing: keyPath)
        if formManager.keyPathToFieldName[keyPathString] == nil {
            let fieldName = formManager.generateFieldName(from: keyPathString)
            formManager.registerField(keyPath, fieldName: fieldName)
        }
        
        // Register validator
        if let fieldId = formManager.getFieldName(for: keyPath) {
            formManager.registerValidator(id: fieldId) { (value: Date) -> String? in
                // Check if the date is within valid range
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                
                if let minDate = minDate, value < minDate {
                    return "Date must be after \(formatter.string(from: minDate))"
                }
                
                if let maxDate = maxDate, value > maxDate {
                    return "Date must be before \(formatter.string(from: maxDate))"
                }
                
                return nil
            }
        }
    }
    
    // MARK: - Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
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
                    DatePicker(
                        "",
                        selection: binding,
                        in: rangeConstraint,
                        displayedComponents: displayMode
                    )
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                }
            )
            Spacer()
        }
    }
    
    // MARK: - Helper Properties
    
    /// Returns the date range based on min and max constraints
    private var rangeConstraint: ClosedRange<Date> {
        let minValue = minDate ?? Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        let maxValue = maxDate ?? Date(timeIntervalSinceNow: 3153600000)  // ~100 years from now
        return minValue...maxValue
    }
}

// MARK: - Preview
struct DatePickerField_Previews: PreviewProvider {
    struct TestData: FormData {
        var selectedDate: Date = Date()
        static var requiredFields: [String] { [] }
    }
    
    static var previews: some View {
        Form {
            DatePickerField(
                keyPath: \TestData.selectedDate,
                label: "Birthdate",
                formManager: ModernFormManager(initialData: TestData()),
                isRequired: true,
                displayMode: .hourAndMinute
            )
        }
    }
}
