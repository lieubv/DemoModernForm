//
//  UserDataManager.swift
//  DemoModernForm
//
//  Created by Chinh on 3/6/25.
//

import SwiftUI
import Combine

class UserDataManager: ObservableObject {
    @Published private(set) var submissions: [UserSubmission] = []
    
    static let shared = UserDataManager()
    
    private init() {}
    
    func addSubmission(formData: UserForm) {
        let submission = UserSubmission(formData: formData)
        
        DispatchQueue.main.async {
            self.submissions.insert(submission, at: 0)
        }
    }
    
    func deleteSubmission(id: UUID) {
        DispatchQueue.main.async {
            self.submissions.removeAll { $0.id == id }
        }
    }
    
    func clearAllSubmissions() {
        DispatchQueue.main.async {
            self.submissions.removeAll()
        }
    }
}
