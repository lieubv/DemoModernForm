//
//  TextInputField.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI

// MARK: - Optimized TextInputField for Multi-line Description
struct TextInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title
//            Text(title)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.bottom, 2)

            // Multi-line Input Field
            TextEditor(text: $text)
                .frame(minHeight: 80) // Adjust height as needed
//                .padding(10)
                .background(Color(UIColor.yellow)) // Subtle background
                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                )
                .overlay(
                    // Placeholder logic
                    Group {
                        if text.isEmpty {
                            Text(placeholder)
                                .foregroundColor(.gray)
                                .padding(10)
                                .allowsHitTesting(false)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                )
        }
    }
}

// MARK: - Preview
struct TextInputField_Previews: PreviewProvider {
    @State static var sampleText = ""

    static var previews: some View {
        TextInputField(title: "Description", placeholder: "Add a description...", text: $sampleText)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
