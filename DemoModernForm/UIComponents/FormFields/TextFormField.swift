//
//  TextFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 19/2/25.
//

import SwiftUI

// 4. Specialized Form Fields
struct TextFormField: FormFieldProtocol {
    var base: BaseFormField<TextField<Text>>
    @Binding var text: String

    init(
        id: String,
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        isRequired: Bool = false,
        validationRules: [ValidationRule] = []
    ) {
        self.base = BaseFormField(
            id: id,
            label: label,
            placeholder: placeholder,
            isRequired: isRequired,
            validationRules: validationRules
        ) {
            TextField(placeholder, text: text)
        }
        self._text = text
    }

    var id: String { base.id }
    var isRequired: Bool { base.isRequired }

    var isValid: Bool {
        if isRequired && text.isEmpty {
            return false
        }

        for rule in base.validationRules {
            if !rule.validate(text) {
                return false
            }
        }

        return true
    }

    func makeInputView() -> some View {
        VStack(alignment: .leading) {
            Text(base.label)
                .font(.caption)
                .foregroundColor(.secondary)

            base.makeInputView()
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if !isValid {
                Text(getErrorMessage())
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func getErrorMessage() -> String {
        if isRequired && text.isEmpty {
            return "This field is required"
        }

        for rule in base.validationRules {
            if !rule.validate(text) {
                return rule.errorMessage
            }
        }

        return ""
    }
}
