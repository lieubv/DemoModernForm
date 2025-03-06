//
//  ModernFormManager.swift
//  DemoModernForm
//
//  Created by ChinhNT on 28/2/25.
//

// ModernFormManager.swift

import SwiftUI
import Combine

protocol FormData: Codable {
    static var requiredFields: [String] { get }
}

class ModernFormManager<T: FormData>: ObservableObject {

    // MARK: - Published Properties
    /// Dữ liệu form có kiểu xác định
    @Published var formData: T

    /// Các lỗi validation (key: fieldId, value: error message)
    @Published var errors: [String: String] = [:]

    /// Form có hợp lệ hay không
    @Published var isValid = false

    /// Form đã thay đổi hay chưa
    @Published var hasChanged = false

    /// Form đang được gửi hay không
    @Published var isSubmitting = false


    // MARK: - Section Management
    /// Manager quản lý các section trong form
    @Published var sectionManager = ModernSectionManager<T>()


    // MARK: - Internal Properties
    /// Bản đồ ánh xạ từ KeyPath string sang tên field
    /// Quan trọng: Dùng `internal` thay vì `private` để extension có thể truy cập
    internal var keyPathToFieldName: [String: String] = [:]

    /// Collection của field validators
    internal var validators: [String: (Any) -> String?] = [:]

    /// Cancellables để cleanup
    private var cancellables = Set<AnyCancellable>()


    // MARK: - Initialization
    /// Khởi tạo với dữ liệu form ban đầu
    init(initialData: T) {
        self.formData = initialData

        // Theo dõi thay đổi của dữ liệu form
        $formData
            .dropFirst()
            .sink { [weak self] _ in
                self?.hasChanged = true
                self?.validateForm()
            }
            .store(in: &cancellables)

        // Theo dõi thay đổi của section manager
        sectionManager.$sections
            .sink { [weak self] _ in
                self?.validateForm()
            }
            .store(in: &cancellables)
    }


    // MARK: - Section Management Methods

    /// Thêm section mới vào form
    func addSection(_ section: ModernSection<T>) {
        sectionManager.addSection(section)
    }

    /// Cập nhật section hiện có
    func updateSection(id: String, updater: (inout ModernSection<T>) -> Void) {
        sectionManager.updateSection(id: id, updater: updater)
    }

    /// Xóa section theo ID
    func removeSection(withId id: String) {
        sectionManager.removeSection(withId: id)
    }

    /// Ẩn/hiện section
    func setVisibility(of sectionId: String, isVisible: Bool) {
        sectionManager.setVisibility(of: sectionId, isVisible: isVisible)
    }

    /// Sắp xếp lại các section
    func reorderSections(newOrder: [String]) {
        sectionManager.reorderSections(newOrder: newOrder)
    }

    /// Lấy section theo ID
    func getSection(withId id: String) -> ModernSection<T>? {
        return sectionManager.sections.first(where: { $0.id == id })
    }


    // MARK: - Field Registration Methods

    /// Đăng ký KeyPath với tên field
    /// - Parameters:
    ///   - keyPath: KeyPath dẫn đến thuộc tính
    ///   - fieldName: Tên của field sẽ được sử dụng trong validation và errors
    func registerField<V>(_ keyPath: KeyPath<T, V>, fieldName: String) {
        let keyPathString = String(describing: keyPath)
        keyPathToFieldName[keyPathString] = fieldName
    }

    /// Tạo tên field từ chuỗi keyPath
    /// Ví dụ: "\PersonalInfo.firstName" -> "firstName"
    internal func generateFieldName(from keyPathString: String) -> String {
        // Lấy phần cuối cùng của KeyPath (thường là tên thuộc tính)
        if let lastDotIndex = keyPathString.lastIndex(of: ".") {
            let startIndex = keyPathString.index(after: lastDotIndex)
            return String(keyPathString[startIndex...])
        }
        return keyPathString
    }


    // MARK: - Value Update Methods

    /// Cập nhật giá trị của một field bằng keypath
    /// - Parameters:
    ///   - keyPath: KeyPath dẫn đến thuộc tính cần cập nhật
    ///   - value: Giá trị mới cần gán
    func updateField<V>(_ keyPath: WritableKeyPath<T, V>, value: V) {
        formData[keyPath: keyPath] = value
        hasChanged = true

        // Lấy tên field từ keypath đã đăng ký
        let keyPathString = String(describing: keyPath)
        if let fieldName = keyPathToFieldName[keyPathString] {
            validateField(id: fieldName)
        }

        validateForm()
    }


    // MARK: - Validation Methods

    /// Đăng ký validator cho một field sử dụng ID
    /// - Parameters:
    ///   - id: ID của field
    ///   - validator: Hàm kiểm tra tính hợp lệ, trả về message lỗi hoặc nil nếu hợp lệ
    func registerValidator<V>(id: String, validator: @escaping (V) -> String?) {
        validators[id] = { value in
            guard let typedValue = value as? V else {
                return "Invalid type"
            }
            return validator(typedValue)
        }
    }

    /// Đăng ký validator bằng keypath
    /// - Parameters:
    ///   - keyPath: KeyPath dẫn đến thuộc tính cần kiểm tra
    ///   - validator: Hàm kiểm tra tính hợp lệ, trả về message lỗi hoặc nil nếu hợp lệ
    func registerValidator<V>(for keyPath: KeyPath<T, V>, validator: @escaping (V) -> String?) {
        let keyPathString = String(describing: keyPath)
        if let fieldName = keyPathToFieldName[keyPathString] {
            registerValidator(id: fieldName, validator: validator)
        } else {
            // Tự động đăng ký field nếu chưa được đăng ký
            let fieldName = generateFieldName(from: keyPathString)
            registerField(keyPath, fieldName: fieldName)
            registerValidator(id: fieldName, validator: validator)
        }
    }

    /// Validate một field cụ thể
    /// - Parameter id: ID của field cần validate
    func validateField(id: String) {
        guard let validator = validators[id],
              let value = getValue(for: id) else {
            return
        }

        if let errorMessage = validator(value) {
            errors[id] = errorMessage
        } else {
            errors.removeValue(forKey: id)
        }
    }

    /// Validate toàn bộ form
    func validateForm() {
        // Lặp qua tất cả validators đã đăng ký
        for id in validators.keys {
            validateField(id: id)
        }

        // Kiểm tra các trường bắt buộc
        for field in T.requiredFields {
            if getValue(for: field) == nil {
                errors[field] = "This field is required"
            }
        }

        isValid = errors.isEmpty
    }

    // MARK: - Helper Methods

    /// Lấy giá trị của một field theo tên
    /// - Parameter id: ID (tên) của field
    /// - Returns: Giá trị của field hoặc nil nếu không tìm thấy
    internal func getValue(for id: String) -> Any? {
        let mirror = Mirror(reflecting: formData)

        for child in mirror.children {
            if child.label == id {
                return child.value
            }
        }

        return nil
    }

    /// Lấy giá trị của một thuộc tính bằng keyPath
    func getValue<V>(for keyPath: KeyPath<T, V>) -> V {
        return formData[keyPath: keyPath]
    }

    // MARK: - Form Actions

    /// Reset form về trạng thái ban đầu
    /// - Parameter data: Dữ liệu mới để reset form (tùy chọn)
    func resetForm(with data: T? = nil) {
        if let data = data {
            formData = data
        }
        errors = [:]
        hasChanged = false
        validateForm()
    }

    /// Submit form
    /// - Parameter onSuccess: Callback được gọi khi form hợp lệ
    func submitForm(onSuccess: @escaping (T) -> Void) {
        validateForm()

        guard isValid else { return }

        isSubmitting = true

        // Giả lập delay mạng
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 giây

            onSuccess(self.formData)
            isSubmitting = false
        }
    }
}

// MARK: - Extension for KeyPath Helper Methods
extension ModernFormManager {
    /// Lấy tên field từ keypath
    /// - Parameter keyPath: KeyPath dẫn đến thuộc tính
    /// - Returns: Tên field đã đăng ký hoặc nil nếu chưa đăng ký
    func getFieldName<V>(for keyPath: KeyPath<T, V>) -> String? {
        let keyPathString = String(describing: keyPath)
        return keyPathToFieldName[keyPathString]
    }

    // Using explicit generic parameter declaration
    func getFieldName(for keyPath: PartialKeyPath<T>) -> String? {
        let keyPathString = String(describing: keyPath)
        return keyPathToFieldName[keyPathString]
    }
}
