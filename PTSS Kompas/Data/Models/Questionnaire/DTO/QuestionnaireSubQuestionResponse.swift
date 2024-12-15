//
//  QuestionnaireSubQuestionResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 11/12/2024.
//

import Foundation

struct QuestionnaireSubQuestionResponse: Codable, Identifiable {
    let id: Int
    let text: String
    let description: String?
    let type: QuestionnaireSubQuestionType
    let answerOptions: [QuestionnaireAnswerOptionResponse]
    var answer: String?
}
