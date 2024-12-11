//
//  QuestionnaireSubQuestion.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//
import Foundation

struct QuestionnaireSubQuestion: Codable, Identifiable {
    let id: String
    let text: String
    let description: String?
    let type: QuestionnaireSubQuestionType
    let answerOptions: [QuestionnaireAnswerOption]
    var answer: String?
    
    static func map(response: QuestionnaireSubQuestionResponse) -> Self {
        return QuestionnaireSubQuestion(id: response.id, text: response.text, description: response.description, type: response.type, answerOptions: response.answerOptions.map { QuestionnaireAnswerOption.map(response: $0) }, answer: response.answer)
    }
    
    static let example: QuestionnaireSubQuestion = .init(
        id: UUID().uuidString,
        text: "Hoe belangrijk is deze behoefte voor u?",
        description: "Beoordeel elke behoefte op een schaal van 1 tot 4, waarbij 1 \"niet belangrijk\" is en 4 \"zeer belangrijk.\" klik het nummer aan dat het beste uw mening weergeeft.",
        type: QuestionnaireSubQuestionType.SINGLE_SELECT,
        answerOptions: QuestionnaireAnswerOption.examples,
        answer: nil
    )
}

enum QuestionnaireSubQuestionType: String, Codable {
    case SINGLE_SELECT
}
