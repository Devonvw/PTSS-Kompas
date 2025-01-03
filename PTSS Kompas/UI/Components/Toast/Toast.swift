//
//  Toast.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 03/01/2025.
//

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}
