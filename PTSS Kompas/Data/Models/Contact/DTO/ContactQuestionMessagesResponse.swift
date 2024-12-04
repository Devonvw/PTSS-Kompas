//
//  ContactQuestionMessagesResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct ContactQuestionMessagesResponse: Codable {
    let data: [ContactQuestionMessage]
    let pagination: Pagination
}

