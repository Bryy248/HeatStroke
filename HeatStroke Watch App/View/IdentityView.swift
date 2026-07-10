//
//  IdentityView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 05/07/26.
//

import SwiftUI

struct IdentityView: View {
    
    @State private var viewModel: IdentityViewModel
    
    init(event: Event) {
            _viewModel = State(initialValue: IdentityViewModel(event: event))
        }
    
    var body: some View {
//        NavigationStack {
            List {
                Text(viewModel.eventName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                
                Button {
                    viewModel.showBIBKeyboard = true
                } label: {
                    Text(viewModel.bib.isEmpty ? "BIB Number" : viewModel.bib)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(viewModel.bib.isEmpty ? .gray : .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                }
                .buttonStyle(.plain)
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.inputBgcolor))
                .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                
                Button {
                    viewModel.showDatePicker = true
                } label: {
                    Text(viewModel.hasBirthDate ? formatted(viewModel.birthDate) : "Birth Date")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(viewModel.hasBirthDate ? .white : .gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                }
                .buttonStyle(.plain)
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.inputBgcolor))
                .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                
                Button {
                    viewModel.goToConfirm = true
                } label: {
                    Text("Confirm")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.color1)
                .listRowBackground(Color.clear)
                .padding(.top, 8)
                .disabled(!viewModel.canConfirm)
            }
            .sheet(isPresented: $viewModel.showBIBKeyboard) {
                TextField("BIB Number", text: $viewModel.bib)
                    .font(.system(size: 16, weight: .regular))
                    .onSubmit { viewModel.showBIBKeyboard = false }
            }
            .sheet(isPresented: $viewModel.showDatePicker) {
                VStack {
                    DatePicker("Birth Date", selection: $viewModel.birthDate, in: ...Date(),
                               displayedComponents: .date)
                        .datePickerStyle(.wheel)
                    Button("Done") {
                        viewModel.birthDate = Calendar.current.startOfDay(for: viewModel.birthDate)
                        viewModel.hasBirthDate = true
                        viewModel.showDatePicker = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                }
            }
            .navigationDestination(isPresented: $viewModel.goToConfirm) {
                IdentityVerifyView(
                    event: viewModel.event,
                    bib: viewModel.bib,
                    birthDate: viewModel.birthDate
                )
            }
//        }
    }
    
    
    func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }
}

#Preview {
    IdentityView(
        event: Event(
            id: UUID(),
            name: "BTN JAKIM 2027",
            location: "Jakarta, Indonesia",
            startTime: nil,
            endTime: nil,
            createdAt: nil,
            code: "BTN123"
        )
    )
}
