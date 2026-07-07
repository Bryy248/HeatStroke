//
//  VerifyView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct VerifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var goToIdentityView = false
    @State private var viewModel: VerifyViewModel
    
    init(code: String) {
            _viewModel = State(initialValue: VerifyViewModel(code: code))
        }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .found(let event):
                foundView(event)
            case .notFound:
                notFoundView
            }
        }
        .task {
            await viewModel.verify()
        }
        .navigationDestination(isPresented: $goToIdentityView) {
            IdentityView()
        }
    }
    
    @ViewBuilder
    func foundView(_ event: Event) -> some View {
        ScrollView{
            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.color1)
                    .frame(width: 35, height: 35)
                    .background(.checkmarkBgcolor)
                    .clipShape(Circle())
                    .padding(.bottom, 12)
                
                Text(event.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .padding(.bottom, 7)
                
                // kalau nanti sudah ada date
//                Text("\(event.date) • \(event.location)")
                Text(viewModel.dateLocationText(for: event))
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                
                Divider()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
                Text("Is this your event?")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 10)
                
                HStack(spacing: 5) {
                    Button("No") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .frame(width: 80, height: 52)
                    .cornerRadius(100)
                    Button("Yes") {
                        goToIdentityView = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                    .frame(width: 80, height: 52)
                    .cornerRadius(100)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var notFoundView: some View {
        ScrollView {
            VStack {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(width: 35, height: 35)
                    .background(.xmarkBgcolor)
                    .clipShape(Circle())
                    .padding(.bottom, 12)
                
                Text("Event not found")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.red)
                    .padding(.bottom, 6)
                
                Text("Check race pack and try again.")
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                
                Button("Try Again") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .padding(.top, 16)
                .frame(width: 168, height: 52)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Found") {
    NavigationStack {
        VerifyView(code: "BTN123")
    }
}

#Preview("Not Found") {
    NavigationStack {
        VerifyView(code: "XXXXX")
    }
}
