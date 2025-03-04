//
//  TypeSafeSectionedForm.swift
//  DemoModernForm
//
//  Created by ChinhNT on 4/3/25.
//

import SwiftUI

// MARK: - TypeSafeSectionedForm
/// Form container với hỗ trợ quản lý section động
/// Đây là phiên bản nâng cấp của `TypeSafeForm`
struct TypeSafeSectionedForm<T: FormData>: View {
    // MARK: - Properties
    /// Tiêu đề form
    let title: String

    /// Form manager instance
    @ObservedObject var formManager: TypeSafeFormManager<T>

    /// Xử lý submit form
    let onSubmit: (T) -> Void

    /// State cho thông báo thành công
    @State private var showingSuccessMessage = false

    // MARK: - Initialization
    init(
        title: String,
        initialData: T,
        onSubmit: @escaping (T) -> Void
    ) {
        self.title = title
        self._formManager = ObservedObject(wrappedValue: TypeSafeFormManager(initialData: initialData))
        self.onSubmit = onSubmit
    }

    // Khởi tạo với form manager có sẵn
    init(
        title: String,
        formManager: TypeSafeFormManager<T>,
        onSubmit: @escaping (T) -> Void
    ) {
        self.title = title
        self._formManager = ObservedObject(wrappedValue: formManager)
        self.onSubmit = onSubmit
    }

    // MARK: - Body
    var body: some View {
        Form {
            // Form title section
            if !title.isEmpty {
                Section(header: Text(title).font(.headline)) {
                    EmptyView()
                }
            }

            // Render visible sections
            ForEach(formManager.sectionManager.visibleSections) { section in
                Section(
                    header: Text(section.title).font(.subheadline),
                    footer: section.description.map { Text($0).font(.caption) }
                ) {
                    // Nếu section có content tùy chỉnh, sử dụng nó
                    if let content = section.content {
                        content(formManager)
                    }
                }
            }

            // Submit button section
            Section {
                Button(action: {
                    formManager.submitForm { data in
                        onSubmit(data)
                        showingSuccessMessage = true
                    }
                }) {
                    HStack {
                        Spacer()
                        if formManager.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Submit")
                        }
                        Spacer()
                    }
                }
                .disabled(!formManager.isValid || formManager.isSubmitting)
                .padding()
                .background(formManager.isValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .disabled(formManager.isSubmitting)
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("Success"),
                message: Text("Form submitted successfully"),
                dismissButton: .default(Text("OK")) {
                    formManager.resetForm()
                }
            )
        }
    }
}

// MARK: - FormSection+Builders
/// Extension thêm các builder methods để tạo section content dễ dàng hơn
extension FormSection {
    /// Builder để tạo content cho section
    mutating func setContent(@ViewBuilder _ contentBuilder: @escaping (TypeSafeFormManager<T>) -> some View) {
        self.content = { formManager in
            AnyView(contentBuilder(formManager))
        }
    }

    /// Thêm field vào section
    mutating func addField<V>(_ keyPath: KeyPath<T, V>) {
        self.fieldKeyPaths.append(keyPath)
    }

    /// Thêm nhiều field vào section
    mutating func addFields(_ keyPaths: [PartialKeyPath<T>]) {
        self.fieldKeyPaths.append(contentsOf: keyPaths)
    }
}
