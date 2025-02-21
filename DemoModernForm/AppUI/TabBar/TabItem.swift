//
//  TabItem.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case basicForm = 0
    case loginForm
    case registrationForm
    case userProfileForm

    // 2. Thuộc tính cho mỗi tab
    var title: String {
        switch self {
        case .basicForm:
            return "Basic"
        case .loginForm:
            return "Login"
        case .registrationForm:
            return "Registration"
        case .userProfileForm:
            return "User Profile"
        }
    }

    var icon: String {
        switch self {
        case .basicForm:
            return "house.fill"
        case .loginForm:
            return "magnifyingglass"
        case .registrationForm:
            return "person.fill"
        case .userProfileForm:
            return "person.crop.circle.fill"
        }
    }
}
