//
//  QuestionnaireGroupResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation

struct QuestionnaireGroupResponse: Codable, Identifiable {
    let id: Int
    let title: String
    let completedQuestions: Int
    let totalQuestions: Int
}
