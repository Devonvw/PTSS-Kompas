//
//  Button.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

enum ButtonVariants {
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

struct ButtonVariant<Label: View>: View {
    private let label: Label?
    let iconRight: String?
    let iconLeft: String?
    let disabled: Bool
    let variant: ButtonVariants
    let action: () -> Void
    
    init(
        @ViewBuilder label: () -> Label,
        variant: ButtonVariants = .dark,
        disabled: Bool = false,
        iconRight: String? = nil,
        iconLeft: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label()
        self.iconRight = iconRight
        self.iconLeft = iconLeft
        self.action = action
        self.disabled = disabled
        self.variant = variant
    }
    
    init(
        variant: ButtonVariants = .dark,
        disabled: Bool = false,
        iconRight: String? = nil,
        iconLeft: String? = nil,
        action: @escaping () -> Void
    ) where Label == EmptyView {
        self.init(
            label: { EmptyView() },
            variant: variant,
            disabled: disabled,
            iconRight: iconRight,
            iconLeft: iconLeft,
            action: action
        )
    }
    
    init(
        label: String,
        variant: ButtonVariants = .dark,
        disabled: Bool = false,
        iconRight: String? = nil,
        iconLeft: String? = nil,
        action: @escaping () -> Void
    ) where Label == Text {
        self.init(
            label: { Text(label).fontWeight(.semibold) },
            variant: variant,
            disabled: disabled,
            iconRight: iconRight,
            iconLeft: iconLeft,
            action: action
        )
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let iconLeft {
                    Image(systemName: iconLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                if let label {
                    label
                }
                if let iconRight {
                    Image(systemName: iconRight)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .font(.title3)
            .padding(.vertical, 12)
            .foregroundColor(disabled ? Color.gray.opacity(0.2) : variant.foregroundColor)
            .frame(maxWidth: .infinity)
            .background(disabled ? Color.gray.opacity(0.2) : variant.backgroundColor)
            .cornerRadius(8)
        }.disabled(disabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        ButtonVariant(label: "Dark Variant", variant: .dark) {}
        ButtonVariant(label: "Light Variant", variant: .light) {}
        ButtonVariant(label: "Disabled", variant: .dark, disabled: true) {}
    }
    .padding()
}
