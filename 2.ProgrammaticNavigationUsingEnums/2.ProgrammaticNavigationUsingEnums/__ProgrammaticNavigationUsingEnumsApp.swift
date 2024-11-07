//
//  __ProgrammaticNavigationUsingEnumsApp.swift
//  2.ProgrammaticNavigationUsingEnums
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI

@main
struct __ProgrammaticNavigationUsingEnumsApp: App {
    
    //@State private var router = Router()
    
    @State private var routes: [Route] = []
    
    var body: some Scene {
        WindowGroup {
            // NavigationStack(path: $router.routes) {
            NavigationStack(path: $routes) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .create:
                            Text("Create")
                        case .detail(let movie):
                            MovieDetailScreen(movie: movie)
                        case .login:
                            LoginScreen()
                        case .register:
                            RegisterScreen()
                        case .reviews(let reviews):
                            ReviewListScreen(reviews: reviews)
                            
                        }
                    }
            }
            //.environment(router)
            .environment(\.navigate, NavigateAction(action: performNavigation))
        }
    }
    
    private func performNavigation(_ navigationType: NavigationType){
        switch navigationType {
        case .push(let route):
            routes.append(route)
        case .unwind(let route):
            guard let index = routes.firstIndex(where: {$0 == route}) else { return }
            routes = Array(routes.prefix(upTo: index + 1))
        case .popToRoot:
            routes = []
        }
        
    }
}
