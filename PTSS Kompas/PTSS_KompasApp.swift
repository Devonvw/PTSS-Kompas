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
            if (AuthManager.shared.isLoadingInitial) {
                LandingView()
            }
            else if (AuthManager.shared.isLoggedIn && AuthManager.shared.enteredPin) {
                TabView {
                    Group {
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        ToolsView()
                            .tabItem {
                                Label("Hulpmiddelen", image: "hulpmiddelenIcon")
                            }
                        ChatView()
                            .tabItem {
                                Label("Chat", systemImage: "message")
                            }
                        GeneralInformationItemView()
                            .tabItem {
                                Label("Info", systemImage: "info.circle")
                            }
                        ContactProfessionalView()
                            .tabItem {
                                Label("Contact", systemImage: "person.crop.circle.badge.exclam")
                            }
                    }.toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color.light3, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    
                }.tint(Color.dark)
            }
//            else if (AuthManager.shared.isLoggedIn && AuthManager.shared.user.hasPin && !AuthManager.shared.enteredPin) {
//                LoginPinView()
//            }
            else {
                LoginView()
            }
        }
    }
}
