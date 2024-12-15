//
//  ChatMessage.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

struct ChatMessage: Codable, Identifiable, ExampleProvidable {
    let id: String
    let senderName: String
    let senderId: String
    let content: String
    let sentAt: String
    
    static let example: ChatMessage = .init(
        id: "1",
        senderName: "Joost",
        senderId: "123123",
        content: "This is an example message",
        sentAt: "2024-11-22T11:10:10Z"
    )
}
