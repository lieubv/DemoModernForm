//
//  FormFieldProtocol.swift
//  DemoModernForm
//
//  Created by ChinhNT on 18/2/25.
//

import SwiftUI

protocol FormFieldProtocol: Identifiable {
    var id: String { get }
    var isRequired: Bool { get }
    var isValid: Bool { get }
    associatedtype InputView: View
    @ViewBuilder func makeInputView() -> InputView
}
