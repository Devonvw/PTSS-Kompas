//
//  GeneralInformationView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import SwiftUI

struct GeneralInformationItemView: View {
    @StateObject var viewModel = GeneralInformationItemViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: GeneralInformationView(item: item)) {
                            GeneralInformationListItem(item: item)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchMoreGeneralInformationItems(generalInformationitem: item)
                                    }
                                }
                        }
                    }
                }
                
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om informatie op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ButtonVariant(label: "Probeer opnieuw"){
                            Task {
                                await viewModel.fetchGeneralInformationItems()
                            }
                        }
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
                }
                else if viewModel.items.isEmpty && viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er is geen informatie beschikbaar")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
                else if viewModel.items.isEmpty && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er informatie gevonden met deze zoekopdracht.")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }.padding()
            .refreshable{Task { await viewModel.refreshGeneralInformationItems()}}
            .searchable(text: $viewModel.searchText, prompt: "Zoeken")
            .navigationTitle("PTSS Info")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    QuestionnairesView()
}
