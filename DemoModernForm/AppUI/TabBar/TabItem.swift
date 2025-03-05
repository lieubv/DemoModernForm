//
//  TabItem.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case form = 0
    case data

    var title: String {
        switch self {
        case .form:
            return "Form"
        case .data:
            return "Data"
        }
    }

    var icon: String {
        switch self {
        case .form:
            return "person.crop.circle.fill"
        case .data:
            return "circle.square"
        }
    }
}
