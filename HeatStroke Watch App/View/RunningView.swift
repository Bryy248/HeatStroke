//
//  RunningView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct RunningView: View {
    
    let runner: Runner
    
    @State private var viewModel = RunningViewModel()
    @State private var didFinish = false
    
    var body: some View {
        if didFinish {
            FinishView(runner: runner, elapsedSeconds: viewModel.elapsedSeconds)
        }
        else {
            content
        }
    }

        @ViewBuilder
        private var content: some View {
            switch viewModel.state {
            case .ready:      ReadyView
            case .countdown:  CountdownView
            case .running:
                ZStack {
                    RunningView
                    if viewModel.showSlowDown { SlowDownView }
                }
            case .emergency:  EmergencyView(viewModel: viewModel)
            }
        }
    
    private var ReadyView: some View {
        VStack(spacing: 16) {
            ZStack {
                Text("Ready")
                    .font(.system(size: 32, weight: .regular))
                Circle()
                    .trim(from: 0, to: viewModel.progressReady)
                    .stroke(
                        .color1,
                        style: StrokeStyle(
                            lineWidth: 11,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(90))
                    .frame(width: 131, height: 131)
                    .onAppear {viewModel.startReady()}
            }
            Text("Start Monitoring")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private var CountdownView: some View {
        VStack(spacing: 16) {
            ZStack {
                Text("\(viewModel.countdown)")
                    .font(.system(size: 32, weight: .regular))
                
                ZStack {
                    Circle()
                        .stroke(.color1.opacity(0.25), lineWidth: 11)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.progressCountdown)
                        .stroke(.color1, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 131, height: 131)
                .task {await viewModel.startCountdown(runner: runner)}
            }
            Text("Start Monitoring")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private var SlowDownView: some View {
        ZStack {
            (isBlinkOn ? Color.red : Color.white)
                       .ignoresSafeArea()
            
            VStack {
                Text("Slow\nDown")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(isBlinkOn ? .white : .red)   // ✅ ikut kontras background
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.dismissSlowDown()
        }
        .onAppear {
            startBlinking()
        }
        .onDisappear {
            blinkTask?.cancel()
        }
    }
    
    @State private var isBlinkOn = true
    @State private var blinkTask: Task<Void, Never>?

    private func startBlinking() {
        blinkTask?.cancel()
        blinkTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.5))
                isBlinkOn.toggle()
            }
        }
    }
    
    private var RunningView: some View {
        TabView(selection:$viewModel.selectedTab) {
            
            //left page
            VStack (spacing: 10) {
                HStack(spacing: 10) {
                    // Finish
                    VStack(spacing: 6) {
                        Button {
                            viewModel.stopTimer()
                            didFinish = true
                        } label: {
                            Image(systemName: "flag.pattern.checkered")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 76, height: 50)
                        .background(Color.finish)
                        .cornerRadius(25)
                        
                        Text("Finish")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    
                    // Pause / Resume
                    VStack(spacing: 6) {
                        Button {
                            if viewModel.isPaused {
                                viewModel.resumeTimer()
                            } else {
                                viewModel.pauseTimer()
                            }
                            
                        } label: {
                            Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 76, height: 50)
                        .background(Color.pause)
                        .cornerRadius(25)
                        .disabled(viewModel.isFinished == true)
                        
                        Text(viewModel.isPaused ? "Resume" : "Pause")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                }
                // emergency call
                VStack(spacing: 6) {
                    Button {
                        viewModel.callEmergency()
                    } label: {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 162, height: 50)
                    .background(Color.finish)
                    .cornerRadius(25)
                    
                    Text("Call emergency")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }.tag(0)
            
            //center page
            ScrollView {
                VStack(spacing: 5){
                    ZStack {
                        Circle()
                            .foregroundStyle(viewModel.condition.color)
                            .frame(width: 65, height: 65)
                            .blur(radius: 42)
                            .shadow(color: .color1, radius: 42)
//                            .frame(width: 65, height: 65)
                        
                        VStack {
                            Image(systemName: viewModel.condition.icon)
                                .font(.system(size: 48))
                                .foregroundStyle(viewModel.condition.color)
                            
                            Text(viewModel.condition.title)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(viewModel.condition.color)
                        }
                        .frame(width: 141, height: 110)
                    }
                    .frame(width: 200, height: 150)
                    
                    if viewModel.firstTimeDangereous && viewModel.condition == .emergency {
                        Text("Stop when not feeling well & keep hydrating")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(viewModel.isPaused ? .gray :.white)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            viewModel.callEmergency()
                        } label: {
                            Text("I'm not okay")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 168, height: 52)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 1000))
                        .buttonStyle(.plain)
                        
                        Button {
                            viewModel.firstTimeDangereous.toggle()
                            viewModel.cancelIdleReminder()
                        } label: {
                            Text("I'm okay")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 168, height: 52)
                        .background(.color1)
                        .clipShape(RoundedRectangle(cornerRadius: 1000))
                        .buttonStyle(.plain)
                        
                    } else {
                        Text(viewModel.formattedTimer)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(viewModel.isPaused ? .gray :.white)
                    }
                }
            } .tag(1)
            
            //right page
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    VStack(spacing: 5) {
                        Text("\(viewModel.heartRate)")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.condition.fontcolor)
                        
                        HStack(spacing: 2) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            
                            Text("BPM")
                                .foregroundColor(.red)
                        }
                        .font(.system(size: 14))
                    }
                    
                    VStack(spacing: 5) {
                        Text(String(format: "%.1f°", viewModel.bodyTemperature))
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.condition.fontcolor)
                        
                        HStack(spacing: 2) {
                            Image(systemName: "thermometer.variable.and.figure")
                                .foregroundColor(.suhuBgcolor)
                            
                            Text("BODY")
                                .foregroundColor(.suhuBgcolor)
                        }
                        .font(.system(size: 14))
                    }
                }
                
                HStack(spacing: 20) {
                    
                    VStack(spacing: 5) {
                        Text(String(format:"%.1f°", viewModel.ambientTemperature))
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.condition.fontcolor)
                        
                        HStack(spacing: 2) {
                            Image(systemName: "thermometer.sun.fill")
                                .foregroundColor(.yellow)
                            
                            Text("AMB")
                                .foregroundColor(.yellow)
                        }
                        .font(.system(size: 14))
                    }
                    
                    VStack(spacing: 5) {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text(String(format:"%.1f", viewModel.humidity))
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(viewModel.condition.fontcolor)
                            
                            Text("%")
                                .font(.system(size: 12, weight: .medium))
                        }
                        
                        HStack(spacing: 2) {
                            Image(systemName: "humidity.fill")
                                .foregroundColor(.humid)
                            
                            Text("HUM")
                                .foregroundColor(.humid)
                        }
                        .font(.system(size: 14))
                    }
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page)
        .background(Color.black)
    }
}


#Preview {
//    RunningView(
//    )
}

