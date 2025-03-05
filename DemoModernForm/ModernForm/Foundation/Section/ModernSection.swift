//
//  ModernSection.swift
//  DemoModernForm
//
//  Created by ChinhNT on 4/3/25.
//

import SwiftUI

// MARK: - Section Model for Forms
/// Model đại diện cho một section trong form
struct ModernSection<T: FormData>: Identifiable {
    // ID duy nhất cho section
    var id: String

    // Tiêu đề section
    var title: String

    // Mô tả thêm (tùy chọn)
    var description: String?

    // Hiển thị section hay không
    var isVisible: Bool = true

    // Danh sách các key path liên kết với các field trong section này
    var fieldKeyPaths: [PartialKeyPath<T>]

    // Tạo content cho section này
    // Ta sử dụng closure để cho phép tùy chỉnh nội dung section
    var content: ((ModernFormManager<T>) -> AnyView)?

    // Khởi tạo với các tham số cơ bản
    init(id: String, title: String, description: String? = nil, isVisible: Bool = true, fieldKeyPaths: [PartialKeyPath<T>] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.isVisible = isVisible
        self.fieldKeyPaths = fieldKeyPaths
    }
}

// MARK: - FormSection+Builders
/// Extension thêm các builder methods để tạo section content dễ dàng hơn
extension ModernSection {
    /// Builder để tạo content cho section
    mutating func setContent(@ViewBuilder _ contentBuilder: @escaping (ModernFormManager<T>) -> some View) {
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
