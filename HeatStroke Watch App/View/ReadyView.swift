//
//  ReadyView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct ReadyView: View {
    @State var isDetected: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        if !isDetected {
            VStack(spacing: 15){
                VStack(spacing: 10){
                    LoadingSpinner()
                        .tint(.color1)
                    VStack(spacing: 2){
                        Text("Connecting to sensor")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Looking for nearest station")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                
            }
        } else {
            VStack(spacing: 25){
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(.color1)
                    
                    Text("Sensor connected")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.color1)
                }
                
                HStack(spacing: 21) {
                    HStack(spacing: 2) {
                        Image(systemName: "thermometer.variable")
                            .font(.system(size: 24))
                            .foregroundStyle(.suhuBgcolor)
                        
                        Text("29°") //placeholder
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.suhuBgcolor)
                    }
                    
                    HStack(spacing: 2) {
                        Image(systemName: "humidity.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.humid)
                        
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text("78")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.humid)

                            Text("%")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.humid)
                        }
                    }
                }

                Button {
                    // Aksi Button akan ke during page
                } label: {
                    Text("Start")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(width: 168, height: 52)
                .buttonStyle(.borderedProminent)
                .tint(.color1)
                .disabled(isLoading)
                
            }
        }
    }
    
    struct LoadingSpinner: View {
        @State private var rotate = false

        var body: some View {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(.gray, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .opacity(0.3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.25) //jadi cuma muncul setengahnya
                    .stroke(.color1, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1)
                            .repeatForever(autoreverses: false)
                        ) {
                            rotate = true
                        }
                    }
            }
        }
    }
}

#Preview {
    ReadyView()
}
