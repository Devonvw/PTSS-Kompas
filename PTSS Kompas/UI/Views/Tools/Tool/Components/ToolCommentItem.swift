//
//  ToolComment.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/12/2024.
//

import SwiftUI


struct ToolCommentItem: View {
    let comment: ToolComment
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            Text("\(comment.SenderName) - \(formatDate(from: comment.createdAt, to: "dd-MM-yyyy"))")
                .font(.headline)
                .foregroundColor(.dark)
            Text(comment.content)
                .font(.body)
                .foregroundColor(.dark)
        }.padding()
            .background(Color.light2)
            .cornerRadius(5, corners: [.bottomLeft, .bottomRight, .topRight])
    }
}

#Preview {
    VStack {
        ToolCommentItem(comment: ToolComment.example)
    }
}
