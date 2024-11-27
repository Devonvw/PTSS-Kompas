//
//  LandingView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        Image("LogoFull")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
    }
}

#Preview {
    LandingView()
}
