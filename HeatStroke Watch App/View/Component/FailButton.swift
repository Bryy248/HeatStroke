//
//  FailButton.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI

struct FailButton: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button("Try Again") {
            dismiss()
        }
        .foregroundStyle(.failText)
        .buttonStyle(.bordered)
        .padding(.top, 16)
        .frame(width: 168, height: 52)
        .tint(.fail)

    }
}

#Preview {
    FailButton()
}
