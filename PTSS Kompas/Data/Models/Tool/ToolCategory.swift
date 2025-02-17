//
//  ToolCategory.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct ToolCategory: Codable, Identifiable, Hashable, ExampleProvidable {
    let id: String
    let category: String
    let createdAt: String
    let tools: [ToolListItem]
    
    static func map(response: ToolCategoryResponse) -> Self {
        return ToolCategory(id: response.category, category: response.category, createdAt: response.createdAt, tools: response.tools)
    }
    
    static let example: ToolCategory = .init(
        id: "category-1",
        category: "5-4-3-2-1 Methode",
        createdAt: "2024-01-01T10:00:00Z",
        tools: [
            ToolListItem.example
        ]
    )
    
    static let examples: [ToolCategory] = [.example,
                                           .init(
                                            id: "category-2",
                                            category: "5-4-3-2-1 Methode 2",
                                            createdAt: "2024-01-01T10:00:00Z",
                                            tools: [
                                                ToolListItem.example
                                            ]
                                           ),
                                           .init(
                                            id: "category-3",
                                            category: "5-4-3-2-1 Methode 3",
                                            createdAt: "2024-01-01T10:00:00Z",
                                            tools: [
                                                ToolListItem.example
                                            ]
                                           )
    ]
}
