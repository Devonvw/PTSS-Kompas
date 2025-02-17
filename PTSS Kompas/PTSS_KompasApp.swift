//
//  PTSS_KompasApp.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

@main
struct PTSS_KompasApp: App {
    @StateObject private var toastManager = ToastManager.shared
    @StateObject private var authManager = AuthManager.shared

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!, .foregroundColor: UIColor(.dark)]
        UITabBar.appearance().unselectedItemTintColor = UIColor.red
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            if (authManager.isLoadingInitial) {
                LandingView()
            }
            else if (authManager.isLoggedIn && authManager.enteredPin) {
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
                    
                }.tint(Color.dark).toastView(toast: Binding(
                    get: { toastManager.toast },
                    set: { newValue in
                        toastManager.toast = newValue
                    }))
            }
            else if (authManager.isLoggedIn && authManager.hasPin && !authManager.enteredPin) {
                LoginPinView()
            }
            else {
                LoginView().toastView(toast: Binding(
                    get: { toastManager.toast },
                    set: { newValue in
                        toastManager.toast = newValue
                    }))
            }
        }
    }
}
