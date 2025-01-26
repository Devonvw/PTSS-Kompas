//
//  EditPrimaryCaregiverViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 31/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class EditPrimaryCaregiverViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var selectedMember: User?
    
    private let apiService = UserService()
    private let validator = EditPrimaryCaregiverValidator()
    private var toastManager = ToastManager.shared
    
    func setInitialPrimaryCaregiver(primaryCaregiver: User?, members: [User]) {
        if let primaryCaregiver {
            selectedMember = primaryCaregiver
        } else {
            selectedMember = members.filter { $0.role != .Patient}.first
        }
    }
    
    func editPrimaryCaregiver(onSuccess: (User) -> Void) async {
        let primaryCaregiverAssign = PrimaryCaregiverAssign(userId: selectedMember?.id ?? "")
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(primaryCaregiverAssign)
        } catch let validationError as EditPrimaryCaregiverValidator.CreateValidatorError {
            isLoading = false
            self.error = .validation(error: validationError)
            return
        } catch {
            isLoading = false
            isAlertFailure = true
            self.error = .system(error: error)
            return
        }
        
        do {
            _ = try await apiService.updatePrimaryCaregiverOfCurrentUsersGroup(body: primaryCaregiverAssign)
            
            isLoading = false
            if let selectedMember {
                onSuccess(selectedMember)
            }
            toastManager.toast = Toast(style: .success, message: "De hoofdmantelzorger is succesvol gewijzigd")
        } catch let error as NetworkError {
            isLoading = false
            isAlertFailure = true
            self.error = .networking(error: error)
        } catch {
            isAlertFailure = true
            isLoading = false
        }
    }
}


extension EditPrimaryCaregiverViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension EditPrimaryCaregiverViewModel.FormError {
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

