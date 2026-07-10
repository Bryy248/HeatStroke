//
//  HeatStrokeApp.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 30/06/26.
//

import SwiftUI
import Supabase

@main
struct HeatStroke_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            LandingPageView()
                .task {
                    do {
                        if SupabaseManager.client.auth.currentUser == nil {
                            try await SupabaseManager.client.auth.signInAnonymously()
                        }
                    } catch { print("anon sign-in failed: \(error)")}
                    await DummyDataService().seedDummyData()
                }
            
        }
    }
}
