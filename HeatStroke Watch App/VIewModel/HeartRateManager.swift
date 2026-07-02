import Foundation
import HealthKit
import Combine

class HeartRateManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {

    @Published var value: Int = 0
    @Published var isMonitoring: Bool = false

    private var healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")
    private let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    // MARK: - Public controls

    func start() {
        guard !isMonitoring else { return }

        authorizeHealthKit { [weak self] success in
            guard let self = self, success else { return }
            self.startWorkoutSession()
        }
    }

    func stop() {
        guard isMonitoring, let session = session else { return }
        isMonitoring = false   // set duluan, biar gak bisa dipanggil dobel kalau ditap 2x cepat
        session.stopActivity(with: Date())
    }

    // MARK: - Authorization

    private func authorizeHealthKit(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("⚠️ HealthKit tidak tersedia di device ini.")
            completion(false)
            return
        }

        let shareTypes: Set = [HKObjectType.workoutType()]
        let readTypes: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            if let error = error {
                print("⚠️ HealthKit authorization error: \(error.localizedDescription)")
            } else {
                print(success ? "✅ HealthKit authorization granted" : "❌ HealthKit authorization ditolak user")
            }
            completion(success)
        }
    }

    // MARK: - Workout session (yang menjaga app tetap hidup walau keluar/background)

    private func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .unknown

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            print("⚠️ Gagal membuat workout session: \(error.localizedDescription)")
            return
        }

        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { [weak self] success, error in
            if let error = error {
                print("⚠️ Gagal mulai collection: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.isMonitoring = true
            }
            print("▶️ Workout session dimulai — heart rate tetap terdeteksi walau app di-background")
        }
    }

    // MARK: - HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        guard toState == .stopped else { return }

        builder?.endCollection(withEnd: date) { [weak self] success, error in
            if let error = error {
                print("⚠️ Gagal endCollection: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.isMonitoring = false
                self?.value = 0
            }
            self?.session?.end()   // dipanggil cuma sekali, di sini
            print("⏹️ Workout session berhenti")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("⚠️ Workout session error: \(error.localizedDescription)")
    }

    // MARK: - HKLiveWorkoutBuilderDelegate

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        guard collectedTypes.contains(heartRateType),
              let statistics = workoutBuilder.statistics(for: heartRateType) else { return }

        let bpm = statistics.mostRecentQuantity()?.doubleValue(for: heartRateQuantity) ?? 0
        print("📥 Heart rate terbaru: \(Int(bpm)) BPM")

        DispatchQueue.main.async {
            self.value = Int(bpm)
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
