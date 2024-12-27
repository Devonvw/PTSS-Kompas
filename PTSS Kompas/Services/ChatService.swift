//
//  ChatService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

import Foundation

final class ChatService {
    let baseURL = "groups/messages/"
    
    func getChatMessages(pageDirection: PageDirection?, cursor: String?, search: String?) async throws -> PaginatedResponse<ChatMessage, BiDirectionalPagination> {
        let parameters: [String: String?] = [
            "direction": pageDirection?.rawValue,
            "cursor": cursor,
            "size": "100",
            "search": search
        ]
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ChatMessage, BiDirectionalPagination>.self
        )
    }
    
    func addMessage(createMessage: CreateChatMessage) async throws -> ChatMessage {
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: createMessage,
            responseType: ChatMessage.self
        )
    }
}

