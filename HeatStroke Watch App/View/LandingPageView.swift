//
//  LandingPage.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct LandingPageView: View {
    
    var code:Int = 1
    var code2: Int = 1
    
    @State var showAddEvent: Bool = false
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Events")
                .overlay(alignment: .bottomTrailing) {
                    if code != 0 {
                        Button {
                            showAddEvent = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .frame(width: 30, height: 3)
                        .padding(.trailing, 8)
                    }
                }
                .navigationDestination(isPresented: $showAddEvent) {
                    MarathonCodeView()
                }
        }
    }
    @ViewBuilder
    var content: some View {
        
        if code == 0 {
            if code2 == 0 {
                Spacer()
                Text("No Events")
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                Button {
                    // Aksi Button Ke MarathonCodeView
                } label: {
                    Text("Add Event")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(width: 152, height: 42)
                .buttonStyle(.borderedProminent)
                .tint(.color1)
            }
            else {
                List {
                    Section {
                        Text("No Events")
                            .font(.system(size: 14, weight: .medium))
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            showAddEvent = true
                        } label: {
                            Text("Add Event")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(width: 152, height: 42)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .tint(.color1)
                    }
                    .listRowBackground(Color.clear)
                    Section {
                        VStack(alignment: .leading) {
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 14, weight: .semibold))
                            HStack {
                                Text("BIB:").fontWeight(.light)
                                Text("M12345").fontWeight(.medium)
                            }
                            .font(.system(size: 11))
                            Text("Aug 12, 04:30 WIB")
                                .font(.system(size: 11, weight: .light))
                        }
                        .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // aksi hapus di sini
                            } label: {
                                Label("Hapus", systemImage: "trash")
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 14, weight: .semibold))
                            HStack {
                                Text("BIB:")
                                    .fontWeight(.light)
                                Text("M12345")
                                    .fontWeight(.medium)
                            }
                            .font(.system(size: 11))
                            Text("Aug 12, 04:30 WIB")
                                .font(.system(size: 11, weight: .light))
                        }
                        .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // aksi hapus di sini
                            } label: {
                                Label("Hapus", systemImage: "trash")
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 14, weight: .semibold))
                            HStack {
                                Text("BIB:").fontWeight(.light)
                                Text("M12345").fontWeight(.medium)
                            }
                            .font(.system(size: 11))
                            Text("Aug 12, 04:30 WIB")
                                .font(.system(size: 11, weight: .light))
                        }
                        .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // aksi hapus di sini
                            } label: {
                                Label("Hapus", systemImage: "trash")
                            }
                        }
                    } header: {
                        Text("Past")
                            .font(.system(size: 11, weight: .medium))
                            .textCase(nil)
                    }
                }
            }
        }
        else {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:").fontWeight(.light)
                            Text("M12345").fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:")
                                .fontWeight(.light)
                            Text("M12345")
                                .fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:").fontWeight(.light)
                            Text("M12345").fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                } header: {
                    Text("Upcoming")
                        .font(.system(size: 11, weight: .medium))
                        .textCase(nil)
                }
                Section {
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:").fontWeight(.light)
                            Text("M12345").fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:")
                                .fontWeight(.light)
                            Text("M12345")
                                .fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("BTN JAKIM 2027")
                            .font(.system(size: 14, weight: .semibold))
                        HStack {
                            Text("BIB:").fontWeight(.light)
                            Text("M12345").fontWeight(.medium)
                        }
                        .font(.system(size: 11))
                        Text("Aug 12, 04:30 WIB")
                            .font(.system(size: 11, weight: .light))
                    }
                    .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // aksi hapus di sini
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                } header: {
                    Text("Past")
                        .font(.system(size: 11, weight: .medium))
                        .textCase(nil)
                }
            }
        }
    }
}
#Preview {
    LandingPageView()
}
