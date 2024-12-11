//
//  Loading.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 11/12/2024.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        VStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(height: 120)
                .padding(4)
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }
    }
}

#Preview {
    Loading()
}
