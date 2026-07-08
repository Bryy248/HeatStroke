//
//  ScoreCard.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 08/07/26.
//

import SwiftUI

struct ScoreCard: View {
    let icon: String
    let title: String
    let action: String
    let desc: String
    let fontColor: Color
    let bgColor: Color
    
    var body: some View {
        VStack (alignment: .leading, spacing: 2) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 13))

                Text(title)
                    .font(.system(size: 14, weight: .bold))
                
                Spacer()
                
                Text(action)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(fontColor)
            }
            Text(desc)
                .font(.system(size: 12, weight: .regular))
        }
        .padding(8)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ScoreCard(icon: "figure.walk", title: "Safe", action: "Keeps Going", desc: "You're doing well. Keep your pace and stay hydrated", fontColor: .color1, bgColor: .safeBgcolor)
}
