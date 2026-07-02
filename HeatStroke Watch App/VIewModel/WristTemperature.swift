//
//  Untitled.swift
//  HeatStroke
//
//  Created by Brian Chang on 02/07/26.
//

import Foundation
import HealthKit
import Combine

class WristTemperatureManager: ObservableObject {

    @Published var temperature: Double? = nil   // dalam derajat Celsius

    private var healthStore = HKHealthStore()
    private let wristTemperatureType = HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!

    func authorize(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("⚠️ HealthKit tidak tersedia di device ini.")
            completion(false)
            return
        }

        healthStore.requestAuthorization(toShare: [], read: [wristTemperatureType]) { success, error in
            if let error = error {
                print("⚠️ Wrist temperature authorization error: \(error.localizedDescription)")
            }
            completion(success)
        }
    }

    func fetchLatest() {
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: wristTemperatureType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sort]
        ) { [weak self] _, samples, error in
            if let error = error {
                print("⚠️ Wrist temperature query error: \(error.localizedDescription)")
                return
            }

            guard let sample = samples?.first as? HKQuantitySample else {
                print("ℹ️ Belum ada data wrist temperature (butuh Apple Watch Series 8+/Ultra dengan sleep tracking semalam).")
                return
            }

            let celsius = sample.quantity.doubleValue(for: .degreeCelsius())

            DispatchQueue.main.async {
                self?.temperature = celsius
            }
        }

        healthStore.execute(query)
    }
}
