//
//  IssueFormData.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI
import Combine

// MARK: - Form Data Model
class IssueFormData: ObservableObject {
    @Published var issueSummary: String = ""
    @Published var description: String = ""
    @Published var attachments: [String] = []
    @Published var assignee: String = "Automatic"
    @Published var labels: String = "None"
    @Published var sprint: String = "None"
    @Published var storyPointEstimate: String = "None"
    @Published var reporter: String = "Me"
    @Published var flagged: String = "None"
}
