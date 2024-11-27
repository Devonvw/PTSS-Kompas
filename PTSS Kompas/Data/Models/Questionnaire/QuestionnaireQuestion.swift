//
//  QuestionnaireQuestion.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//

struct QuestionnaireQuestion: Codable {
    let situation: String
    let subQuestions: [QuestionnaireSubQuestion]
    let order: Int
    
    static let example: QuestionnaireQuestion = .init(
        situation: "Ik heb behoefte dat men mij toont dat mijn meningen worden gebruikt bij planning van de behandeling, revalidatie en educatie van de patiënt.",
        subQuestions: [QuestionnaireSubQuestion.example],
        order: 1
    )
}
