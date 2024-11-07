//
//  ContentView.swift
//  2.ProgrammaticNavigationUsingEnums
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI
import Observation

@Observable
class Router {
    
    var routes: [Route] = []
    
    func addRoute(_ route: Route) {
        routes.append(route)
    }
    
    func unwind(_ route: Route) {
        guard let index = routes.firstIndex(where: { $0 == route }) else { return }
        routes = Array(routes.prefix(upTo: index + 1))
    }
    
    func popToRoot(){
        routes = []
    }
}

enum Route: Hashable {
    case detail(Movie)
    case create
    case login
    case register
    case reviews([Review])
}

struct Movie: Hashable {
    let name: String
}

struct Review: Hashable {
    let subject: String
    let description: String
}

struct MovieDetailScreen: View {
    @Environment(Router.self) private var router
    let movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.name)
            Button("Go to Login"){
                router.addRoute(.login)
            }.buttonStyle(.borderedProminent)
        }
    }
}

struct ReviewListScreen: View {
    let reviews: [Review]
    
    var body: some View {
        Text("ReviewListScreen")
    }
}

struct LoginScreen: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            Text("LoginScreen")
            Button("Go To Register") {
                router.addRoute(.register)
            }
        }
    }
}

struct RegisterScreen: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            Text("RegisterScreen")
            Button("Go To Movie Detail Screen") {
                router.unwind(.detail(Movie(name: "Batman")))
            }
            
            Button("Pop To Root") {
                router.popToRoot()
            }
        }
    }
}

struct ContentView: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            Button("Movie Detail") {
                router.addRoute(.detail(Movie(name:"Batman")))
            }
        }
    }
    
}


// just for preview
struct ContentViewContainer: View {
    @State private var router = Router()
    
    var body: some View {
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

#Preview {
    ContentViewContainer()
}
