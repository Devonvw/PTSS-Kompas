//
//  PasswordForgotView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import SwiftUI

struct PasswordForgotView: View {
    @StateObject var store = PasswordForgotStore()

    var body: some View {
        VStack {
            Image("LogoFull")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            VStack {
                Group {
                    switch store.currentScreen {
                    case .Request:
                        PasswordForgotRequestView(passwordForgotStore: store)
                    case .Verify:
                        PasswordForgotVerifyView(passwordForgotStore: store)
                    case .Reset:
                        PasswordForgotResetView(passwordForgotStore: store)
                    }
                }
            }.frame(maxHeight: .infinity)
            Spacer()
        }.padding()
    }
}

#Preview {
    RegisterView()
}
