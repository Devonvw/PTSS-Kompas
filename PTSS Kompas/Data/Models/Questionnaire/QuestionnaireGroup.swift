//
//  QuestionnaireGroup.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//
import Foundation

struct QuestionnaireGroup: Codable, Identifiable {
    let id: Int
    let title: String
    let isFinished: Bool
    let completedQuestions: Int
    let totalQuestions: Int
    
    static func map(response: QuestionnaireGroupResponse) -> Self {
        return QuestionnaireGroup(id: response.id, title: response.title, isFinished: response.completedQuestions == response.totalQuestions, completedQuestions: response.completedQuestions, totalQuestions: response.totalQuestions)
    }
    
    static let example: QuestionnaireGroup = .init(
        id: 1,
        title: "Behandelplanning en Besluitvorming",
        isFinished: true,
        completedQuestions: 0,
        totalQuestions: 2
    )
}
