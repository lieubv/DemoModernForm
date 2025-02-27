//
//  BasicListView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

struct BasicListView: View {
    // Array of form items to display in the list
    private let formItems: [FormListItem] = [
        FormListItem(title: "User Profile", destination: AnyView(UserProfileForm())),
        FormListItem(title: "Login", destination: AnyView(LoginForm())),
        FormListItem(title: "Basic Picker Example", destination: AnyView(BasicPickerFormExample()))
    ]

    var body: some View {
        List(formItems) { item in
            NavigationLink(destination: item.destination) {
                Text(item.title)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("Basic Forms")
    }
}

// Preview provider
struct BasicListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BasicListView()
        }
    }
}
