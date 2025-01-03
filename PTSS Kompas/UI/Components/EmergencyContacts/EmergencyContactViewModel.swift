//
//  EmergencyContactViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class EmergencyContactViewModel: ObservableObject {
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = EmergencyContactsService()
    
    func fetchEmergencyContacts() async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getEmergencyContacts()
            
            await MainActor.run {
                self.emergencyContacts = data
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
                self.emergencyContacts = []
            }
            print("Error: \(error)")
        }
    }

}
