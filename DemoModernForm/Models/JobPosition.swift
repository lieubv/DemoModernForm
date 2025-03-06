//
//  JobPosition.swift
//  DemoModernForm
//
//  Created by Chinh on 3/6/25.
//

import Foundation

enum JobPosition: String, Hashable, CaseIterable, Codable {
    case developer
    case designer
    case manager
    case marketing
    case sales
    case other
    
    var displayName: String {
        rawValue.capitalized
    }
}
