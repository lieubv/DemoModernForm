//
//  TabItem.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case basic = 0
    case typeSafe

    var title: String {
        switch self {
        case .basic:
            return "Basic"
        case .typeSafe:
            return "TypeSafe"
        }
    }

    var icon: String {
        switch self {
        case .basic:
            return "person.crop.circle.fill"
        case .typeSafe:
            return "circle.square"
        }
    }
}
