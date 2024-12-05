//
//  PTSS_KompasApp.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

@main
struct PTSS_KompasApp: App {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!, .foregroundColor: UIColor(.dark)]
        UITabBar.appearance().unselectedItemTintColor = UIColor.red
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Group {
                    ContactProfessionalView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    ToolsView()
                        .tabItem {
                            Label("Hulpmiddelen", image: "hulpmiddelenIcon")
                        }
                    QuestionnairesView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    HomeView()
                        .tabItem {
                            Label("Home2", systemImage: "house")
                        }
                }.toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.light3, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    
            }.tint(Color.dark)
        }
    }
}
