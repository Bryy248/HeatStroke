import Foundation
import HealthKit
import Combine

class HeartRateManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {

    @Published var value: Int = 0                  // BPM instan (real-time)
    @Published var averageHeartRate: Int? = nil     // rata-rata rolling 5 menit
    @Published var isMonitoring: Bool = false

    private var healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")
    private let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    private var samples: [(timestamp: Date, bpm: Double)] = []
    private let windowDuration: TimeInterval = 5 * 60

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
        isMonitoring = false
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

    // MARK: - Workout session

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

        samples.removeAll()

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { [weak self] success, error in
            if let error = error {
                print("⚠️ Gagal mulai collection: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async { self?.isMonitoring = true }
            print("▶️ Workout session dimulai")
        }
    }

    // MARK: - HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        guard toState == .stopped else { return }

        builder?.endCollection(withEnd: date) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isMonitoring = false
                self?.value = 0
                self?.averageHeartRate = nil
            }
            self?.samples.removeAll()
            self?.session?.end()
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
        let now = Date()

        samples.append((timestamp: now, bpm: bpm))
        let cutoff = now.addingTimeInterval(-windowDuration)
        samples.removeAll { $0.timestamp < cutoff }

        let avg = samples.map { $0.bpm }.reduce(0, +) / Double(samples.count)
        print("📥 HR instan: \(Int(bpm)) BPM | Avg(\(samples.count) sample): \(Int(avg)) BPM")

        DispatchQueue.main.async {
            self.value = Int(bpm)
            self.averageHeartRate = Int(avg)
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
