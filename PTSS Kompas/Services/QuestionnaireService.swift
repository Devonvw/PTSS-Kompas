//
//  QuestionnaireService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation

final class QuestionnaireService {
    let baseURL = "questionnaires/"
    
    func getQuestionnaires(cursor: String?, search: String?) async throws -> PaginatedResponse<Questionnaire, Pagination> {
        let parameters: [String: String?] = ["cursor": cursor, "size": "50", "search": search]
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<Questionnaire, Pagination>.self
        )
    }
    
    func getQuestionnaireExplanation(questionnaireId: String) async throws -> QuestionnaireExplanation {
        let response = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/explanation",
            method: .GET,
            responseType: QuestionnaireExplanationResponse.self
        )
        return QuestionnaireExplanation.map(response: response)
    }
    
    func getQuestionnaireGroups(questionnaireId: String) async throws -> [QuestionnaireGroup] {
        let response = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups",
            method: .GET,
            responseType: [QuestionnaireGroupResponse].self
        )
        return response.map { QuestionnaireGroup.map(response: $0) }
    }
    
    func getQuestionnaireQuestions(questionnaireId: String, groupId: Int) async throws -> [QuestionnaireQuestion] {
        let response = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups/\(groupId)/questions",
            method: .GET,
            responseType: [QuestionnaireQuestionResponse].self
        )
        return response.map { QuestionnaireQuestion.map(response: $0) }
    }
    
    func saveQuestionAnswers(questionnaireId: String, groupId: Int, questionId: Int, answers: [SaveQuestionAnswerRequest]) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups/\(groupId)/questions/\(questionId)",
            method: .PUT,
            body: answers,
            responseType: VoidResponse.self
        )
    }
}
