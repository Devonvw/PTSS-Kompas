//
//  ToolListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import SwiftUI

struct ToolListItem: View {
    let tool: Tool
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            Text(tool.name)
                .font(.headline)
                .foregroundColor(.dark)
        }
        .padding()
        .background(.light2)
        .cornerRadius(8)
    }
}

#Preview {
    ToolListItem(tool: Tool.example)
}
