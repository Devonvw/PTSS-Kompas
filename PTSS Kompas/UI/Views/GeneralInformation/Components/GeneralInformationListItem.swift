//
//  QuestionnaireListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 26/11/2024.
//

import SwiftUI

struct GeneralInformationListItem: View {
    let item: GeneralInformationItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
                .foregroundColor(.dark)
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }
        .padding()
        .background(.light2)
        .cornerRadius(8)
    }
}

#Preview {
    GeneralInformationListItem(item: GeneralInformationItem.example)
}
