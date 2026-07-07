//
//  ReadyViewOption.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 07/07/26.
//

import SwiftUI

struct ReadyViewOption: View {
    @State var isDetected: Bool = true
    @State var isLoading: Bool = false
        
    var body: some View {
        if !isDetected {
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
        } else {
            ZStack {
                //layer terluar (ambient)
                // LAYER 1: Outline
                Circle()
                    .trim(from: 0.07, to: 0.93)
                    .stroke(
                        Color(red: 0.05, green: 0.20, blue: 0.30),
                        style: StrokeStyle(lineWidth: 24, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 170, height: 170)
                
                // LAYER 2: kosongannya
                Circle()
                    .trim(from: 0.07, to: 0.93)
                    .stroke(
                        Color(.black),
                        style: StrokeStyle(lineWidth: 22, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 170, height: 170)
                
                // LAYER 3: progressannya
                Circle()
                    .trim(from: 0.06, to: 0.583)
                    .stroke(
                        Color(.humid),
                        style: StrokeStyle(lineWidth: 22, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: 35))
                    .frame(width: 170, height: 170)
                
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("78")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.humid)
                        .offset(x: 0, y: -83)
                    
                    Text("%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.humid)
                        .offset(x: 0, y: -83)
                }
                
                Image(systemName: "humidity.fill")
                    .foregroundColor(.black)
                    .font(Font.system(size: 9.6))
                    .offset(x: -37, y: -76)
                
                //layer kedua (suhu)
                // LAYER 1: Outline
                Circle()
                    .trim(from: 0.07, to: 0.92)
                    .stroke(
                        Color(.orangeHigh.opacity(0.3)),
                        style: StrokeStyle(lineWidth: 24, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 110, height: 110)
                
                // LAYER 2: kosongannya
                Circle()
                    .trim(from: 0.07, to: 0.92)
                    .stroke(
                        Color(.black),
                        style: StrokeStyle(lineWidth: 22, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 110, height: 110)
                
                
                // LAYER 3: progressannya
                Circle()
                    .trim(from: 0.06, to: 0.575)
                    .stroke(
                        Color(.orange),
                        style: StrokeStyle(lineWidth: 22, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: 35))
                    .frame(width: 110, height: 110)
                
                Text("32°")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.orange)
                    .offset(x: 0, y: -53)
                
                Image(systemName: "thermometer.variable")
                    .foregroundColor(.black)
                    .font(Font.system(size: 8.64))
                    .offset(x: -23, y: -50)
                
                Button {
                    //connect ke running view
                } label: {
                    Text("Start")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 74, height: 74)
                }
                .background(.color1)
                .clipShape(Circle())
                .buttonStyle(.plain)
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
    ReadyViewOption()
}
