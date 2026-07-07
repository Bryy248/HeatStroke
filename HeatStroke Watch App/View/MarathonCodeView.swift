//
//  MarathonCodeView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct MarathonCodeView: View {
    @State private var viewModel = MarathonCodeViewModel()
    
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
            
            LargeButtonView(action: {
                viewModel.showKeyboard = true
            }, title: "Tap to enter")
        }
        .sheet(isPresented: $viewModel.showKeyboard) {
            TextField("Add Code", text: $viewModel.code)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .onSubmit {
                    viewModel.submit()
                }
        }
        .navigationDestination(isPresented: $viewModel.goToVerify) {
            VerifyView(code: viewModel.code)
        }
    }
}

#Preview {
    MarathonCodeView()
}
