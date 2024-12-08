//
//  ChatService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

import Foundation

final class ChatService {
    let baseURL = "groups/messages/"
    
    func getChatMessages(pageDirection: PageDirection?, cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<ContactQuestion>, NetworkError>) -> Void) {
        let parameters: [String: String?] = ["direction": pageDirection?.rawValue, "cursor": cursor, "pageSize": "100", "search": search]
        
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ContactQuestion>.self,
            completion: completion
        )
    }
    
    func addMessage(questionId: String, createMessage: CreateChatMessage, completion: @escaping (Result<ChatMessage, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: createMessage,
            responseType: ChatMessage.self,
            completion: completion
        )
    }

}
