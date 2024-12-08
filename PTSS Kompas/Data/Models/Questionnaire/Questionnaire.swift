//
//  Questionnaire.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 22/11/2024.
//

struct Questionnaire: Codable, Identifiable, ExampleProvidable {
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
        assignedAt: "2024-11-22T11:10:10Z",
        isFinished: false
    )
}
