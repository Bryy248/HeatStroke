//
//  WaitingView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI
import Combine

struct WaitingView: View {
    
    @State private var offset: CGFloat = 200
    @State private var navigateToReady = false
    @State private var showInfo = false
    
    //change to the time in database
    //(Just want to see if the timer work)
    let targetDate: Date = {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2026
        components.month = 07
        components.day = 07
        components.hour = 12
        components.minute = 00
        return calendar.date(from: components)!
    }()
    
    @State private var timeRemainingString = "Calculating..."
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16){
                VStack(spacing: 0){
                    Text("You Are Connected")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                    Text("BTN JAKIM 2027") //placeholder nama event
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.color1)
                }
                
                VStack(alignment: .center, spacing: -5){
                    Text(timeRemainingString)
                        .font(.system(size: 32, weight: .bold))
                    HStack(spacing: 32){
                        Text("days")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        Text("hrs")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        Text("min")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                .onAppear(perform: updateCountdown)
                .onReceive(timer) { _ in updateCountdown()}
                
                HStack(spacing: 5) {
                    VStack(alignment: .center) {
                        Text("BIB")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        Text("M12345") //placeholder
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 75, height: 40)
                    .background(Color.inputBgcolor)
                    .cornerRadius(7)
                    
                    VStack(alignment: .center) {
                        Text("Type")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                        MarqueeText(
                            text: "Full Marathon",
                            font: .system(size: 14, weight: .semibold)
                        )
                        .frame(width: 100)
                    }
                    .frame(width: 60, height: 30)
                    .frame(width: 75, height: 40)
                    .background(Color.inputBgcolor)
                    .cornerRadius(7)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { //UNTUK SEMENTARA WAIT 3S buat lanjut ke running view
                    navigateToReady = true
                }
            }
            .navigationDestination(isPresented: $navigateToReady) {
                ReadyViewOption(vm: ReadyViewModel(env: EnvironmentDataManager()))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfo = true
                    } label: {
                        Image(systemName: "info")
                    }

                }
            }
            .sheet(isPresented: $showInfo) {
                ShowInfoView()
            }
        }
    }
    
    //ini buat countdown juga (functionnya maybe bisa dipindahin nanti)
    private func updateCountdown() {
        let now = Date.now
        
        guard now < targetDate else {
            timeRemainingString = "Event Started!"
            return
        }
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        timeRemainingString = String(format: "%02d : %02d : %02d", days, hours, minutes)
    }
    
    //ini biar tulisannya bisa jalan
    struct MarqueeText: View {
        let text: String
        let font: Font
        
        @State private var textWidth: CGFloat = 0
        @State private var offset: CGFloat = 0
        
        var body: some View {
            GeometryReader { geo in
                Text(text)
                    .font(font)
                    .lineLimit(1)
                    .background(
                        GeometryReader { textGeo in
                            Color.clear
                                .onAppear {
                                    textWidth = textGeo.size.width
                                    offset = geo.size.width
                                }
                        }
                    )
                    .offset(x: offset)
                    .onAppear {
                        let distance = geo.size.width + textWidth
                        
                        withAnimation(
                            .linear(duration: Double(distance / 30))
                            .repeatForever(autoreverses: false)
                        ) {
                            offset = -textWidth
                        }
                    }
            }
            .frame(height: 20)
            .clipped()
        }
    }
    
}

#Preview {
    WaitingView()
}
