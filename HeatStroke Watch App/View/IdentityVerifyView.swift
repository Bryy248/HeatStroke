//
//  IdentityVerifyView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 05/07/26.
//

import SwiftUI

struct IdentityVerifyView: View {
    let name: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var identity: Identity?
    @State private var isLoading = false
    @State private var goToWaitingView = false
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            }
            else if let identity {
                foundView(identity)
            }
            else {
                notFoundView
            }
        }
        .task {
            await verifyIdentity()
        }
        .navigationDestination(isPresented: $goToWaitingView) {
            WaitingView()
        }
    }
    @ViewBuilder
    func foundView(_ identity: Identity) -> some View {
        ScrollView{
            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.color1)
                    .frame(width: 35, height: 35)
                    .background(.checkmarkBgcolor)
                    .clipShape(Circle())
                    .padding(.bottom, 12)
                
                Text(identity.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .padding(.bottom, 7)
                
                Text("\(identity.age) • \(identity.bib) • \(identity.category)")
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                
                Divider()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
                Text("It's you?")
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
                        goToWaitingView = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                    .frame(width: 80, height: 52)
                    .cornerRadius(100)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Verify")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.color1)
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
                
                Text("User not found")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.red)
                    .padding(.bottom, 6)
                
                Text("Check your BIB number and Birth date, try again.")
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
    func verifyIdentity() async {
        // TODO: ganti dengan cek asli (server / data lokal)
        isLoading = true
        if name == "Akbar" {
            identity = Identity(name: "Akbar Zaidan Rohman",
                                age: "20 years old",
                                bib: "M12345",
                                category: "Full Marathon")
        }
        else {
            identity = nil
        }
        isLoading = false
    }
}
struct Identity {
    let name: String
    let age: String
    let bib: String
    let category: String
}

#Preview {
    NavigationStack {
        IdentityVerifyView(name: "Akbar")
    }
}
