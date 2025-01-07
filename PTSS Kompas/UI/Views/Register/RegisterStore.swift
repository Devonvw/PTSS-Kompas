//
//  RegisterViewController.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import Foundation
import Combine
import SwiftUI

enum RegisterScreens {
    case Verify
    case Name
    case Password
    case Pin
}

@MainActor
final class RegisterStore: ObservableObject {
    @Published var currentScreen: RegisterScreens = .Verify
    @Published var email: String = "devon@gmail.com"
    @Published var registerCode: String = "222222"
    @Published var firstName: String = "Jan"
    @Published var lastName: String = "Jan"
    @Published var password: String = "Wachtwoord#1"
    @Published var repeatPassword: String = "Wachtwoord#1"
    
    public func setCurrentScreen(_ screen: RegisterScreens) {
        currentScreen = screen
    }
}
