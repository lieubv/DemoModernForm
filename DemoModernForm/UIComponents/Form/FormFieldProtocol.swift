//
//  FormFieldProtocol.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

// 1. Form Field Protocol - defines what a form field needs
protocol FormFieldProtocol: Identifiable {
    var id: String { get }
    var isRequired: Bool { get }
    var isValid: Bool { get }
    associatedtype InputView: View
    @ViewBuilder func makeInputView() -> InputView
}
