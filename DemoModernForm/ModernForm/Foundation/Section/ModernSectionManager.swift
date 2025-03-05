//
//  ModernSectionManager.swift
//  DemoModernForm
//
//  Created by ChinhNT on 4/3/25.
//

import Combine

// MARK: - Section Collection Manager
/// Class quản lý tập hợp các section trong form
class ModernSectionManager<T: FormData>: ObservableObject {
    // Danh sách các section
    @Published var sections: [ModernSection<T>] = []

    // Thêm section mới
    func addSection(_ section: ModernSection<T>) {
        sections.append(section)
    }

    // Cập nhật section hiện có
    func updateSection(id: String, updater: (inout ModernSection<T>) -> Void) {
        if let index = sections.firstIndex(where: { $0.id == id }) {
            var section = sections[index]
            updater(&section)
            sections[index] = section
        }
    }

    // Xóa section theo ID
    func removeSection(withId id: String) {
        sections.removeAll(where: { $0.id == id })
    }

    // Ẩn/hiện section
    func setVisibility(of sectionId: String, isVisible: Bool) {
        updateSection(id: sectionId) { section in
            section.isVisible = isVisible
        }
    }

    // Sắp xếp lại các section
    func reorderSections(newOrder: [String]) {
        var reorderedSections: [ModernSection<T>] = []

        for id in newOrder {
            if let section = sections.first(where: { $0.id == id }) {
                reorderedSections.append(section)
            }
        }

        // Thêm các section còn lại không có trong newOrder
        let remainingSections = sections.filter { section in
            !newOrder.contains(section.id)
        }

        reorderedSections.append(contentsOf: remainingSections)
        sections = reorderedSections
    }

    // Lấy danh sách các section hiển thị
    var visibleSections: [ModernSection<T>] {
        return sections.filter { $0.isVisible }
    }

    // Lấy tất cả key paths từ tất cả các section
    var allFieldKeyPaths: [PartialKeyPath<T>] {
        return sections.flatMap { $0.fieldKeyPaths }
    }
}

