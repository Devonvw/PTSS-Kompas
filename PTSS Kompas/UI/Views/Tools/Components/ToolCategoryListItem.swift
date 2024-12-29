//
//  ToolCategoryListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import SwiftUI

struct ToolCategoryListItem: View {
    let category: ToolCategory
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $isExpanded) {
                LazyVStack(alignment: .leading, spacing: 4) {
                    Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                    ForEach(category.tools) { tool in
                        NavigationLink(destination: ToolView(tool: tool)) {
                            ToolListItem(tool: tool)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            } label: {
                Text("\(category.category) (\(category.tools.count))")
                    .font(.headline)
                    .foregroundColor(.dark).multilineTextAlignment(.leading)
            }
        }
        .padding()
    }
}

#Preview {
    ToolCategoryListItem(category: ToolCategory.example)
}
