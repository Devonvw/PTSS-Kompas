//
//  MembersButton.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

//
//  MembersSheet.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import SwiftUI

struct MembersButton: View {
    @State private var showSheet = false
    
    var body: some View {
        Button("Leden", systemImage: "person.3") {
            showSheet = true
        }.labelStyle(.iconOnly).padding(8).sheet(isPresented: $showSheet) {
            ZStack {
                Color.light1.edgesIgnoringSafeArea(.all)
                MembersSheet()
            }
        }
    }
}

#Preview {
    MembersButton()
}
