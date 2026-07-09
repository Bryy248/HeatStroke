//
//  NotificationManager'.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 08/07/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()   // satu instance dipakai se-app
    private init() { }
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, error in
                print(granted ? "Notif diizinkan" : "Notif ditolak")
            }
    }
    
    func sendHeatAlert() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            self.fireNotification()
        }
    }
    
    private func fireNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Heat risk rising"
        content.body  = "Slow down and hydrate now."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    // test
    func sendTestNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("Notif belum diizinkan!")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Test notif"
            content.body  = "Kalau kamu lihat ini, notif jalan!"
            content.sound = .default

            // 5 detik cukup buat kamu keburu keluar ke background
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            print("Notif dah kekirim")
            UNUserNotificationCenter.current().add(request)
        }
    }
}
