//
//  FinishViewModel.swift
//  HeatStroke
//
//  Created by Brian Chang on 08/07/26.
//

import SwiftUI

@Observable
class FinishViewModel {
    enum FinishType {
        case finish
        case finishWithAlert
        case stopEarly
    }
    
    var finishState: FinishType = .stopEarly
}

extension FinishViewModel {
    var content: FinishContent {
        switch finishState {
        case .finish:
            FinishContent(
                iconName: "trophy.fill", iconColor: .color1,
                circleBackground: .inputBgcolor,
                title: "You did it!", subtitleColor: .color1,
                finishTime: "2:30:08",
                avgZone: "Safe",
                statBackground: .inputBgcolor,
                message: "Stayed safe the whole race!",
                messageColor: .color1, buttonTint: .color1
            )
        case .finishWithAlert:
            FinishContent(
                iconName: "trophy.fill", iconColor: .color1,
                circleBackground: .inputBgcolor,
                title: "You did it!", subtitleColor: .color1,
                finishTime: "2:30:08",
                avgZone: "Moderate",
                statBackground: .inputBgcolor,
                message: "Made it, but heat risk rose twice. Rest and hydrate well.",
                messageColor: .yellow, buttonTint: .color1
            )
        case .stopEarly:
            FinishContent(
                iconName: "square", iconColor: .red,
                circleBackground: .finish,
                title: "Stopped early", subtitleColor: .red,
                finishTime: "1:20:08",
                avgZone: "Safe",
                statBackground: .gray.opacity(0.2),
                message: "Good call stopping. Rest, hydrate, see medical if needed.",
                messageColor: .red, buttonTint: .red
            )
        }
    }
}
