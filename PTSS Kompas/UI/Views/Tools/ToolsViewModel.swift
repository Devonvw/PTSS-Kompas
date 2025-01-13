//
//  ToolsViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class ToolsViewModel: ObservableObject {
    @Published var categories: [ToolCategory] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var searchText = "" {
        didSet {
            if (searchText != oldValue) {
                searchTextSubject.send(searchText)
            }
        }
    }
    @Published var pagination: Pagination?
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var debouncedSearchText = ""
    @Published var shouldShowCreate = false

    private let apiService = ToolService()
    
    init() {
        Task {
            await fetchToolCategories()
        }
        debounceSearchText()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                Task {
                    await self?.refreshToolCategories()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchToolCategories() async {
        isLoading = true
        await MainActor.run { self.isFailure = false }
        
        do {
            let data = try await apiService.getTools(search: debouncedSearchText)
            
            await MainActor.run {
                self.categories.append(contentsOf: data)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
            }
            print("Error: \(error)")
        }
    }
    
    
    func fetchMoreCategories(category: ToolCategory) async {
        guard let lastCategory = categories.last, lastCategory.id == category.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchToolCategories()
    }
    
    func refreshToolCategories() async {
        pagination = nil
        await fetchToolCategories()
    }
}
