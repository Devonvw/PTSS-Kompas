//
//  QuestionnaireQuestionResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 11/12/2024.
//

struct QuestionnaireQuestionResponse: Codable, Identifiable {
    let id: Int
    let isFinished: Bool
    let situation: String
    var subQuestions: [QuestionnaireSubQuestionResponse]
}
