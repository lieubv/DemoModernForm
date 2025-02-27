//
//  TabItem.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case basic = 0
    case advanced

    var title: String {
        switch self {
        case .basic:
            return "Basic"
        case .advanced:
            return "Advanced"
        }
    }

    var icon: String {
        switch self {
        case .basic:
            return "person.crop.circle.fill"
        case .advanced:
            return "person.crop.circle.fill"
        }
    }
}
