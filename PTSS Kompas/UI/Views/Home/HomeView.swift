//
//  HomeView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                EmergencyContactButton().padding(.bottom, 20)
                HStack {
                    Text("Welkom in de groep!").font(.title).layoutPriority(1)
                    Spacer()
                    MembersButton()
                }
                NavigationLink(destination: QuestionnairesView()) {
                    VStack(alignment: .leading) {
                        Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                        Text("Er staat 1 vragenlijst klaar")
                            .font(.headline)
                            .foregroundColor(.dark).fontWeight(.bold)
                    }
                    .padding()
                    .background(.light2)
                    .cornerRadius(8)
                }
                NavigationLink(destination: ContactProfessionalView()) {
                    VStack(alignment: .leading) {
                        Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                        HStack {
                            Text("Vraag de professional")
                                .font(.headline)
                                .foregroundColor(.dark)
                            Spacer()
                            VStack(alignment: .center) {
                                Text("1")
                                Text("Nieuwe reactie")
                            }
                        }
                    }
                    .padding()
                    .background(.light2)
                    .cornerRadius(8)
                }
                Spacer()
            }.padding().navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .toolbar {
                    if let user = authManager.user {
                        NavigationLink(destination: AccountView()) {
                            NameBadge(name: "\(user.firstName) \(user.lastName)", variant: .light)
                        }
                    }
                }
        }
    }
}

#Preview {
    HomeView()
}
