//
//  View.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 03/01/2025.
//

import SwiftUI

extension View {
  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
