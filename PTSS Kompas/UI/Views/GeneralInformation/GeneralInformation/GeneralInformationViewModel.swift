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
final class GeneralInformationViewModel: ObservableObject {
    @Published var generalInformation: GeneralInformation?
    @Published var items: [GeneralInformationItem] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var isLoadingItems: Bool = false
    @Published var isFailureItems: Bool = false
    
    private let apiService = GeneralInformationService()
    
    func fetchGeneralInformation(id: String) async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getGeneralInformationById(id: id)
            
            generalInformation = data
            isLoading = false
        } catch {
            isFailure = true
            isLoading = false
            generalInformation = nil
        }
    }
    
    func fetchInitialGeneralInformation(id: String) async {
        isLoadingItems = true
        isFailureItems = false
        
        do {
            let data = try await apiService.getGeneralInformation(cursor: nil, search: nil)
            
            let items = data.data.filter{$0.id != id}
            
            self.items = items
            isLoadingItems = false
        } catch {
            isFailureItems = true
            isLoadingItems = false
        }
    }
}
