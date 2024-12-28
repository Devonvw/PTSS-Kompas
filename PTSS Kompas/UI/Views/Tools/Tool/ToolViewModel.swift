//
//  ToolViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import Foundation
import Combine
import SwiftUI

final class ToolViewModel: ObservableObject {
    @Published var comments: [ToolComment] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var searchText = "" {
        didSet {
            if (searchText != oldValue) {
                searchTextSubject.send(searchText)
            }
        }
    }
    @Published var newCommentContent: String = ""
    @Published var pagination: Pagination?
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var debouncedSearchText = ""
    private var toolId: String?
    
    private let apiService = ToolService()
    
    init() {
        debounceSearchText()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                Task {
                    await self?.refreshToolComments()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchToolComments(toolId: String) async {
        isLoading = true
        isFailure = false
        self.toolId = toolId

        if pagination?.nextCursor == nil || pagination?.nextCursor == "" {
            comments = []
        }

        do {
            let data = try await apiService.getToolComments(toolId: toolId, cursor: pagination?.nextCursor)
            
            await MainActor.run {
                comments.append(contentsOf: data.data)
                pagination = data.pagination
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                isFailure = true
            }
            print("Error: \(error)")
        }
    }

    
    func fetchMoreToolComments(comment: ToolComment) async {
        guard let toolId else { return }
        
        guard let lastComment = comments.last, lastComment.id == comment.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchToolComments(toolId: toolId)
    }
    
    
    func refreshToolComments() async {
        guard let toolId else { return }
        
        pagination = nil
        await fetchToolComments(toolId: toolId)
    }
    
    func addComment(content: String) async {
        guard let toolId else { return }
        
        do {
            let newComment = try await apiService.addToolComment(toolId: toolId, comment: CreateToolComment(content: content))
            
            await MainActor.run {
                comments.append(newComment)
                newCommentContent = ""
            }
        } catch {
            await MainActor.run {
                isFailure = true
            }
            print("Error adding message: \(error)")
        }
    }

}

