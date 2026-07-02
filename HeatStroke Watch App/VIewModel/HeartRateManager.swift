import Foundation
import HealthKit
import Combine

class HeartRateManager: ObservableObject {

    @Published var value: Int = 0

    private var healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")

    func start() {
        authorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }

    private func authorizeHealthKit() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("⚠️ HealthKit tidak tersedia di device ini (jalankan di device fisik, bukan Simulator).")
            return
        }

        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        healthStore.requestAuthorization(toShare: [], read: healthKitTypes) { success, error in
            if let error = error {
                print("⚠️ HealthKit authorization error: \(error.localizedDescription)")
            } else {
                print(success ? "✅ HealthKit authorization granted" : "❌ HealthKit authorization ditolak user")
            }
        }
    }

    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {

        // Tidak pakai devicePredicate: kalau dibatasi ke HKDevice.local(),
        // data dari Apple Watch akan ikut tersaring karena sumbernya beda device.
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { [weak self] query, samples, deletedObjects, queryAnchor, error in

            if let error = error {
                print("⚠️ Query error: \(error.localizedDescription)")
                return
            }

            guard let samples = samples as? [HKQuantitySample] else {
                return
            }

            print("📥 Menerima \(samples.count) sample heart rate")
            self?.process(samples, type: quantityTypeIdentifier)
        }

        let query = HKAnchoredObjectQuery(
            type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit,
            resultsHandler: updateHandler
        )

        query.updateHandler = updateHandler

        // 4. Menjalankan query
        healthStore.execute(query)
    }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0

        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
        }

        // Update UI harus di main thread
        DispatchQueue.main.async {
            self.value = Int(lastHeartRate)
        }
    }
}
