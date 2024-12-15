//
//  ContactQuestion.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct ContactQuestion: Codable, Identifiable, ExampleProvidable {
    let id: String
    let subject: String
    let content: String
    let createdAt: String
    let newAnswer: Bool
    let isClosed: Bool
    
    static let example: ContactQuestion = .init(
        id: "1",
        subject: "Omgaan met dissociatie tijdens een herbeleving?",
        content: "Wat kan ik concreet doen of zeggen als mijn naaste tijdens een herbeleving dissocieert, bijvoorbeeld als ze starend voor zich uit kijken en niet reageren op mijn aanwezigheid? Hoe kan ik hen op een veilige manier helpen weer contact te maken met de omgeving zonder zelf in paniek te raken of hen te overprikkelen?",
        createdAt: "2024-11-22T11:10:10Z",
        newAnswer: true,
        isClosed: false
    )
}
