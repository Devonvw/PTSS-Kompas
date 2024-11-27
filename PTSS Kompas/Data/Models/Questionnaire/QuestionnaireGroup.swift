//
//  QuestionnaireGroup.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//
import Foundation

struct QuestionnaireGroup: Codable, Identifiable {
    let id: String
    let title: String
    let isFinished: Bool
    let questionsLeft: Int
    let questionsCount: Int
    
    static let example: QuestionnaireGroup = .init(
        id: UUID().uuidString,
        title: "Behandelplanning en Besluitvorming",
        isFinished: false,
        questionsLeft: 4,
        questionsCount: 4
    )
}
