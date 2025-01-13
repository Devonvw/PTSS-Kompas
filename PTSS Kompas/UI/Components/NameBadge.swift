//
//  NameBadge.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 13/01/2025.
//

import SwiftUI

enum NameBadgeVariants {
    case dark
    case light
    
    var foregroundColor: Color {
        switch self {
        case .dark:
            return .tan
        case .light:
            return .dark
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light3
        }
    }
}

struct NameBadge: View {
    let name: String
    let variant: NameBadgeVariants

    private var initials: String {
        let words = name.split(separator: " ")
        let firstTwoInitials = words.prefix(2).compactMap { $0.first }.map { String($0) }
        return firstTwoInitials.joined()
    }

    var body: some View {
        Text(initials)
            .textCase(.uppercase)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(6)
            .foregroundColor(variant.foregroundColor)
            .background(variant.backgroundColor)
            .clipShape(Circle())
    }
}

#Preview {
    NameBadge(name: "Pricilla van Simons", variant: .light)
}
