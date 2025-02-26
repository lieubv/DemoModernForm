//
//  ManagedForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI

// 5. Enhanced Form Container with FormManager
struct ManagedForm<Content: View>: View {
    let title: String
    @StateObject var formManager = FormManager()
    let onSubmit: ([String: Any]) -> Void
    @ViewBuilder let content: (FormManager) -> Content

    @State private var showingSuccessMessage = false

    var body: some View {
        Form {
            Section(header: Text(title).font(.headline)) {
                content(formManager)
            }

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

//#Preview {
//    ManagedForm()
//}
