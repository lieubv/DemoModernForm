//
//  TypeSafeListView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct TypeSafeListView: View {
    // Array of form items to display in the list
    private let formItems: [FormListItem] = [
        FormListItem(
            title: "UserFormView",
            destination: AnyView(
                UserFormView()
            )
        )
    ]

    var body: some View {
        List(formItems) { item in
            NavigationLink(destination: item.destination) {
                Text(item.title)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("Type safe")
    }
}

#Preview {
    TypeSafeListView()
}
