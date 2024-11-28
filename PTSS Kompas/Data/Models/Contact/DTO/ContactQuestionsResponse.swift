//
//  ContactQuestionResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct ContactQuestionsResponse: Codable {
    let questions: [ContactQuestion]
    let pagination: Pagination
}

