//
//  ReadOnlyField.swift
//  DemoModernForm
//
//  Created by Alex on 7/3/25.
//

import SwiftUI

struct ReadOnlyField: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}
