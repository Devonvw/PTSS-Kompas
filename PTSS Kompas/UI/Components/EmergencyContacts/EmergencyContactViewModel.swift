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
            
            emergencyContacts = data
            isLoading = false
        } catch {
            isFailure = true
            isLoading = false
            emergencyContacts = []
        }
    }
    
}
