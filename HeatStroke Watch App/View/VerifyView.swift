//
//  VerifyView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct VerifyView: View {
    let code: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var event: Events?
    @State private var isLoading = false
    @State private var goToIdentityView = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            }
            else if let event {
                foundView(event)
            }
            else {
                notFoundView
            }
        }
        .task {
            await verifyCode()
        }
        .navigationDestination(isPresented: $goToIdentityView) {
            IdentityView()
        }
    }
    
    @ViewBuilder
    func foundView(_ event: Events) -> some View {
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
                
                Text("\(event.date) • \(event.location)")
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
    
    func verifyCode() async {
        // TODO: ganti dengan cek asli (server / data lokal)
        isLoading = true
        if code == "BTN123" {
            event = Events(name: "BTN JAKIM 2027",
                          date: "Aug 12, 2027 05:00 WIB",
                          location: "Jakarta, Indonesia")
        }
        else {
            event = nil
        }
        isLoading = false
    }
}

// model sederhana
struct Events {
    let name: String
    let date: String
    let location: String
}

#Preview {
    NavigationStack {
        VerifyView(code: "BTN123")
    }
}
