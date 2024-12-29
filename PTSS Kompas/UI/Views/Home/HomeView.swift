//
//  HomeView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Welkom in de groep!")
                Spacer().frame(height: 0)
                Button("Leden", systemImage: "group") {
                    
                }.labelStyle(.iconOnly).padding(8)
                
            }
            VStack(alignment: .leading) {
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                Text("Er staat 1 vragenlijst klaar")
                    .font(.headline)
                    .foregroundColor(.dark).fontWeight(.bold)
            }
            .padding()
            .background(.light2)
            .cornerRadius(8)
            
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
            Spacer()
        }.padding()
    }
}

#Preview {
    HomeView()
}
