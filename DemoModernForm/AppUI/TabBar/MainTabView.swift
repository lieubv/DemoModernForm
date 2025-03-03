//
//  MainTabView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .basic

    var body: some View {
        TabView(selection: $selectedTab) {
            // Create view for each tab
            ForEach(TabItem.allCases, id: \.self) { tab in
                getTabView(tab)
                    .tabItem {
                        Image(systemName: tab.icon)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder
    func getTabView(_ tab: TabItem) -> some View {
        switch tab {
        case .basic:
            NavigationView {
            }
        case .typeSafe:
            NavigationView {
                TypeSafeListView()
            }
        }
    }
}

// Preview provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
