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
            await MainActor.run {
                self.isLoading = false
                self.error = .validation(error: validationError)
            }
            return
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .system(error: error)
            }
            return
        }
        
        do {
            _ = try await apiService.updatePrimaryCaregiverOfCurrentUsersGroup(body: primaryCaregiverAssign)
            
            await MainActor.run {
                self.isLoading = false
                print("Success")
                if let selectedMember {
                    onSuccess(selectedMember)
                }
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .networking(error: error)
                print("Error updating primary caregiver: \(error)")
            }
        } catch {
            await MainActor.run {
                self.isAlertFailure = true
                self.isLoading = false
            }
            print("Error: \(error)")
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

