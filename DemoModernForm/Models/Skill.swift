//
//  Skill.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import Foundation

// Example struct for multi-selection picker
struct Skill: Identifiable, Hashable, Codable {
    var id: String
    var name: String

    static let programming = Skill(id: "prog", name: "Programming")
    static let design = Skill(id: "design", name: "Design")
    static let marketing = Skill(id: "marketing", name: "Marketing")
    static let writing = Skill(id: "writing", name: "Writing")
    static let management = Skill(id: "management", name: "Management")
    static let sales = Skill(id: "sales", name: "Sales")

    static let allSkills: [Skill] = [
        programming, design, marketing, writing, management, sales
    ]
}
