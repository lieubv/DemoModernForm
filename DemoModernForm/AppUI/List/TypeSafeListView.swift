//
//  TypeSafeListView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

import SwiftUI

struct TypeSafeListView: View {
    private let formItems: [FormListItem] = [
        FormListItem(
            title: "User Info",
            destination: AnyView(
                //UserFormView()
                IssueFormView(formData: IssueFormData())
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
        .navigationTitle("Form")
    }
}

#Preview {
    TypeSafeListView()
}
