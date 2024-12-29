//
//  ToolsService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 18/12/2024.
//
import Foundation

final class ToolService {
    let baseURL = "tools/"

    func getTools(search: String?) async throws -> [ToolCategory] {
        let parameters: [String: String?] = [
            "search": search
        ]

        let response = try await NetworkManager.shared.request(
            endpoint: baseURL + "categories",
            method: .GET,
            parameters: parameters,
            responseType: [ToolCategoryResponse].self
        )
        
        return response.map { ToolCategory.map(response: $0) }
    }

    func getToolById(toolId: String) async throws -> Tool {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)",
            method: .GET,
            responseType: Tool.self
        )
    }

    func createTool(tool: CreateTool) async throws -> Tool {
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: tool,
            responseType: Tool.self
        )
    }

    func deleteTool(toolId: String) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)",
            method: .DELETE,
            responseType: VoidResponse.self
        )
    }

    func getToolComments(toolId: String, cursor: String?) async throws -> PaginatedResponse<ToolComment, Pagination> {
        let parameters: [String: String?] = [
            "cursor": cursor,
            "size": "50",
        ]
        print(baseURL + "\(toolId)/comments")
        
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "9e52b2b1-6a89-4d99-a1d4-2956c7383d88/comments",
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<ToolComment, Pagination>.self
        )
    }

    func addToolComment(toolId: String, comment: CreateToolComment) async throws -> ToolComment {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)/comments",
            method: .POST,
            body: comment,
            responseType: ToolComment.self
        )
    }

    func deleteToolComment(toolId: String, commentId: String) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)/comments/\(commentId)",
            method: .DELETE,
            responseType: VoidResponse.self
        )
    }

    func deleteToolMedia(toolId: String, mediaId: String) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)/media/\(mediaId)",
            method: .DELETE,
            responseType: VoidResponse.self
        )
    }
}
