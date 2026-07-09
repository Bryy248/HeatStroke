//
//  HeartRateView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 02/07/26.
//

import SwiftUI

struct HeartRateView: View {

    @StateObject private var viewModel = HeatStrokeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                HStack {
                    Text("\(viewModel.currentHeartRate)")
                        .font(.system(size: 36))
                    Text("BPM")
                        .font(.headline)
                        .foregroundColor(.red)
                    Spacer()
                }

                if let avgHR = viewModel.averageHeartRate {
                    Text("Avg 5 menit: \(avgHR) BPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                infoRow("⌚ Wrist (raw)", viewModel.wristTemperature, unit: "°C")
                infoRow("🌡️ Est. Core Temp", viewModel.estimatedCoreTemperature, unit: "°C")
                infoRow("🌤️ Ambient", viewModel.averageAmbientTemp, unit: "°C")
                infoRow("💧 Humidity", viewModel.averageHumidity, unit: "%")
                infoRow("Heat Index", viewModel.heatIndex, unit: "°C")

                Divider()

                HStack {
                    Text("Risk:")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.riskLevel.label)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(riskColor(viewModel.riskLevel))
                }

                Button(action: toggleMonitoring) {
                    Text(viewModel.isMonitoring ? "Stop" : "Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isMonitoring ? Color.red : Color.green)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }

    private func infoRow(_ label: String, _ value: Double?, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()

            if let value {
                Text("\(value, specifier: "%.1f")\(unit)")
            } else {
                Text("-- \(unit)")
            }
        }
        .font(.subheadline)
        .fontWeight(.semibold)
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .safe: return .green
        case .moderate: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        }
    }

    private func toggleMonitoring() {
        if viewModel.isMonitoring {
            viewModel.stop()
        } else {
            viewModel.start()
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
