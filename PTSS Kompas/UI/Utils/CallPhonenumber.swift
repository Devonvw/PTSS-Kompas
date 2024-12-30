//
//  CallPhonenumber.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//
import Foundation
import UIKit

public func callPhonenumber(phoneNumber:String) {
  if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
    let application:UIApplication = UIApplication.shared
    if (application.canOpenURL(phoneCallURL)) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
    }
  }
}
