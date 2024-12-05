//
//  SaveQuestionAnswersRequest.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct SaveQuestionAnswerRequest: Codable, Identifiable {
    let id: String
    let answer: String
}
