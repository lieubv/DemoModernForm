//
//  DataListView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 6/3/25.
//

import SwiftUI

struct DataListView: View {
    // Reference to the data manager
    @ObservedObject private var dataManager = UserDataManager.shared
    
    // State for showing the detail view
    @State private var selectedSubmission: UserSubmission? = nil
    
    // Formatter for display dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Group {
            if dataManager.submissions.isEmpty {
                emptyStateView
            } else {
                submissionsList
            }
        }
        .navigationTitle("Submitted Data")
        .sheet(item: $selectedSubmission) { submission in
            SubmissionDetailView(submission: submission)
        }
        .toolbar {
            if !dataManager.submissions.isEmpty {
                Button(action: {
                    dataManager.clearAllSubmissions()
                }) {
                    Label("Clear All", systemImage: "trash")
                }
            }
        }
    }
    
    // View when no data exists
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No submissions yet")
                .font(.headline)
            
            Text("Fill out the form in the Form tab to see data here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    // List of submissions
    private var submissionsList: some View {
        List {
            ForEach(dataManager.submissions) { submission in
                Button(action: {
                    selectedSubmission = submission
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(submission.formData.firstName) \(submission.formData.lastName)")
                            .font(.headline)
                        
                        Text(submission.formData.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Submitted: \(dateFormatter.string(from: submission.timestamp))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: deleteSubmissions)
        }
    }
    
    // Delete submissions from the list
    private func deleteSubmissions(at offsets: IndexSet) {
        for index in offsets {
            dataManager.deleteSubmission(id: dataManager.submissions[index].id)
        }
    }
}

// Detail view for showing a single submission's details
struct SubmissionDetailView: View {
    let submission: UserSubmission
    @Environment(\.presentationMode) var presentationMode
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    LabeledContent("First Name", value: submission.formData.firstName)
                    LabeledContent("Last Name", value: submission.formData.lastName)
                    LabeledContent("Email", value: submission.formData.email)
                    LabeledContent("Phone", value: submission.formData.phoneNumber)
                }
                
                Section(header: Text("Additional Information")) {
                    LabeledContent("Date of Birth", value: formatDate(submission.formData.birthDate))
                    LabeledContent("Job Position", value: submission.formData.jobPosition.displayName)
                    
                    if !submission.formData.skills.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Skills")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ForEach(submission.formData.skills) { skill in
                                Text("• \(skill.name)")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Submission Details")) {
                    LabeledContent("Submitted on", value: dateFormatter.string(from: submission.timestamp))
                }
            }
            .navigationTitle("Submission Details")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Helper view for showing a label and value
struct LabeledContent: View {
    let label: String
    let value: String
    
    init(_ label: String, value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

struct DataListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DataListView()
        }
    }
}
