//
//  BaseFormField.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

struct BaseFormField<Input: View>: FormFieldProtocol {
    let id: String
    let isRequired: Bool
    let label: String
    let placeholder: String
    let validationRules: [ValidationRule]
    var errorMessage: String = ""

    // Custom input view generator provided at initialization
    private let inputViewBuilder: () -> Input

    var isValid: Bool {
        if !isRequired && errorMessage.isEmpty {
            return true
        }
        return errorMessage.isEmpty
    }

    init(
        id: String,
        label: String,
        placeholder: String = "",
        isRequired: Bool = false,
        validationRules: [ValidationRule] = [],
        @ViewBuilder inputViewBuilder: @escaping () -> Input
    ) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.inputViewBuilder = inputViewBuilder
    }


    func makeInputView() -> Input {
        inputViewBuilder()
    }
}
