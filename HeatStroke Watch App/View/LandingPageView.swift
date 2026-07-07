//
//  LandingPage.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 04/07/26.
//

import SwiftUI

struct LandingPageView: View {
    
    @State private var viewModel: LandingPageViewModel
    
    // agar bisa preview
    private let shouldFetch: Bool
    init(
        viewModel: LandingPageViewModel = LandingPageViewModel(),
        shouldFetch: Bool = true
    ) {
        _viewModel = State(initialValue: viewModel)
        self.shouldFetch = shouldFetch
    }
    
    
    @State private var showAddEvent = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                }
                else {
                    content
                }
            }
            .navigationTitle("Events")
            .overlay(alignment: .bottomTrailing) {
                if viewModel.hasEvents {
                    addIconButton
                }
            }
            .navigationDestination(isPresented: $showAddEvent) {
                MarathonCodeView()
            }
        }
        .task {
            guard shouldFetch else { return } // untuk preview
            await viewModel.fetchEvents()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.upcomingEvents.isEmpty && viewModel.pastEvents.isEmpty {
            emptyState
        }
        else {
            List {
                if viewModel.upcomingEvents.isEmpty {
                    emptyUpcomingSection
                }
                else {
                    eventSection(
                        title: "Upcoming",
                        events: viewModel.upcomingEvents
                    )
                }

                if !viewModel.pastEvents.isEmpty {
                    eventSection(
                        title: "Past",
                        events: viewModel.pastEvents
                    )
                }
            }
        }
    }
    
    private func eventSection(
        title: String,
        events: [Event]
    ) -> some View {
        
        Section {
            ForEach(events) { event in
                if let runner = viewModel.runner(for: event) {
                    EventRowView(
                        event: event,
                        runner: runner
                    )
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.remove(event)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            
        } header: {
            Text(title)
                .textCase(nil)
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
        LargeButtonView(action: {
            showAddEvent = true
        }, title: "Add Event")
    }
}

#Preview("Empty") {
    let vm = LandingPageViewModel()
    return LandingPageView(
        viewModel: vm,
        shouldFetch: false
    )
}

#Preview("With Events") {
    let vm = LandingPageViewModel()
    let eventId = UUID()
    vm.events = [
        Event(
            id: eventId,
            name: "BTN Jakim 2027",
            location: "Jakarta",
            startTime: "2027-08-12T05:00:00.000+00:00",
            endTime: nil,
            createdAt: nil,
            code: "BTN123"
        ),
        Event(
            id: eventId,
            name: "JRF 2027",
            location: "Jakarta",
            startTime: "2024-05-01T05:00:00.000+00:00",
            endTime: nil,
            createdAt: nil,
            code: "JRF27"
        )
    ]
    
    vm.runners = [
        Runner(
            id: UUID(),
            eventId: eventId,
            name: "Brian Chang",
            bibNumber: "M12345",
            age: 21,
            gender: "Male",
            currentRiskLevel: "Low",
            lastUpdated: nil,
            createdAt: nil,
            registeredBy: nil
        )
    ]
    
    return LandingPageView(
        viewModel: vm,
        shouldFetch: false
    )
}

//#Preview("Loading") {
//    let vm = LandingPageViewModel()
//    vm.isLoading = true
//
//    return LandingPageView(viewModel: vm)
//}

//#Preview("Empty") {
//    let vm = LandingPageViewModel()
//
//    return LandingPageView(viewModel: vm)
//}

//#Preview("With Events") {
//    let vm = LandingPageViewModel()
//
//    let eventId = UUID()
//
//    vm.events = [
//        Event(
//            id: eventId,
//            name: "BTN Jakim 2027",
//            location: "Jakarta",
//            startTime: nil,
//            endTime: nil,
//            createdAt: nil
//        )
//    ]
//
//    vm.runners = [
//        Runner(
//            id: UUID(),
//            eventId: eventId,
//            name: "Brian Chang",
//            bibNumber: "M12345",
//            age: 21,
//            gender: "Male",
//            currentRiskLevel: "Low",
//            lastUpdated: nil,
//            createdAt: nil
//        )
//    ]
//
//    return LandingPageView(viewModel: vm)
//}

//#Preview("Multiple Events") {
//    let vm = LandingPageViewModel()
//
//    let event1 = UUID()
//    let event2 = UUID()
//
//    vm.events = [
//        Event(
//            id: event1,
//            name: "BTN Jakim 2027",
//            location: "Jakarta",
//            startTime: nil,
//            endTime: nil,
//            createdAt: nil
//        ),
//        Event(
//            id: event2,
//            name: "Bandung Marathon",
//            location: "Bandung",
//            startTime: nil,
//            endTime: nil,
//            createdAt: nil
//        )
//    ]
//
//    vm.runners = [
//        Runner(
//            id: UUID(),
//            eventId: event1,
//            name: "Brian",
//            bibNumber: "M12345",
//            age: 21,
//            gender: "Male",
//            currentRiskLevel: "Low",
//            lastUpdated: nil,
//            createdAt: nil
//        ),
//        Runner(
//            id: UUID(),
//            eventId: event2,
//            name: "Nabiel",
//            bibNumber: "H67890",
//            age: 25,
//            gender: "Male",
//            currentRiskLevel: "Medium",
//            lastUpdated: nil,
//            createdAt: nil
//        )
//    ]
//
//    return LandingPageView(viewModel: vm)
//}

