//
//  ManagedFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI

// 2. Improved Form Field with FormManager integration
struct ManagedFormField<Label: View, Input: View>: View {
    let id: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool

    @ViewBuilder let label: () -> Label
    @ViewBuilder let input: () -> Input

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            label()
                .font(.caption)
                .foregroundColor(.secondary)

            input()
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let error = formManager.errors[id] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 4)
        .animation(.easeInOut, value: formManager.errors[id] != nil)
    }
}
