//
//  RegisterNameViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import Foundation
import Combine
import SwiftUI

final class RegisterNameViewModel: ObservableObject {
    @Published private(set) var error: FormError?
    private let validator = RegisterNameValidator()
    
    func validateName(firstName: String, lastName: String, onSuccess: () -> Void) async {
        do {
            try validator.validate(firstName: firstName, lastName: lastName)
            onSuccess()
        } catch let validationError as RegisterNameValidator.ValidatorError {
            await MainActor.run {
                self.error = .validation(error: validationError)
            }
            print(validationError)
        } catch {
            await MainActor.run {
                self.error = .system(error: error)
            }
            print(error)
        }
    }
}


extension RegisterNameViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterNameViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let err),
                .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

