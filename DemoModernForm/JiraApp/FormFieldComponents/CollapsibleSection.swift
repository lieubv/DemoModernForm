//
//  CollapsibleSection.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI

// MARK: - Collapsible Section
struct CollapsibleSection<Content: View>: View {
    let title: String
    @State private var isExpanded: Bool = true
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        Section {
            DisclosureGroup(isExpanded: $isExpanded) {
                content
            }
            label: {
                Text(title).font(.headline)
            }
           
        }
    }
}


