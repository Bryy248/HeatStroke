//
//  ContentView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 30/06/26.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button(action: openStrava) {
            Label("Buka Strava", systemImage: "figure.run")
        }
    }
    
    func openStrava() {
        if let url = URL(string: "strava://") {
            openURL(url)
        }
    }
}

#Preview {
    ContentView()
}
