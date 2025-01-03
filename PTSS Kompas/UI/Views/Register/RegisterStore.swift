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
    @Published var email: String = ""
    @Published var registerCode: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
}
