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
    let answerOptions: [QuestionnaireSubQuestionAnswerOption]
    var answer: String?
    
    static let example: QuestionnaireSubQuestion = .init(
        id: UUID().uuidString,
        text: "Hoe belangrijk is deze behoefte voor u?",
        description: "Beoordeel elke behoefte op een schaal van 1 tot 4, waarbij 1 \"niet belangrijk\" is en 4 \"zeer belangrijk.\" klik het nummer aan dat het beste uw mening weergeeft.",
        type: QuestionnaireSubQuestionType.SINGLE_SELECT,
        answerOptions: QuestionnaireSubQuestionAnswerOption.examples,
        answer: nil
    )
}

enum QuestionnaireSubQuestionType: String, Codable {
    case SINGLE_SELECT
}

struct QuestionnaireSubQuestionAnswerOption: Codable, Identifiable {
    let id: String
    let value: String
    let label: String
    let description: String?
    
    static let example: QuestionnaireSubQuestionAnswerOption = .init(
        id: UUID().uuidString,
        value: "1",
        label: "1",
        description: "Niet belangrijk"
    )
    
    static let examples: [QuestionnaireSubQuestionAnswerOption] = [
        .example,
        .init(
            id: UUID().uuidString,
            value: "2",
            label: "2",
            description: "Matig belangrijk"
        ),
        .init(
            id: UUID().uuidString,
            value: "3",
            label: "3",
            description: "Belangrijk"
        ),
        .init(
            id: UUID().uuidString,
            value: "4",
            label: "4",
            description: "Zeer belangrijk"
        ),
    ]
}
