//
//  FavoriteColor.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import Foundation

// Example enum for single selection picker
enum FavoriteColor: String, Hashable, CaseIterable, Codable {
    case red
    case blue
    case green
    case yellow
    case purple
    case orange

    var displayName: String {
        rawValue.capitalized
    }
}
