//
//  RegisterView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var store = RegisterStore()

    var body: some View {
        VStack {
            Image("LogoFull")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            VStack {
                Group {
                    switch store.currentScreen {
                    case .Verify:
                        RegisterVerifyView(registerStore: store)
                    case .Name:
                        RegisterNameView(registerStore: store)
                    case .Password:
                        RegisterPasswordView(registerStore: store)
                    case .Pin:
                        RegisterPinView()
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
