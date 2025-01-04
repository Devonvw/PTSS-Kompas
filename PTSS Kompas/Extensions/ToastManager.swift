//
//  ToastManager.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/01/2025.
//
import Foundation

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var toast: Toast?
}
