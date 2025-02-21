//
//  BasicForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

struct BasicForm: View {
    @State private var username = ""
    @State private var isNotificationsEnabled = false

    var body: some View {
        Form {
            TextField("Username", text: $username)
            Toggle("Enable notifications", isOn: $isNotificationsEnabled)
        }
    }
}

#Preview {
    BasicForm()
}
