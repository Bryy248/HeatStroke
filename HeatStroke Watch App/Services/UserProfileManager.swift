//
//  UserProfileManager.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import HealthKit
import Combine

class UserProfileManager: ObservableObject {

    @Published var age: Int = 25   // fallback kalau data tidak tersedia/ditolak

    private var healthStore = HKHealthStore()
    private let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!

    func authorizeAndFetch() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("⚠️ HealthKit tidak tersedia, pakai age default: \(age)")
            return
        }

        healthStore.requestAuthorization(toShare: [], read: [dateOfBirthType]) { [weak self] success, error in
            guard let self = self else { return }
            if let error = error {
                print("⚠️ Date of birth authorization error: \(error.localizedDescription)")
                return
            }
            guard success else {
                print("❌ Date of birth authorization ditolak, pakai age default: \(self.age)")
                return
            }
            self.fetchAge()
        }
    }

    func fetchAge() {
        do {
            let birthDateComponents = try healthStore.dateOfBirthComponents()
            guard let birthDate = Calendar.current.date(from: birthDateComponents) else {
                print("⚠️ Gagal parse date of birth, pakai age default: \(age)")
                return
            }
            let calculatedAge = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? age

            DispatchQueue.main.async {
                self.age = calculatedAge
                print("✅ Age dari HealthKit: \(calculatedAge) tahun")
            }
        } catch {
            print("⚠️ Gagal ambil date of birth: \(error.localizedDescription), pakai age default: \(age)")
        }
    }
}
