//
//  EmergencyContactSheet.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import SwiftUI

struct EmergencyContactSheet: View {
    @StateObject var viewModel = EmergencyContactViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer().frame(height: 0)
                Button("Sluiten") {
                    dismiss()
                }.padding()
            }
            Image(systemName: "phone").resizable().frame(width: 60, height: 60)
            
            if viewModel.isFailure {
                VStack(spacing: 16) {
                    Text("Het is niet gelukt om de noodnummers op te halen.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ButtonVariant(label: "Probeer opnieuw"){
                        Task {
                            await viewModel.fetchEmergencyContacts()
                        }
                    }
                }
                .padding()
            }
            else if viewModel.isLoading {
                Loading()
            }
            else {
                ForEach(viewModel.emergencyContacts) { emergencyContact in
                    Text(emergencyContact.name).padding(.top, 10)
                    Button {
                        callPhonenumber(phoneNumber: emergencyContact.phoneNumber)
                    } label: {
                        VStack(alignment: .center) {
                            Spacer().frame(maxHeight: 0)
                            Text(emergencyContact.actionLabel)
                        }
                    }.padding()
                        .background(.white)
                        .cornerRadius(8)
                }
            }
            Spacer()
        }.padding().onAppear {
            Task {
                await viewModel.fetchEmergencyContacts()
            }
        }
    }
}

#Preview {
    EmergencyContactSheet()
}
