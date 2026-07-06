//
//  Event.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 06/07/26.
//

import Foundation
import SwiftData
 
@Model
final class Events {
    var name: String
    var bib: String
    var date: Date
 
    init(name: String, bib: String, date: Date) {
        self.name = name
        self.bib = bib
        self.date = date
    }
 
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
        return formatter.string(from: date) + " WIB"
    }
}
