//
//  DynamicSectionsForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

// MARK: - Dynamic Form View
/// Form với các section có thể thay đổi động
struct DynamicSectionsForm: View {
    let title: String
    @StateObject var formManager = DynamicFormManager()
    let onSubmit: ([String: Any]) -> Void

    var body: some View {
        Form {
            // Hiển thị các section
            ForEach(formManager.sections) { section in
                Section(header: Text(section.title).font(.headline)) {
                    // Hiển thị các field trong section
                    ForEach(section.fields) { field in
                        buildFormField(field)
                    }
                }
            }

            // Nút Submit
            Section {
                Button(action: {
                    formManager.submitForm(onSuccess: onSubmit)
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
    }

    /// Xây dựng field dựa vào loại
    @ViewBuilder
    func buildFormField(_ field: FormFieldDescriptor) -> some View {
        VStack(alignment: .leading) {
            // Label
            HStack {
                Text(field.label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if field.isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }

            // Input dựa vào type
            buildInputView(for: field)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            // Error message
            if let error = formManager.errors[field.id] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }

    /// Xây dựng input view dựa vào loại field
    @ViewBuilder
    func buildInputView(for field: FormFieldDescriptor) -> some View {
        switch field.type {
        case .text:
            TextField(field.label, text: Binding(
                get: { formManager.values[field.id] as? String ?? "" },
                set: { formManager.updateField(id: field.id, value: $0) }
            ))
            .padding(.horizontal)

        case .secure:
            SecureField(field.label, text: Binding(
                get: { formManager.values[field.id] as? String ?? "" },
                set: { formManager.updateField(id: field.id, value: $0) }
            ))
            .padding(.horizontal)

        case .toggle:
            Toggle("", isOn: Binding(
                get: { formManager.values[field.id] as? Bool ?? false },
                set: { formManager.updateField(id: field.id, value: $0) }
            ))
            .padding(.horizontal)

        case .picker(let options):
            // Giả định rằng options có thể cast sang String
            let stringOptions = options.compactMap { $0 as? String }
            Picker(field.label, selection: Binding(
                get: { formManager.values[field.id] as? String ?? stringOptions.first ?? "" },
                set: { formManager.updateField(id: field.id, value: $0) }
            )) {
                ForEach(stringOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

        case .multiPicker, .date, .custom:
            // Placeholder cho các loại field phức tạp hơn
            Text("Unsupported field type")
                .padding(.horizontal)
        }
    }
}
