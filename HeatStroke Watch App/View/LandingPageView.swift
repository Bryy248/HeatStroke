//
//  LandingPage.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI
import SwiftData

struct LandingPageView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: LandingPageViewModel?
    @State private var showAddEvent: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel)
                }
                else {
                    ProgressView()
                }
            }
            .navigationTitle("Events")
            .overlay(alignment: .bottomTrailing) {
                if viewModel?.hasEvents == true {
                    addIconButton
                }
            }
            .navigationDestination(isPresented: $showAddEvent) {
                MarathonCodeView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = LandingPageViewModel(modelContext: modelContext)
            }
            else {
                viewModel?.fetchEvents()
            }
        }
    }

    @ViewBuilder
    private func content(_ viewModel: LandingPageViewModel) -> some View {
        if viewModel.upcomingEvents.isEmpty && viewModel.pastEvents.isEmpty {
            emptyState
        }
        else {
            List {
                if viewModel.upcomingEvents.isEmpty {
                    emptyUpcomingSection
                }
                else {
                    eventSection(title: "Upcoming",
                                 events: viewModel.upcomingEvents,
                                 viewModel: viewModel)
                }

                if !viewModel.pastEvents.isEmpty {
                    eventSection(title: "Past",
                                 events: viewModel.pastEvents,
                                 viewModel: viewModel)
                }
            }
        }
    }

    private var addIconButton: some View {
        Button {
            showAddEvent = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 14, weight: .semibold))
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .frame(width: 30, height: 30)
        .padding(.trailing, 8)
    }

    private var emptyState: some View {
        VStack {
            Spacer()
            Text("No Events")
                .font(.system(size: 14, weight: .medium))
            Spacer()
            addEventButton
        }
    }

    private var emptyUpcomingSection: some View {
        Section {
            Text("No Events")
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)

            addEventButton
                .frame(maxWidth: .infinity)
        }
        .listRowBackground(Color.clear)
    }

    private var addEventButton: some View {
        Button {
            showAddEvent = true
        } label: {
            Text("Add Event")
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(width: 152, height: 42)
        .buttonStyle(.borderedProminent)
        .tint(.color1)
    }

    private func eventSection(
        title: String,
        events: [Events],
        viewModel: LandingPageViewModel
    ) -> some View {
        Section {
            ForEach(events) { event in
                EventRowView(event: event)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.delete(event)
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
            }
        } header: {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .textCase(nil)
        }
    }
}

//#Preview("Empty") {
//    LandingPageView()
//        .modelContainer(for: Events.self, inMemory: true)
//}

#Preview("With Events") {
    let container = try! ModelContainer(
        for: Events.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    container.mainContext.insert(
        Events(name: "BTN JAKIM 2027", bib: "M12345",
               date: .now.addingTimeInterval(60 * 60 * 24 * 30))
    )
    container.mainContext.insert(
        Events(name: "BTN JAKIM 2027", bib: "M12345",
               date: .now.addingTimeInterval(60 * 60 * 24 * 30))
    )
    container.mainContext.insert(
        Events(name: "Bandung Half 2025", bib: "H44556",
               date: .now.addingTimeInterval(-60 * 60 * 24 * 30))
    )
    return LandingPageView()
        .modelContainer(container)
}
