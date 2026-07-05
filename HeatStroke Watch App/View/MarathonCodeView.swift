//
//  MarathonCodeView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct MarathonCodeView: View {
    @State private var code: String = ""
    @State private var isValid: Bool = true
    @State private var goToVerify: Bool = false
    @State private var showKeyboard: Bool = false
    
    var body: some View {
        VStack (alignment: .center){
            Image(systemName: "keyboard")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.color1)
                .padding(.bottom, 12)
            Text("Enter your code")
                .font(.system(size: 14, weight: .medium))
                .padding(.bottom, 8)
            Text("Check race pack for your marathon code.")
                .font(.system(size: 12, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.bottom, 14)
                .foregroundStyle(.gray)
            
            Button {
                showKeyboard = true
            } label: {
                Text("Tap to enter")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 152, height: 42)
            }
            .background(.color1)
            .clipShape(RoundedRectangle(cornerRadius: 21))
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showKeyboard) {
            TextField("Add Code", text: $code)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .onSubmit {
                    showKeyboard = false
                    goToVerify = true
                }
        }
        .navigationDestination(isPresented: $goToVerify) {
            VerifyView(code: code)
        }
    }
}

#Preview {
    MarathonCodeView()
}
