//
//  GeneralInformationViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class GeneralInformationItemViewModel: ObservableObject {
    @Published var items: [GeneralInformationItem] = []
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
    
    private let apiService = GeneralInformationService()
    
    init() {
        Task {
            await fetchGeneralInformationItems()
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
                    await self?.refreshGeneralInformationItems()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchGeneralInformationItems() async {
        isLoading = true
        await MainActor.run { self.isFailure = false }
        
        if pagination?.nextCursor == nil || pagination?.nextCursor == "" {
            await MainActor.run {
                items = []
            }
        }
        
        do {
            let data = try await apiService.getGeneralInformation(cursor: pagination?.nextCursor, search: debouncedSearchText)
            
            await MainActor.run {
                self.items.append(contentsOf: data.data)
                self.pagination = data.pagination
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
    
    
    func fetchMoreGeneralInformationItems(generalInformationitem: GeneralInformationItem) async {
        guard let lastGeneralInformationItem = items.last, lastGeneralInformationItem.id == generalInformationitem.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchGeneralInformationItems()
    }
    
    func refreshGeneralInformationItems() async {
        pagination = nil
        await fetchGeneralInformationItems()
    }
}
