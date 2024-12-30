//
//  GeneralInformationService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import Foundation

final class GeneralInformationService {
    let baseURL = "general-information/"

    func getGeneralInformation(cursor: String? = nil, search: String?) async throws -> PaginatedResponse<GeneralInformationItem, Pagination> {
        let parameters: [String: String?] = [
            "size": "50",
            "cursor": cursor,
            "search": search
        ]
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "general-information",
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<GeneralInformationItem, Pagination>.self
        )
    }

    func getGeneralInformationById(id: String) async throws -> GeneralInformation {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "general-information/\(id)",
            method: .GET,
            responseType: GeneralInformation.self
        )
    }
}
