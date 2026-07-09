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

    func makeDate(day: Int, month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar.current.date(from: components)!
    }
    
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
                    bibNumber: "M1234",
                    age: 21,
                    birthDate: "2004-01-01",
                    gender: "male",
                    currentRiskLevel: "safe",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil,
                    startTime: nil,
                    finishTime: nil
                ),
                Runner(
                    id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                    eventId: eventId,
                    name: "Vanya",
                    bibNumber: "F2222",
                    age: 21,
                    birthDate: "2004-01-01",
                    gender: "female",
                    currentRiskLevel: "caution",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil,
                    startTime: nil,
                    finishTime: nil
                ),
                Runner(
                    id: UUID(uuidString: "22222222-2222-2222-2222-222222222223")!,
                    eventId: eventId,
                    name: "Nabiel A",
                    bibNumber: "M2222",
                    age: 21,
                    birthDate:  "2004-01-01",
                    gender: "male",
                    currentRiskLevel: "danger",
                    lastUpdated: nil,
                    createdAt: nil,
                    registeredBy: nil,
                    startTime: nil, 
                    finishTime: nil
                )
            ]
            
            try await client
                .from("runners")
                .upsert(runners, onConflict: "event_id,bib_number")
                .execute()

            print("succesful")
            
            let sensors = Sensor(
                id: UUID(uuidString: "12222222-2222-2222-2222-222222222223")!,
                eventId: eventId,
                sensorName: "ABC",
                latitude: 100.0,
                longitude: -20.0,
                createdAt: nil
            )
            
            try await client
                .from("sensors")
                .upsert(sensors, onConflict: "id")
                .execute()

        } catch {
            print("failed \(error)")
        }
    }
}
