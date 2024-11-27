//
//  NavigationTitleColor.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 26/11/2024.
//
import SwiftUI

extension View {
    @available(iOS 14, *)
    func navigationTitleAppearance(
        color: Color,
        font: UIFont,
        largeFont: UIFont
    ) -> some View {
        let uiColor = UIColor(color)
        
        // Configure UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground() // Keeps the top bar transparent
        appearance.titleTextAttributes = [
            .foregroundColor: uiColor,
            .font: UIFont(name: "Georgia-Bold", size: 20)!
        ]
        appearance.largeTitleTextAttributes = [
//            .foregroundColor: uiColor,
            .font: UIFont(name: "Georgia-Bold", size: 20)!
        ]
        
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return self
    }
}
