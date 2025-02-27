//
//  AdvancedListView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

struct AdvancedListView: View {
    // Array of form items to display in the list
    private let formItems: [FormListItem] = [
        FormListItem(title: "Registration Form", destination: AnyView(RegistrationForm())),
        FormListItem(title: "Managed Picker Form Example", destination: AnyView(ManagedPickerFormExample()))
    ]

    var body: some View {
        List(formItems) { item in
            NavigationLink(destination: item.destination) {
                Text(item.title)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("Advanced Forms")
    }
}

// Preview provider
struct AdvancedListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdvancedListView()
        }
    }
}
