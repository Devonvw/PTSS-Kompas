//
//  QuestionnaireExplanation.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

struct QuestionnaireExplanation: Codable {
    let subQuestions: [QuestionnaireSubQuestion]
    
    static func map(response: QuestionnaireExplanationResponse) -> Self {
        return QuestionnaireExplanation(subQuestions: response.subQuestions.map { QuestionnaireSubQuestion.map(response: $0) })
    }

    
    static let example: QuestionnaireExplanation = .init(
        subQuestions: [QuestionnaireSubQuestion.example]
    )
}
