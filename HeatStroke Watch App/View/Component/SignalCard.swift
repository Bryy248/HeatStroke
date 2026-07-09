//
//  SignalCard.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 08/07/26.
//

import SwiftUI

struct SignalCard<Icon: View>: View {
    let title: String
    @ViewBuilder let icon: () -> Icon

    var body: some View {
        VStack(spacing: 6) {
            icon()
                .font(.system(size: 14))
                .frame(height: 14)
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 47)
        .background(Color.signalcard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
