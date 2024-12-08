//
//  ContactService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation

final class ContactService {
    let baseURL = "contact/"
    
    func getContactQuestions(cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<ContactQuestion, Pagination>, NetworkError>) -> Void) {
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ContactQuestion, Pagination>.self,
            completion: completion
        )
    }
    
    func getContactQuestionMessages(questionId: String, cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<ContactQuestionMessage, Pagination>, NetworkError>) -> Void) {
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionId)/messages",
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ContactQuestionMessage, Pagination>.self,
            completion: completion
        )
    }
    
    func addMessage(questionId: String, createMessage: CreateContactQuestionMessage, completion: @escaping (Result<ContactQuestionMessage, NetworkError>) -> Void) {
        let body: [String: String] = ["content": createMessage.content]
        
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionId)/messages",
            method: .POST,
            body: body,
            responseType: ContactQuestionMessage.self,
            completion: completion
        )
    }
    
    func addQuestion(createQuestion: CreateContactQuestion, completion: @escaping (Result<ContactQuestion, NetworkError>) -> Void) {
        let body: [String: String] = ["subject": createQuestion.subject, "content": createQuestion.content]
        
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: body,
            responseType: ContactQuestion.self,
            completion: completion
        )
    }
}
