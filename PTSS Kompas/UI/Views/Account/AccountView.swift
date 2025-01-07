//
//  ProfileView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import SwiftUI

struct AccountView: View {
    @StateObject var viewModel = AccountViewModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                
                Text("Informatie").font(.title2).layoutPriority(1)
                if let user = AuthManager.shared.user {
                    Text("Voornaam").font(.subheadline)
                    Text(user.firstName).padding(.bottom, 6).fontWeight(.bold)
                    Text("Achternaam").font(.subheadline)
                    Text(user.lastName).padding(.bottom, 6).fontWeight(.bold)
                    Text("Email").font(.subheadline)
                    Text(user.email).fontWeight(.bold)
                }
                
                Text("Leden").font(.title2).layoutPriority(1).padding(.top, 20)
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de leden op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ButtonVariant(label: "Probeer opnieuw"){
                            Task {
                                await viewModel.fetchMembers()
                            }
                        }
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
                }
                else {
                    
                    Text("Patient").font(.headline).layoutPriority(1).padding(.top, 4)
                    if let patient = viewModel.patient {
                        VStack(alignment: .leading) {
                            Text("\(patient.firstName) \(patient.lastName)").font(.subheadline).fontWeight(.bold)
                            Text(patient.email)
                        }
                    }
                    HStack(alignment: .center) {
                        Text("Hoofdmantelzorger").font(.headline).layoutPriority(1)
                        Spacer().frame(maxHeight: 0)
                        Button("Aanpassen", systemImage: "pencil") {
                            viewModel.showUpdateAlert = true
                        }.labelStyle(.iconOnly).padding(4)
                    }.padding(.top, 8)
                    if let primaryCaregiver = viewModel.primaryCaregiver {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text("\(primaryCaregiver.firstName) \(primaryCaregiver.lastName)").font(.subheadline).fontWeight(.bold)
                                Text(primaryCaregiver.email)
                            }
                            
                        }
                    } else {
                        VStack(spacing: 16) {
                            Text("Er is geen hoofdmantelzorger!")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    }
                    
                    Text("Familieleden").font(.headline).layoutPriority(1).padding(.top, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.members) { member in
                            VStack {
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading) {
                                        Text("\(member.firstName) \(member.lastName)").font(.subheadline).fontWeight(.bold)
                                        Text(member.email)
                                    }.layoutPriority(1)
                                    Spacer().frame(maxHeight: 0)
                                    Button("Verwijderen", systemImage: "xmark.circle") {
                                        viewModel.selectedMember = member
                                        viewModel.showDeleteAlert = true
                                    }.labelStyle(.iconOnly).padding(8).foregroundColor(.red)
                                }
                                
                                Divider()
                            }
                        }
                    }
                    if viewModel.members.isEmpty {
                        VStack(spacing: 16) {
                            Text("Er zijn nog geen leden!")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    }
                    ButtonVariant(label: "Nieuw lid uitnodigen") {
                        viewModel.showInviteAlert = true
                    }.padding(.bottom, 16)
                }
                ButtonVariant(label: "Pincode wijzigen", iconRight: "arrow.right") {
                    viewModel.showUpdatePinAlert = true
                }
                ButtonVariant(label: "Wachtwoord wijzigen", iconRight: "arrow.right") {
                    viewModel.showUpdatePasswordAlert = true
                }
                
                Spacer().frame(maxWidth: .infinity)
            }.padding()
                    .navigationTitle("Account")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationViewStyle(StackNavigationViewStyle()).onAppear {
                        Task {
                            await viewModel.fetchMembers()
                        }
                    }
                    .alert(isPresented: $viewModel.showDeleteAlert) {
                        Alert(
                            title: Text("Verwijderen"),
                            message: Text("Weet u zeker dat u deze gebruiker wilt verwijderen?"),
                            primaryButton: .destructive(Text("Verwijderen")) {
                                if let member = viewModel.selectedMember {
                                    Task {
                                        await viewModel.deleteMember(member)
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }.sheet(isPresented: $viewModel.showUpdateAlert) {
                        ZStack {
                            Color.light3.edgesIgnoringSafeArea(.all)
                            EditPrimaryCaregiverView(currentPrimaryCaregiver: viewModel.primaryCaregiver, members: viewModel.allMembers) { newPrimaryCaregiver in
                                viewModel.primaryCaregiver = newPrimaryCaregiver
                                Task {
                                    await viewModel.fetchMembers()
                                }
                            }
                        }
                    }.sheet(isPresented: $viewModel.showInviteAlert) {
                        ZStack {
                            Color.light3.edgesIgnoringSafeArea(.all)
                            InviteMemberView() {
                                Task {
                                    await viewModel.fetchMembers()
                                }
                            }
                        }
                    }.sheet(isPresented: $viewModel.showUpdatePinAlert) {
                        ZStack {
                            Color.light3.edgesIgnoringSafeArea(.all)
                            UpdatePinView() {
                                
                            }
                        }
                    }.sheet(isPresented: $viewModel.showUpdatePasswordAlert) {
                        ZStack {
                            Color.light3.edgesIgnoringSafeArea(.all)
                            UpdatePasswordView() {
                                
                            }
                        }
                    }
            }
        }
        
    }
}

#Preview {
    AccountView()
}
