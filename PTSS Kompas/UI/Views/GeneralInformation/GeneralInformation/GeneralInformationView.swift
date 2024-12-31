//
//  GeneralInformationView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

import SwiftUI

struct GeneralInformationView: View {
    @StateObject var viewModel = GeneralInformationViewModel()
    
    let item: GeneralInformationItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(item.title) .font(.headline)
                        .foregroundColor(.dark).fontWeight(.bold)
                    
                    if viewModel.isFailure {
                        VStack(spacing: 16) {
                            Text("Het is niet gelukt om deze informatie op te halen.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            ButtonVariant(label: "Probeer opnieuw"){
                                Task {
                                    await viewModel.fetchGeneralInformation(id: item.id)
                                }
                            }
                        }
                        .padding()
                    }
                    else if viewModel.isLoading && viewModel.generalInformation == nil {
                        Loading()
                    }
                    
                    if let generalInformation = viewModel.generalInformation {
                        if let media = generalInformation.media {
                            AsyncImage(url: URL(string: media.url)) { phase in
                                switch phase {
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                case .success(let image):
                                    if let href = media.href, let url = URL(string: href) {
                                        Link(destination: url) {
                                            image
                                                .resizable()
                                        }
                                    } else {
                                        image
                                            .resizable()
                                    }
                                default:
                                    ProgressView().frame(maxWidth: .infinity, minHeight: 256)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 256)
                            .clipShape(.rect(cornerRadius: 25))
                        }
                        
                        Text(generalInformation.content)
                            .font(.body)
                            .foregroundColor(.dark)
                            .fixedSize(horizontal: false, vertical: true)
                            .background(Color.white)
                            .padding(.bottom, 16)
                    }
                    
                    Text("Lees meer over:") .font(.headline)
                        .foregroundColor(.dark)
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.items) { item in
                            NavigationLink(destination: GeneralInformationView(item: item)) {
                                GeneralInformationListItem(item: item)
                                    .frame(maxWidth: .infinity)
                                
                            }
                        }
                    }
                    if viewModel.isFailure {
                        VStack(spacing: 16) {
                            Text("Het is niet gelukt om andere informatie op te halen.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            ButtonVariant(label: "Probeer opnieuw"){
                                Task {
                                    await viewModel.fetchInitialGeneralInformation()
                                }
                            }
                        }
                        .padding()
                    }
                    else if viewModel.isLoading {
                        Loading()
                    }
                    else if viewModel.items.isEmpty {
                        VStack(spacing: 16) {
                            Text("Er is geen andere informatie beschikbaar")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    }
                }
            }
            
        }.padding()
            .onAppear {
                Task {
                    await viewModel.fetchGeneralInformation(id: item.id)
                    await viewModel.fetchInitialGeneralInformation()
                }
            }
    }
}

#Preview {
    GeneralInformationView(item: GeneralInformationItem.example)
}
