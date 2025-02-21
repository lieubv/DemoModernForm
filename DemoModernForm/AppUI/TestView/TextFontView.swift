//
//  TextFontView.swift
//  DemoModernForm
//
//  Created by ChinhNT on 20/2/25.
//

import SwiftUI

struct TextFontView: View {
    var body: some View {
        Text("largeTitle")
            .font(.largeTitle)
            .foregroundColor(.indigo)

        Text("title")
            .font(.title)
            .foregroundColor(.indigo)

        Text("title2")
            .font(.title2)
            .foregroundColor(.indigo)

        Text("title3")
            .font(.title3)
            .foregroundColor(.indigo)

        Text("headline")
            .font(.headline)
            .foregroundColor(.indigo)

        Text("subheadline")
            .font(.subheadline)
            .foregroundColor(.indigo)

        Text("body")
            .font(.body)
            .foregroundColor(.indigo)

        Text("callout")
            .font(.callout)
            .foregroundColor(.indigo)

        Text("footnote")
            .font(.footnote)
            .foregroundColor(.indigo)

        Text("caption")
            .font(.caption)
            .foregroundColor(.indigo)

        Text("caption2")
            .font(.caption2)
            .foregroundColor(.indigo)

    }
}

#Preview {
    TextFontView()
}
