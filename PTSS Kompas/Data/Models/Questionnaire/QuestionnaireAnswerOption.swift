//
//  QuestionnaireAnswerOption.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 11/12/2024.
//
import Foundation

struct QuestionnaireAnswerOption: Codable, Identifiable {
    let id: String
    let value: String
    let label: String
    let description: String?
    
    static func map(response: QuestionnaireAnswerOptionResponse) -> Self {
        return QuestionnaireAnswerOption(id: response.value, value: response.value, label: response.label, description: response.description)
    }
    
    static let example: QuestionnaireAnswerOption = .init(
        id: UUID().uuidString,
        value: "1",
        label: "1",
        description: "Niet belangrijk"
    )
    
    static let examples: [QuestionnaireAnswerOption] = [
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
