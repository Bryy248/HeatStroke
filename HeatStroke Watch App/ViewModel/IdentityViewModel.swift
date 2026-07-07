//
//  IdentityViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI
import Observation

@Observable
final class IdentityViewModel {
    var bib: String = ""
    var birthDate: Date = Date()
    var hasBirthDate = false

    var showBIBKeyboard = false
    var showDatePicker = false
    var goToConfirm = false

    let event: Event
    init(event: Event) {
        self.event = event
    }
    var eventName: String { event.name }

    // validasi format sebelum lanjut: bib nggak kosong & birth date udah dipilih
    var canConfirm: Bool {
        !bib.trimmingCharacters(in: .whitespaces).isEmpty && hasBirthDate
    }

    func confirm() {
        guard canConfirm else { return }
        goToConfirm = true
    }

    func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }
}
