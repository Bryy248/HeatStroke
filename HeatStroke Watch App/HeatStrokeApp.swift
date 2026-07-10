//
//  HeatStrokeApp.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 30/06/26.
//

import SwiftUI
import WatchKit

@main
struct HeatStroke_Watch_AppApp: App {
    init() {
            NotificationManager.shared.requestPermission()
        }
    var body: some Scene {
        WindowGroup {
            LandingPageView()
                .task {
                    await DummyDataService().seedDummyData()
                }
        }
        WKNotificationScene(controller: NotificationController.self, category: "HIGH_ALERT")
        WKNotificationScene(controller: NotificationController.self, category: "DANGER_ALERT")
    }
}
