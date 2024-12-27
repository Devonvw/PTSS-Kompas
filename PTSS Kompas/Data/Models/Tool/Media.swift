//
//  Media.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct Media: Codable, Identifiable, ExampleProvidable {
    let id: String
    let url: String
    let href: String?
    
    static let example: Media = .init(
        id: "media-1",
        url: "https://images.unsplash.com/photo-1733317817195-36b3a6473dd3?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        href: "https://www.youtube.com/watch?v=BY9Y5RBexxI"
    )
}

