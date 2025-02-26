//
//  ManagedDatePicker.swift
//  DemoModernForm
//
//  Created by ChinhNT on 26/2/25.
//

import SwiftUI

struct ManagedDatePicker: View {
    let id: String
    let label: String
    @ObservedObject var formManager: FormManager
    let isRequired: Bool

    @State private var date = Date()

    init(
        id: String,
        label: String,
        formManager: FormManager,
        isRequired: Bool = false
    ) {
        self.id = id
        self.label = label
        self.formManager = formManager
        self.isRequired = isRequired

        // Đăng ký validator
        formManager.registerValidator(id: id) { (value: Date) -> String? in
            // Thêm xác thực ngày tháng ở đây nếu cần
            return nil
        }
    }

    var body: some View {
        ManagedFormField(
            id: id,
            formManager: formManager,
            isRequired: isRequired,
            label: {
                Text(label)
            },
            input: {
                DatePicker("", selection: $date)
                    .labelsHidden()
                    .onChange(of: date) { newValue in
                        formManager.updateField(id: id, value: newValue)
                    }
                    .onAppear {
                        formManager.updateField(id: id, value: date)
                    }
            }
        )
    }
}

#Preview {
    ManagedDatePicker(id: "picker", label: "Date Picker", formManager: FormManager())
}
