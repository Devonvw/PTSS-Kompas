//
//  ToolsView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import SwiftUI

struct ToolsView: View {
    @StateObject var viewModel = ToolsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Button("Nieuw", systemImage: "plus") {
                    viewModel.shouldShowCreate = true
                }.labelStyle(.iconOnly).padding(8).background(.light2).cornerRadius(20)
                LazyVStack(spacing: 4) {
                    ForEach(viewModel.categories) { category in
                        ToolCategoryListItem(category: category)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                Task {
                                    await viewModel.fetchMoreCategories(category: category)
                                }
                            }
                    }
                }
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de hulpmiddelen op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ButtonVariant(label: "Probeer opnieuw"){
                            Task {
                                await viewModel.fetchToolCategories()
                            }
                        }
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
                }
                else if viewModel.categories.isEmpty && viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn geen hulpmiddelen!")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
                else if viewModel.categories.isEmpty && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn geen hulpmiddelen gevonden met deze zoekopdracht.")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }
            .refreshable{Task { await viewModel.refreshToolCategories()}}
            .searchable(text: $viewModel.searchText, prompt: "Zoeken")
            .navigationTitle("Hulpmiddelen")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $viewModel.shouldShowCreate) {
                CreateToolView() {
                    newTool in
                    Task {
                        await viewModel.refreshToolCategories()
                    }
                }
            }
        }
    }
}

#Preview {
    QuestionnairesView()
}
