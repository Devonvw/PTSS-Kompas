//
//  ToolCategoryResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

struct ToolCategoryResponse: Codable {
    let category: String
    let createdAt: String
    let tools: [Tool]
}
