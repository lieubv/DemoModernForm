//
//  AttachmentField.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI

// MARK: - Attachment Field
struct AttachmentField: View {
    @Binding var attachments: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: {
                attachments.append("Attachment \(attachments.count + 1)")
            }) {
                Text("+ Add attachment").foregroundColor(.blue)
            }

            ForEach(attachments, id: \.self) { attachment in
                Text("• \(attachment)").foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}

