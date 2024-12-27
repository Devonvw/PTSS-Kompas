//
//  ToolsService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 18/12/2024.
//
import Foundation

final class ToolService {
    let baseURL = "tools/"

    func getTools(cursor: String?, sortOrder: String?) async throws -> PaginatedResponse<Tool, Pagination> {
        let parameters: [String: String?] = [
            "cursor": cursor,
            "size": "100",
            "sortOrder": sortOrder
        ]
        return try await NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<Tool, Pagination>.self
        )
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

    func getToolComments(toolId: String, cursor: String?, sortOrder: String?) async throws -> PaginatedResponse<ToolComment, Pagination> {
        let parameters: [String: String?] = [
            "cursor": cursor,
            "size": "100",
            "sortOrder": sortOrder
        ]
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "\(toolId)/comments",
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
