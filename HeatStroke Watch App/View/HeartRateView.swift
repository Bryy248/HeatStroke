//
//  HeartRateView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 02/07/26.
//

import SwiftUI

struct HeartRateView: View {

    @StateObject private var manager = HeartRateManager()

    var body: some View {
        VStack {
            HStack {
                Text("❤️")
                    .font(.system(size: 50))
                Spacer()
            }

            HStack {
                Text("\(manager.value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))

                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)

                Spacer()
            }
        }
        .padding()
        .onAppear(perform: manager.start)
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}

#Preview {
    HeartRateView()
}
