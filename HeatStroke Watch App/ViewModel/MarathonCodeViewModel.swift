//
//  MarathonCodeViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI
import Observation

@Observable
final class MarathonCodeViewModel {
    var code: String = ""
    var showKeyboard = false
    var goToVerify = false

    var isValidFormat: Bool {
        !code.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func submit() {
        showKeyboard = false
        guard isValidFormat else { return }   // nggak lanjut kalau kosong
        goToVerify = true
    }
}
