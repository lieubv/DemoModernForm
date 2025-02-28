//
//  ManagedPickerFormExample.swift
//  DemoModernForm
//
//  Created by ChinhNT on 27/2/25.
//

import SwiftUI

struct ManagedPickerFormExample: View {
    @State private var selectedDays: Set<DayOfWeek> = []

    var body: some View {
        ManagedForm(
            title: "Schedule Preferences",
            onSubmit: { data in
                // FormManager will only call onSubmit when all validations pass
                print("Form submitted successfully!")

                if let color = data["favoriteColor"] as? FavoriteColor {
                    print("Selected color: \(color.displayName)")
                }

                if let skills = data["skills"] as? Set<Skill> {
                    print("Selected skills: \(skills.map { $0.name }.joined(separator: ", "))")
                }

                if let days = data["availableDays"] as? Set<DayOfWeek> {
                    print("Available days: \(days.map { $0.rawValue }.joined(separator: ", "))")
                }
            }
        ) { formManager in
            // Single selection managed picker
            ManagedPickerField(
                id: "favoriteColor",
                label: "Favorite Color",
                placeholder: "Choose a color",
                formManager: formManager,
                isRequired: true,
                options: FavoriteColor.allCases,
                optionLabels: FavoriteColor.allCases.reduce(into: [:]) { dict, color in
                    dict[color] = color.displayName
                }
            )

            // Multi-selection managed picker
            ManagedMultiPickerField(
                id: "skills",
                label: "Skills",
                placeholder: "Select your skills",
                formManager: formManager,
                isRequired: true,
                options: Skill.allSkills,
                optionLabels: Skill.allSkills.reduce(into: [:]) { dict, skill in
                    dict[skill] = skill.name
                },
                minSelections: 2,
                maxSelections: 4
            )

            // Custom days-of-week picker
            ManagedMultiPickerField(
                id: "availableDays",
                label: "Available Days",
                placeholder: "Select days you're available",
                formManager: formManager,
                isRequired: true,
                options: DayOfWeek.allCases,
                optionLabels: DayOfWeek.allCases.reduce(into: [:]) { dict, day in
                    dict[day] = day.rawValue
                },
                minSelections: 1
            )
        }
        .navigationTitle("Advanced Picker Example")
    }
}

struct ManagedPickerFormExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManagedPickerFormExample()
        }
    }
}
