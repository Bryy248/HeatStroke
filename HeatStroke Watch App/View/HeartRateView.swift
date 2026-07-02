//
//  HeartRateView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 02/07/26.
//

import SwiftUI

struct HeartRateView: View {

    @StateObject private var manager = HeartRateManager()
    @StateObject private var wristManager = WristTemperatureManager()

    var body: some View {
        VStack(spacing: 24) {


            HStack {
                Text("\(manager.value)")
                    .fontWeight(.regular)
                    .font(.system(size: 28))

                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)

                Spacer()
            }

            HStack {
                Text("🌡️")
                    .font(.system(size: 28))

                if let temp = wristManager.temperature {
                    Text(String(format: "%.1f °C", temp))
                        .font(.title3)
                        .fontWeight(.semibold)
                } else {
                    Text("-- °C")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Text("Wrist Temp")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }


            Button(action: toggleMonitoring) {
                Text(manager.isMonitoring ? "Stop" : "Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(manager.isMonitoring ? Color.red : Color.green)
                    .cornerRadius(12)
            }
        }
        .padding()
    }

    private func toggleMonitoring() {
        if manager.isMonitoring {
            manager.stop()
        } else {
            manager.start()
            wristManager.authorize { success in
                if success {
                    wristManager.fetchLatest()
                }
            }
        }
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}

#Preview {
    HeartRateView()
}
