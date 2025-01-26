//
//  EmergencyContactsService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

//
//  ContentService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import Foundation

final class EmergencyContactsService {
    let baseURL = "emergency-contacts/"

    func getEmergencyContacts() async throws -> [EmergencyContact] {
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            responseType: [EmergencyContact].self
        )
    }
}
