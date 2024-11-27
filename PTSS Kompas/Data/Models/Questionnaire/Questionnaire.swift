//
//  Questionnaire.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//

struct Questionnaire: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let estimatedTimeOfCompletion: String
    let assignedAt: String
    let isFinished: Bool
    
    static let example: Questionnaire = .init(
        id: "1",
        title: "Example questionnaire",
        description: "This is an example questionnaire",
        estimatedTimeOfCompletion: "1 hour",
        assignedAt: "202-11-22T1:10:10Z",
        isFinished: false
    )
}
