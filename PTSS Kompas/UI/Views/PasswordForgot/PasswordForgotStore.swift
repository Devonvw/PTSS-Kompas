//
//  PasswordForgotViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import Foundation
import Combine
import SwiftUI

enum PasswordForgotScreens {
    case Request
    case Verify
    case Password
}

@MainActor
final class PasswordForgotStore: ObservableObject {
    @Published var currentScreen: PasswordForgotScreens = .Verify
    @Published var code: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
}
