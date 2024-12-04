//
//  Message.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

import SwiftUI

enum MessageType {
    case left
    case right
}

struct Message: View {
    let title: String
    let content: String
    let date: String
    let type: MessageType
    
    var body: some View {
        HStack {
            if type == .right {
                Spacer().frame(maxWidth: UIScreen.main.bounds.width * 0.2, maxHeight: 0)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.dark)
                Text(content)
                    .font(.body)
                    .foregroundColor(.dark)
                HStack {
                    Spacer()
                    Text(formatDate(from: date, to: "dd-MM-yyyy"))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.dark)
                }
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            }.padding()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .background(type == .left ? Color.light2 : Color.white)
                .cornerRadius(5, corners: [.bottomLeft, .bottomRight, type == .left ? .topRight : .topLeft])
            if type == .left {
                Spacer().frame(maxWidth: UIScreen.main.bounds.width * 0.2, maxHeight: 0)
            }
        }
    }
}

#Preview {
    VStack {
        Message(title: "test", content: "test", date: "2024-10-30T12:34:56Z", type: MessageType.right)
        Message(title: "test2", content: "test2", date: "2024-10-30T12:34:56Z", type: MessageType.left)
        
    }
}
