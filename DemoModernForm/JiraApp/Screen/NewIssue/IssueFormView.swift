//
//  IssueFormView.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI
import Combine


// MARK: - Main Issue Form View
struct IssueFormView: View {
    @ObservedObject var formData: IssueFormData

    var body: some View {
        Form {
            CollapsibleSection(title: "Issue Summary") {
                TextInputField(title: "Summary",
                               placeholder: "Add an issue summary...",
                               text: $formData.issueSummary)
            }

            CollapsibleSection(title: "Description") {
                TextInputField(title: "", placeholder: "Add a description...", text: $formData.description)
            }

            CollapsibleSection(title: "Attachments") {
                AttachmentField(attachments: $formData.attachments)
            }

            CollapsibleSection(title: "More Fields") {
                ReadOnlyField(title: "Assignee", value: formData.assignee)
                ReadOnlyField(title: "Labels", value: formData.labels)
                ReadOnlyField(title: "Sprint", value: formData.sprint)
                ReadOnlyField(title: "Story Point Estimate", value: formData.storyPointEstimate)
                ReadOnlyField(title: "Reporter", value: formData.reporter)
                ReadOnlyField(title: "Flagged", value: formData.flagged)
            }
        }
        .navigationTitle("Create Issue")
    }
}

// MARK: - Preview
struct IssueFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssueFormView(formData: IssueFormData())
        }
    }
}
