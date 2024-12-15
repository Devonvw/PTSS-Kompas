//
//  QuestionnaireQuestion.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//

struct QuestionnaireQuestion: Codable, Identifiable {
    let id: Int
    let isFinished: Bool
    let situation: String
    var subQuestions: [QuestionnaireSubQuestion]
    
    static func map(response: QuestionnaireQuestionResponse) -> Self {
        return QuestionnaireQuestion(id: response.id, isFinished: response.isFinished, situation: response.situation, subQuestions: response.subQuestions.map { QuestionnaireSubQuestion.map(response: $0) })
    }
    
    static let example: QuestionnaireQuestion = .init(
        id: 1,
        isFinished: false,
        situation: "Ik heb behoefte dat men mij toont dat mijn meningen worden gebruikt bij planning van de behandeling, revalidatie en educatie van de patiënt.",
        subQuestions: [QuestionnaireSubQuestion.example]
    )
    
    static let examples: [QuestionnaireQuestion] = [
        .example,
        .init(
            id: 2,
            isFinished: false,
            situation: "Ik heb behoefte dat men mij toont dat mijn meningen worden gebruikt bij planning van de behandeling, revalidatie en educatie van de patiënt.",
            subQuestions: [QuestionnaireSubQuestion.example]
        )
    ]
}
