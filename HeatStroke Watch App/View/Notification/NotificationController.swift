//
//  NotificationController.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 09/07/26.
//

import SwiftUI
import UserNotifications
import WatchKit

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var category = ""
    var notifTitle = ""
    var notifMessage = ""

    override var body: NotificationView {
        NotificationView(category: category,
                             title: notifTitle,
                             message: notifMessage)
    }

    override func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        category    = content.categoryIdentifier
        notifTitle  = content.title
        notifMessage = content.body
    }
}
