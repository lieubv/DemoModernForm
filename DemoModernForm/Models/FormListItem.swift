//
//  FormListItem.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

/// A model to represent an item in the form list with navigation destination
struct FormListItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: AnyView
}
