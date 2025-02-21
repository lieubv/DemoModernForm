//
//  ReusableForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

// 5. Form Container - manages multiple fields
struct ReusableForm<Content: View>: View {
    let title: String
    let onSubmit: () -> Void
    let content: () -> Content

    init(
        title: String,
        onSubmit: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.onSubmit = onSubmit
        self.content = content
    }

    var body: some View {
        Form {
            Section(header: Text(title).font(.headline)) {
                content()
            }

            Section {
                Button("Submit") {
                    onSubmit()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ReusableForm(title: "Reusable Form") {
        print("Submit")
    } content: {
        Text("Hello, World!")
        TextFormField(
            id: "firstName",
            label: "First name",
            text: .constant("Hehe")
        ).makeInputView()
    }
}
