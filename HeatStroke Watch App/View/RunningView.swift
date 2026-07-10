//
//  RunningView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct RunningView: View {
    
    // TODO: JANGAN LUPA DIGANTI (untuk ngambil dr readyview)
    //    let runner: Runner
    
    @State private var viewModel = RunningViewModel()
    
    var body: some View {
        switch viewModel.state {
        case .ready:
            ReadyView
        case .countdown:
            CountdownView
        case .running:
            RunningView
        case .emergency:
            EmergencyView(viewModel: viewModel)
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
                // TODO: JANGAN LUPA DIGANTI
//                .task {await viewModel.startCountdown(runner: runner)}
                .task {await viewModel.startCountdown(runner: Runner.dummy)}
            }
            Text("Start Monitoring")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
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
                            // TODO: navigate to finish page @bricang
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
                            .blur(radius: 42)
                            .shadow(color: .color1, radius: 42)
                            .frame(width: 65, height: 65)
                        
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
                    
                    if viewModel.firstTimeDangereous && viewModel.condition == .emergency {
                        Text("Slow down your pace & drink water now!")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(viewModel.isPaused ? .gray :.white)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            // goes to emergency view
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
                            // stay in here
                        } label: {
                            Text("I'm fine")
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
        }
    }

// TODO: JANGAN LUPA DIHAPUS
//DUMMY UNTUK RUN (NABIEL) - JANGAN LUPA DIHAPUS
extension Runner {
    static var dummy: Runner {
        Runner(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222221")!,
            eventId: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Bryan Chang",
            bibNumber: "M1234",
            age: 21,
            birthDate: nil,
            gender: "male",
            currentRiskLevel: nil,
            lastUpdated: nil,
            createdAt: nil,
            registeredBy: nil,
            startTime: nil,
            finishTime: nil
        )
    }
}


#Preview {
    RunningView(
    )
}

