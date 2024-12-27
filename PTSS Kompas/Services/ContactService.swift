//
//  ContactService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation

final class ContactService {
    let baseURL = "contact/"
    
    func getContactQuestions(cursor: String?, search: String?) async throws -> PaginatedResponse<ContactQuestion, Pagination> {
        let parameters: [String: String?] = ["cursor": cursor, "size": "100", "search": search]
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ContactQuestion, Pagination>.self
        )
    }
    
    func getContactQuestionMessages(questionId: String, cursor: String?, search: String?) async throws -> PaginatedResponse<ContactQuestionMessage, Pagination> {
        let parameters: [String: String?] = ["cursor": cursor, "size": "100", "search": search]
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionId)/messages",
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ContactQuestionMessage, Pagination>.self
        )
    }
    
    func addMessage(questionId: String, createMessage: CreateContactQuestionMessage) async throws -> ContactQuestionMessage {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "\(questionId)/messages",
            method: .POST,
            body: createMessage,
            responseType: ContactQuestionMessage.self
        )
    }
    
    func addQuestion(createQuestion: CreateContactQuestion) async throws -> ContactQuestion {
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: createQuestion,
            responseType: ContactQuestion.self
        )
    }
}

