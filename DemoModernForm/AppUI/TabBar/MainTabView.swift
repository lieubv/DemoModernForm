//
//  MainTabView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 21/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .basicForm

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tạo view cho mỗi tab
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
        case .basicForm:
            NavigationView {
                BasicForm()
                    .navigationTitle("Basic")
            }
        case .loginForm:
            NavigationView {
                LoginForm()
                    .navigationTitle("Login")
            }
        case .registrationForm:
            NavigationView {
                RegistrationForm()
                    .navigationTitle("Registration")
            }
        case .userProfileForm:
            NavigationView {
                UserProfileForm()
                    .navigationTitle("User Profile")
            }
        }
    }
}
