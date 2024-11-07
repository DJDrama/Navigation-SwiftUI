//
//  ContentView.swift
//  3.NavigationForTabViews
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI
import Observation

@Observable
class Router {
    // var backyardRoutes: [BirdRoute] = []
    var birdRoutes: [BirdRoute] = []
    var plantRoutes: [PlantRoute] = []
}

enum BirdRoute: Hashable {
    case myBirds
}
enum PlantRoute: Hashable {
    case myPlants
}

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case backyards
    case birds
    case plants
    
    var id: AppScreen { // Already Hashable
        self
    }
}

struct PlantsNavigationStack: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        // how environment works in SwiftUI
        @Bindable var router = router
        
        NavigationStack(path: $router.plantRoutes) {
            VStack {
                Button("Go to My Plants") {
                    router.plantRoutes.append(.myPlants)
                }
            }.navigationDestination(for: PlantRoute.self) { plantRoute in
                switch plantRoute {
                case .myPlants:
                    Text("My Plants")
                }
            }
        }
    }
}

struct BirdsNavigationStack: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        // how environment works in SwiftUI
        @Bindable var router = router
        
        NavigationStack(path: $router.birdRoutes) {
            Button("Go to My Birds") {
                router.birdRoutes.append(.myBirds)
            }.navigationDestination(for: BirdRoute.self) { birdRoute in
                switch birdRoute {
                case .myBirds :
                    Text("My Birds")
                }
            }
        }
    }
}

struct BackyardNavigationStack: View {
    var body: some View {
        NavigationStack {
            List(1...10, id: \.self) { index in
                NavigationLink {
                    Text("Backyard Detail")
                } label: {
                    Text("Backyard \(index)")
                }
            }.navigationTitle("Backyards")
        }
    }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .backyards:
            Label("Backyards", systemImage: "tree")
        case .birds:
            Label("Birds", systemImage: "bird")
        case .plants:
            Label("Plants", systemImage: "leaf")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .backyards:
            BackyardNavigationStack()
        case .birds:
            BirdsNavigationStack()
        case .plants:
            PlantsNavigationStack()
        }
    }
}

struct AppTabView: View {
    @Binding var selection: AppScreen?
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen)
                    .tabItem { screen.label }
            }
        }
    }
}

struct ContentView: View {
    @State private var selection: AppScreen? = .backyards
    
    var body: some View {
        AppTabView(selection: $selection)
    }
}

#Preview {
    ContentView()
        .environment(Router())
}
