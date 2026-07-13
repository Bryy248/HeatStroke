//
//  NotificationView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 09/07/26.
//

import SwiftUI

struct NotificationView: View {
    let category: String
    let title: String
    let message: String
    
    private var style: NotifStyle { NotifStyle.forCategory(category) }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: style.icon)
                .font(.largeTitle)
                .foregroundStyle(style.tint)
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NotificationView(category: "DANGER_ALERT", title: "Slow Down", message: "Take it easy, your Heart Rate too high and the envyronment too hot also")
}
