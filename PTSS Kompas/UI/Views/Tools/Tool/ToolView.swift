//
//  ToolView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import SwiftUI

struct ToolView: View {
    @StateObject var viewModel = ToolViewModel()

    let tool: Tool
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(tool.name) .font(.headline)
                        .foregroundColor(.dark).fontWeight(.bold)
                    
                    if let media = tool.media {
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
                    
                    Text(tool.description)
                        .font(.body)
                        .foregroundColor(.dark)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.white)
                        .padding(.bottom, 20)
                }
                VStack(alignment: .leading) {
                    Spacer().frame(maxWidth: .infinity, maxHeight: 0)

                    HStack {
                        Text("Opmerkingen").font(.headline)
                            .foregroundColor(.dark)
                        Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                        Button("Nieuw", systemImage: "plus") {
                            viewModel.shouldShowCreate = true
                        }.labelStyle(.iconOnly).padding(8).background(.light2).cornerRadius(20)
                    }
                }
                LazyVStack(alignment: .leading, spacing: 5) {
                    ForEach(viewModel.comments) { comment in
                        ToolCommentItem(comment: comment)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                Task {
                                    await viewModel.fetchMoreToolComments(comment: comment)
                                }
                            }
                    }
                }
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de opmerkingen op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ButtonVariant(label: "Probeer opnieuw"){
                            Task {
                                await viewModel.fetchToolComments(toolId: tool.id)
                            }
                        }
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
                }
                else if viewModel.comments.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn geen opmerkingen gevonden")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }
            
        }.padding()
            .onAppear {
                Task {
//                    await viewModel.fetchToolComments(toolId: tool.id)
                }
            }
            .sheet(isPresented: $viewModel.shouldShowCreate) {
                CreateToolCommentView(tool: tool) {
                    newComment in viewModel.addComment(newComment)
                }
            }
    }
}

#Preview {
    GeneralInformationView(item: GeneralInformationItem.example)
}
