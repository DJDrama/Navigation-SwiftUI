//
//  __ProgrammaticNavigationUsingEnumsApp.swift
//  2.ProgrammaticNavigationUsingEnums
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI

@main
struct __ProgrammaticNavigationUsingEnumsApp: App {
    
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.routes) {
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
            }.environment(router)
        }
    }
}
