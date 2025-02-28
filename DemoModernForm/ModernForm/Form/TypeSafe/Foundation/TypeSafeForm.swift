//
//  TypeSafeForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

/// Main form container component with type-safe data handling
struct TypeSafeForm<T: FormData, Content: View>: View {
    // MARK: - Properties
    /// Form title
    let title: String

    /// Form manager instance
    @ObservedObject var formManager: TypeSafeFormManager<T>

    /// Form submit handler
    let onSubmit: (T) -> Void

    /// Content builder
    @ViewBuilder let content: (TypeSafeFormManager<T>) -> Content

    /// State for success message
    @State private var showingSuccessMessage = false

    // MARK: - Initialization
    init(
        title: String,
        initialData: T,
        onSubmit: @escaping (T) -> Void,
        @ViewBuilder content: @escaping (TypeSafeFormManager<T>) -> Content
    ) {
        self.title = title
        self._formManager = ObservedObject(wrappedValue: TypeSafeFormManager(initialData: initialData))
        self.onSubmit = onSubmit
        self.content = content
    }

    // MARK: - Body
    var body: some View {
        Form {
            // Form title section
            Section(header: Text(title).font(.headline)) {
                content(formManager)
            }

            // Submit button section
            Section {
                Button(action: {
                    formManager.submitForm { data in
                        onSubmit(data)
                        showingSuccessMessage = true
                    }
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
        .disabled(formManager.isSubmitting)
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("Success"),
                message: Text("Form submitted successfully"),
                dismissButton: .default(Text("OK")) {
                    formManager.resetForm()
                }
            )
        }
    }
}

// MARK: - Extensions cho TypeSafeFormManager
extension TypeSafeFormManager {
    // Using explicit generic parameter declaration
    func getFieldName(for keyPath: PartialKeyPath<T>) -> String? {
        let keyPathString = String(describing: keyPath)
        return keyPathToFieldName[keyPathString]
    }
}
