//
//  IdentityView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 05/07/26.
//

import SwiftUI

struct IdentityView: View {
    
    @State private var bib: String = ""
    @State private var birthDate: Date = Date()
    @State private var hasBirthDate = false
    @State private var showBIBKeyboard = false
    @State private var showDatePicker = false
    @State private var goToConfirm = false
    
    var body: some View {
        NavigationStack {
            List {
                Text("BTN JAKIM 2027")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.color1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                
                Button {
                    showBIBKeyboard = true
                } label: {
                    Text(bib.isEmpty ? "BIB Number" : bib)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(bib.isEmpty ? .gray : .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                }
                .buttonStyle(.plain)
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.inputBgcolor))
                .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                
                Button {
                    showDatePicker = true
                } label: {
                    Text(hasBirthDate ? formatted(birthDate) : "Birth Date")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(hasBirthDate ? .white : .gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                }
                .buttonStyle(.plain)
                .listRowBackground(RoundedRectangle(cornerRadius: 15).fill(.inputBgcolor))
                .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                
                Button {
                    // Aksi Add Event
                    goToConfirm = true
                } label: {
                    Text("Confirm")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.color1)
                .listRowBackground(Color.clear)
                .padding(.top, 8)
            }
            .sheet(isPresented: $showBIBKeyboard) {
                TextField("BIB Number", text: $bib)
                    .font(.system(size: 16, weight: .regular))
                    .onSubmit { showBIBKeyboard = false }
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker("Birth Date", selection: $birthDate, in: ...Date(),
                               displayedComponents: .date)
                        .datePickerStyle(.wheel)
                    Button("Done") {
                        hasBirthDate = true
                        showDatePicker = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                }
            }
            .navigationDestination(isPresented: $goToConfirm) {
                IdentityVerifyView(name: "Akbar")
            }
        }
    }
    
    
    func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }
}

#Preview {
    IdentityView()
}
