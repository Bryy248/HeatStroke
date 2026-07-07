//
//  DummyDataService.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 05/07/26.
//


import SwiftUI
import Supabase

final class DummyDataService {
    private let client = SupabaseManager.client

    private let eventId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!

    func seedDummyData() async {
        do {
            let event = Event(
                id: eventId,
                name: "Jakarta International Marathon",
                location: "Jakarta",
                startTime: "2026-07-20T06:00:00+07:00",
                endTime: "2026-07-20T10:00:00+07:00",
                createdAt: nil,
                code: "BTN123"
            )

            try await client
                .from("events")
                .upsert(event, onConflict: "id")
                .execute()

            let runners: [Runner] = [
                Runner(
                    id: UUID(uuidString: "22222222-2222-2222-2222-222222222221")!,
                    eventId: eventId,
                    name: "Bryan Chang",
                    bibNumber: "BIB001",
                    age: 21,
                    gender: "male",
                    currentRiskLevel: "safe",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil
                ),
                Runner(
                    id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                    eventId: eventId,
                    name: "Vanya",
                    bibNumber: "BIB002",
                    age: 24,
                    gender: "male",
                    currentRiskLevel: "caution",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil
                ),
                Runner(
                    id: UUID(uuidString: "22222222-2222-2222-2222-222222222223")!,
                    eventId: eventId,
                    name: "Nabiel A",
                    bibNumber: "BIB003",
                    age: 27,
                    gender: "male",
                    currentRiskLevel: "danger",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil
                )
            ]

            try await client
                .from("runners")
                .upsert(runners, onConflict: "event_id,bib_number")
                .execute()

            print("succesful")

        } catch {
            print("failed \(error)")
        }
    }
}
