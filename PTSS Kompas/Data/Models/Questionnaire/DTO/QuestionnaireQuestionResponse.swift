//
//  QuestionnaireQuestionResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 11/12/2024.
//

struct QuestionnaireQuestionResponse: Codable, Identifiable {
    let id: String
    let isFinished: Bool
    let situation: String
    var subQuestions: [QuestionnaireSubQuestionResponse]
}
