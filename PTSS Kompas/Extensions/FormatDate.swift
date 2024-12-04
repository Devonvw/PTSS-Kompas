//
//  FormatDate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

import Foundation

func formatDate(from dateString: String, to format: String) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    
    if let date = isoDateFormatter.date(from: dateString) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    } else {
        return dateString
    }
}
