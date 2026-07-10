//
//  ConfirmationView.swift
//  HeatStroke
//
//  Created by Brian Juniarta Darmadi on 10/07/26.
//
import SwiftUI

struct ConfirmationView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.color1)
                    .frame(width: 35, height: 35)
                    .background(.checkmarkBgcolor)
                    .clipShape(Circle())
                    .padding(.bottom, 12)

                Text("You're Registered")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .padding(.bottom, 6)

                Text("Your data has been registered successfully.")
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 14)

                Button("Back to Home") {
                    NotificationCenter.default.post(name: .goHome, object: nil)
                }
                .buttonStyle(.borderedProminent)
                .tint(.color1)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension Notification.Name {
    static let goHome = Notification.Name("goHome")
}
