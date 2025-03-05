//
//  ProfileSectionedFormExample.swift
//  DemoModernForm
//
//  Created by ChinhNT on 4/3/25.
//

import SwiftUI

// MARK: - Mô hình dữ liệu Form
struct ProfileFormData: FormData {
    // Thông tin cá nhân
    var firstName: String = ""
    var lastName: String = ""
    var birthDate: Date = Date()

    // Thông tin liên hệ
    var email: String = ""
    var phone: String = ""

    // Thông tin công việc
    var company: String = ""
    var position: String = ""
    var yearsOfExperience: Int = 0

    // Thông tin khác
    var bio: String = ""
    var skills: [Skill] = []
    var favoriteColor: FavoriteColor = .blue

    static var requiredFields: [String] {
        return ["firstName", "lastName", "email"]
    }
}

// MARK: - View sử dụng Section Form
struct ProfileSectionedFormExample: View {
    // Quản lý form với dữ liệu khởi tạo
    @StateObject private var formManager = TypeSafeFormManager(initialData: ProfileFormData())

    // Đánh dấu thông tin công việc có hiển thị hay không
    @State private var showWorkInfo = true

    var body: some View {
        NavigationView {
            TypeSafeSectionedForm(
                title: "Edit Profile",
                formManager: formManager,
                onSubmit: { data in
                    print("Form submitted with data:")
                    print("Name: \(data.firstName) \(data.lastName)")
                    print("Email: \(data.email)")
                }
            )
            .onAppear {
                setupFormSections()
            }
            .navigationTitle("Profile Form")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(showWorkInfo ? "Hide Work Info" : "Show Work Info") {
                        toggleWorkSection()
                    }
                }
            }
        }
    }

    // Thiết lập các section cho form
    private func setupFormSections() {
        // 1. Section thông tin cá nhân
        var personalSection = FormSection<ProfileFormData>(
            id: "personal",
            title: "Personal Information",
            description: "Basic information about you"
        )

        personalSection.setContent { formManager in
            VStack {
                // First Name
                TypeSafeTextField(
                    keyPath: \.firstName,
                    label: "First Name",
                    placeholder: "Enter your first name",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.minLength(2)]
                )

                // Last Name
                TypeSafeTextField(
                    keyPath: \.lastName,
                    label: "Last Name",
                    placeholder: "Enter your last name",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.minLength(2)]
                )

                // Tại đây ta có thể thêm DatePicker cho birthDate...
            }
        }

        // 2. Section thông tin liên hệ
        var contactSection = FormSection<ProfileFormData>(
            id: "contact",
            title: "Contact Information",
            description: "How we can reach you"
        )

        contactSection.setContent { formManager in
            VStack {
                // Email
                TypeSafeTextField(
                    keyPath: \.email,
                    label: "Email Address",
                    placeholder: "you@example.com",
                    formManager: formManager,
                    isRequired: true,
                    validationRules: [.email()],
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    autocapitalization: .never
                )

                // Phone
                TypeSafeTextField(
                    keyPath: \.phone,
                    label: "Phone Number",
                    placeholder: "Your phone number",
                    formManager: formManager,
                    keyboardType: .phonePad
                )
            }
        }

        // 3. Section thông tin công việc (có thể ẩn/hiện)
        var workSection = FormSection<ProfileFormData>(
            id: "work",
            title: "Work Information",
            description: "Your professional details",
            isVisible: showWorkInfo
        )

        workSection.setContent { formManager in
            VStack {
                // Company
                TypeSafeTextField(
                    keyPath: \.company,
                    label: "Company",
                    placeholder: "Company name",
                    formManager: formManager
                )

                // Position
                TypeSafeTextField(
                    keyPath: \.position,
                    label: "Position",
                    placeholder: "Your job title",
                    formManager: formManager
                )

                // Ở đây có thể thêm Stepper cho yearsOfExperience...
            }
        }

        // Thêm các section vào form manager
        formManager.addSection(personalSection)
        formManager.addSection(contactSection)
        formManager.addSection(workSection)
    }

    // Ẩn/hiện section thông tin công việc
    private func toggleWorkSection() {
        showWorkInfo.toggle()
        formManager.setVisibility(of: "work", isVisible: showWorkInfo)
    }
}

// Preview provider
struct ProfileSectionedFormExample_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSectionedFormExample()
    }
}
