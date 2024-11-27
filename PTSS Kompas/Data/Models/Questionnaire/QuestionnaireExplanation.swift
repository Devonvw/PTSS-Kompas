//
//  QuestionnaireExplanation.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

struct QuestionnaireExplanation: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let estimatedTimeOfCompletion: String
    let questions: [QuestionnaireSubQuestion]
    
    static let example: QuestionnaireExplanation = .init(
        id: "1",
        title: "Family Needs Questionnaire",
        description: "Familie en vrienden van mensen met hersenletsel hebben vaak specifieke en veranderende behoeften. We willen graag weten hoe belangrijk deze behoeften voor u zijn en of eraan is voldaan, om zo beter inzicht te krijgen in wat gezinnen zoals het uwe nodig hebben. Elke behoeft bestaat uit de volgende 2 vragen.",
        estimatedTimeOfCompletion: "30 minuten",
        questions: [QuestionnaireSubQuestion.example]
    )
}
