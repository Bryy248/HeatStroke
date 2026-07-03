//
//  HealthKitAuthManager.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import HealthKit

class HealthKitAuthManager {
    static let shared = HealthKitAuthManager()
    let healthStore = HKHealthStore()

    func requestAllAuthorizations(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        ]
        let shareTypes: Set = [HKObjectType.workoutType()]

        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            completion(success)   // 1 dialog aja untuk semua!
        }
    }
}
