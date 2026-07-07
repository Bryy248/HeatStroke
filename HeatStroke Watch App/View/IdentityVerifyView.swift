//
//  IdentityVerifyView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 05/07/26.
//

import SwiftUI

struct IdentityVerifyView: View {
    @State private var viewModel: IdentityVerifyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var goToWaitingView = false

    init(event: Event, bib: String, birthDate: Date) {
        _viewModel = State(initialValue: IdentityVerifyViewModel(
            event: event, bib: bib, birthDate: birthDate
        ))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .found(let runner):
                foundView(runner)
            case .notFound:
                notFoundView
            }
        }
        .task {
            await viewModel.verify()
        }
        .navigationDestination(isPresented: $goToWaitingView) {
            WaitingView()
        }
    }

    @ViewBuilder
    func foundView(_ runner: Runner) -> some View {
        ScrollView {
            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.color1)
                    .frame(width: 35, height: 35)
                    .background(.checkmarkBgcolor)
                    .clipShape(Circle())
                    .padding(.bottom, 12)

                Text(runner.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .padding(.bottom, 7)

                Text(detailText(runner))
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
                        Task {
                            await viewModel.claim(runner)   // ← tandai milik user
                            goToWaitingView = true
                        }
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

    // gabungin info yang ADA di Runner
    private func detailText(_ runner: Runner) -> String {
        var parts: [String] = []
        if let age = runner.age { parts.append("\(age) years old") }
        parts.append(runner.bibNumber)
        if let gender = runner.gender { parts.append(gender) }
        return parts.joined(separator: " • ")
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

                FailButton()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    NavigationStack {
//
//    }
//}
