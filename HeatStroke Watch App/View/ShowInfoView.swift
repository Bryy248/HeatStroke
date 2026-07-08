//
//  ShowInfoView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 08/07/26.
//

import SwiftUI

struct ShowInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showScore = false
    
    var body: some View {
        ScrollView {
            Text("How this works?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.color1)
            Text("Tracks your heat risk in real time to help you run safely")
                .multilineTextAlignment(.center)
                .font(.system(size: 12, weight: .regular))
                .padding(.bottom, 16)
            
            Text("Why it matters?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.color1)
            Text("Heatstroke hits fast. Early warning gives time to react, alerts medics before serious.")
                .multilineTextAlignment(.center)
                .font(.system(size: 12, weight: .regular))
                .padding(.bottom, 16)
            
            Text("Signal we read")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.color1)
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8),
                          GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                SignalCard(title: "Heart rate") {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }

                SignalCard(title: "Body temp") {
                    HStack(spacing: 1) {
                        Image(systemName: "thermometer.low")
                        Image(systemName: "figure.stand")
                    }
                    .foregroundStyle(.orange)
                }

                SignalCard(title: "Air temp") {
                    Image(systemName: "thermometer.sun.fill")
                        .foregroundStyle(.yellow)
                }

                SignalCard(title: "Humidity") {
                    Image(systemName: "humidity.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showScore.toggle()
                }
            } label: {
                VStack(spacing: 2) {
                    Text("Combined into")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(showScore ? 180 : 0)) // panah membalik saat terbuka
                }
            }
            .buttonStyle(.plain)

            // Konten yang muncul setelah diklik
            if showScore {
                VStack(spacing: 4) {
                    Text("Heat Index Score")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.color1)
                        .padding(.top, 8)

                    ScoreCard(icon: "figure.walk", title: "Safe", action: "Keeps going", desc: "You're doing well. Keep your pace and stay hydrated", fontColor: .color1, bgColor: .safeBgcolor)
                    
                    ScoreCard(icon: "figure.run", title: "Moderate", action: "Take it easy", desc: "You're doing well. Keep your pace and stay hydrated ", fontColor: .yellow, bgColor: .moderateBgcolor)
                    
                    ScoreCard(icon: "exclamationmark.triangle.fill", title: "High", action: "Be careful", desc: "The heat is putting extra strain on your body. Walk and cool down", fontColor: .orangeHigh, bgColor: .highBgcolor)
                    
                    ScoreCard(icon: "hand.raised.fill", title: "Danger", action: "Slow down", desc: "Your body is overheating. Stop and seek medical help", fontColor: .red, bgColor: .dangerBgcolor)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    ShowInfoView()
}
