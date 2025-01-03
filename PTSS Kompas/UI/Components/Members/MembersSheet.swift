//
//  MembersSheet.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import SwiftUI

struct MembersSheet: View {
    @StateObject var viewModel = MembersViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer().frame(height: 0)
                Button("Sluiten") {
                    dismiss()
                }.padding()
            }
            Text("Leden").font(.title2)
            
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
                VStack {
                    
                    ForEach(viewModel.members) { member in
                        VStack(alignment: .leading) {
                            Text("\(member.firstName) \(member.lastName)").fontWeight(.bold)
                            Text("Laatst online: \(formatDate(from: member.lastSeen, to: "HH:mm, dd-MM-yyyy"))")
                            Divider()
                        }
                    }
                }

            }
            Spacer()
        }.padding().onAppear {
            Task {
                await viewModel.fetchMembers()
            }
        }
    }
}

#Preview {
    EmergencyContactSheet()
}
