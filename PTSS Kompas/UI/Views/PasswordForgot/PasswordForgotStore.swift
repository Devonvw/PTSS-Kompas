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
    case Reset
}

@MainActor
final class PasswordForgotStore: ObservableObject {
    @Published var currentScreen: PasswordForgotScreens = .Request
    @Published var code: String = "222222"
    @Published var email: String = "devon@gmail.com"
    @Published var password: String = "Wachtwoord#1"
    @Published var repeatPassword: String = "Wachtwoord#1"
}
