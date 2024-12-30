//
//  EmergencyContact.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import SwiftUI

struct EmergencyContactButton: View {
    @State private var showSheet = false
    
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            HStack {
                Text("Direct hulp nodig? Bel met het noodnummer.").multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "phone").frame(width: 24, height: 24)
            }
        }.padding()
            .background(.yellow)
            .cornerRadius(8)
            .sheet(isPresented: $showSheet) {
                ZStack {
                    Color.yellow.edgesIgnoringSafeArea(.all)
                    EmergencyContactSheet()
                }
            }
    }
}

#Preview {
    EmergencyContactButton()
}
