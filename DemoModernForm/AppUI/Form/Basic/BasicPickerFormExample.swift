//
//  BasicPickerFormExample.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

struct BasicPickerFormExample: View {
    @State private var selectedColor: FavoriteColor?
    @State private var selectedSkills: Set<Skill> = []
    @State private var showValidationMessages = false

    var body: some View {
        ReusableForm(
            title: "Profile Preferences",
            onSubmit: submitForm
        ) {
            // Single selection picker
            PickerFormField(
                id: "favoriteColor",
                label: "Favorite Color",
                placeholder: "Choose a color",
                isRequired: true,
                options: FavoriteColor.allCases,
                optionLabels: FavoriteColor.allCases.reduce(into: [:]) { dict, color in
                    dict[color] = color.displayName
                },
                selectedOption: $selectedColor
            ).makeInputView()

            // Multi-selection picker
            MultiPickerFormField(
                id: "skills",
                label: "Skills",
                placeholder: "Select your skills",
                isRequired: true,
                validationRules: [
                    .minCount(2), // Require at least 2 skills
                    .maxCount(4)  // Allow at most 4 skills
                ],
                options: Skill.allSkills,
                optionLabels: Skill.allSkills.reduce(into: [:]) { dict, skill in
                    dict[skill] = skill.name
                },
                selectedOptions: $selectedSkills
            ).makeInputView()
        }
        .navigationTitle("Basic Picker Example")
        .alert(isPresented: $showValidationMessages) {
            Alert(
                title: Text("Validation Error"),
                message: Text("Please fix the errors in the form before submitting."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func submitForm() {
        // Validate fields
        let isColorValid = selectedColor != nil
        let isSkillsValid = !selectedSkills.isEmpty &&
                            selectedSkills.count >= 2 &&
                            selectedSkills.count <= 4

        if isColorValid && isSkillsValid {
            print("Form submitted successfully!")
            print("Selected color: \(selectedColor?.displayName ?? "None")")
            print("Selected skills: \(selectedSkills.map { $0.name }.joined(separator: ", "))")

            // Here you would typically save data or call an API
        } else {
            showValidationMessages = true
        }
    }
}

// MARK: - Preview providers
struct BasicPickerFormExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BasicPickerFormExample()
        }
    }
}
