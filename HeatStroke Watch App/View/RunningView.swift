//
//  RunningView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct RunningView: View {

    //for the countdown
    @State var countdown = 4
    
    @State var isReady: Bool = false

    @State var isHeatRisk: Bool = false
    
    var body: some View {
        if !isReady {
            VStack(spacing: 16){
                ZStack {
                    Circle()
                        .stroke(.color1, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                        .frame(width: 131, height: 131)
                    if countdown == 4 {
                        Text("Ready")
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                    } else {
                        Text("\(countdown)")
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                    }
                }
                Text("Start Monitoring")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .task {
                await startCountdown()
            }
        } else {
            if isHeatRisk {
                VStack(spacing: 15){
                    VStack(spacing: 12) {
                        Text("Heat Risk High")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.red)
                        
                        HStack(spacing: 5){
                            VStack(alignment: .center) {
                                Text("178")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)

                                HStack(spacing: 2) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                    
                                    Text("BPM")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.finish)
                            .cornerRadius(7)
                            
                            VStack(alignment: .center) {
                                Text("39.1°")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "thermometer.variable.and.figure")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                    
                                    Text("BODY")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.finish)
                            .cornerRadius(7)
                        }
                        
                        Text("Slow your pace & drink water now!")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 3){
                        Button {
                            // Aksi Button akan menghentikan race dan memberi warning
                        } label: {
                            Text("I'm not okay")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(width: 168, height: 52)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Button {
                            // Aksi Button akan membuat pelari dapat melanjutkan lari ke tampilan awal
                        } label: {
                            Text("I'm fine")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(width: 168, height: 52)
                        .buttonStyle(.borderedProminent)
                        .tint(.color1)
                    }
                }
            }
            else {
                TabView {
                    //page 1
                    VStack(alignment: .center){
                        HStack(spacing: 10){
                            VStack(spacing: 6){
                                Button {
                                    //the race will stopped
                                } label: {
                                    Image(systemName: "flag.pattern.checkered")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 76, height: 50)
                                .background(Color.finish)
                                .buttonStyle(.bordered)
                                .cornerRadius(25)
                                
                                Text("Finish")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 6){
                                Button {
                                    //the race will be resume
                                } label: {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.yellow)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 76, height: 50)
                                .background(Color.pause)
                                .buttonStyle(.bordered)
                                .cornerRadius(25)
                                
                                Text("Resume")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    
                    //page 2
                    ZStack(alignment: .center){
                        Circle()
                            .fill(.color1)
                            .frame(width: 58, height: 58)
                            .blur(radius: 58)
                            .shadow(color: .color1, radius: 58)
                        
                        VStack{
                            Image(systemName: "figure.run")
                                .font(.system(size: 48))
                                .foregroundStyle(.color1)
                            
                            Text("Safe Zone")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.color1)
                        }
                    }
                    
                    //page 3
                    VStack(spacing: 20){
                        
                        HStack(spacing: 20){
                            
                            VStack(spacing: 5) {
                                Text("138") //placeholder hr
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.red)
                                    
                                    Text("BPM")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            VStack(spacing: 5) {
                                Text("37°") //placeholder body
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "thermometer.variable.and.figure")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.suhuBgcolor)
                                    
                                    Text("BODY")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.suhuBgcolor)
                                }
                            }
                            
                        }
                        
                        HStack(spacing: 20){
                            VStack(spacing: 5) {
                                Text("31°") //placeholder amb
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "thermometer.sun.fill")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.yellow)
                                    
                                    Text("AMB")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            VStack(spacing: 5) {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("78") //placeholder hum
                                        .font(.system(size: 24, weight: .medium))
                                    
                                    Text("%")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "humidity.fill")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.humid)
                                    
                                    Text("HUM")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.humid)
                                }
                            }
                            
                        }
                    }
                    
                }
                .tabViewStyle(.page)
            }
        }
    }
    
    //countdown
    func startCountdown() async { //async -> timer tanpa freeze

            for number in stride(from: 4, through: 1, by: -1) { //loop dari 4 hingga 1
                countdown = number
                try? await Task.sleep(for: .seconds(1))
                //await -> tunggu operasi selesai, task sleep -> program menunggu 1s
            }

            // Countdown finished -> status berubah
            isReady = true
        }
}

#Preview {
    RunningView()
}
