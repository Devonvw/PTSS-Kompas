//
//  GeneralInformationViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import Foundation
import Combine
import SwiftUI

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
            
            await MainActor.run {
                self.generalInformation = data
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
                generalInformation = nil
            }
            print("Error: \(error)")
        }
    }

    func fetchInitialGeneralInformation() async {
        isLoadingItems = true
        isFailureItems = false
        
        do {
            let data = try await apiService.getGeneralInformation(cursor: nil, search: nil)
            
            await MainActor.run {
                self.items = data.data
                self.isLoadingItems = false
            }
        } catch {
            await MainActor.run {
                self.isFailureItems = true
                self.isLoadingItems = false
            }
            print("Error: \(error)")
        }
    }
}
