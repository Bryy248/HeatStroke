//
//  LargeButtonView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI

struct LargeButtonView: View {
    let action: () -> Void
    let title: String
    var body: some View {
        Button(action:action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
        }
        .frame(width: 152, height: 42)
        .buttonStyle(.borderedProminent)
        .tint(.color1)
    }
}

//#Preview {
//    LargeButtonView()
//}
