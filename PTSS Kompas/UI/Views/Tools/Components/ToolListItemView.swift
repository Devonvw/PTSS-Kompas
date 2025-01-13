//
//  ToolListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import SwiftUI

struct ToolListItemView: View {
    let toolListItem: ToolListItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            HStack {
                Text(toolListItem.name)
                    .font(.headline)
                    .foregroundColor(.dark).layoutPriority(1)
                Spacer()
                if let createdBy = toolListItem.createdBy {
                    NameBadge(name: createdBy, variant: .dark)
                }
            }
        }
        .padding()
        .background(toolListItem.createdBy != nil ? .light1 : .light2)
        .cornerRadius(8)
    }
}

#Preview {
    ToolListItemView(toolListItem: ToolListItem.example)
}
