//
//  UserSubmission.swift
//  DemoModernForm
//
//  Created by ChinhNT on 3/6/25.
//

import Foundation

/// Model that represents a saved user form submission
struct UserSubmission: Identifiable, Codable {
    /// Unique identifier for each submission
    let id: UUID
    
    /// Timestamp when the submission was created
    let timestamp: Date
    
    /// The actual form data that was submitted
    let formData: UserForm
    
    /// Initialize with auto-generated ID and current timestamp
    init(formData: UserForm) {
        self.id = UUID()
        self.timestamp = Date()
        self.formData = formData
    }
}
