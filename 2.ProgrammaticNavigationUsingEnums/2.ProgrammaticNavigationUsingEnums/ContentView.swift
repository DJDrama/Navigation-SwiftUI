//
//  ContentView.swift
//  2.ProgrammaticNavigationUsingEnums
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI
import Observation

// "Navigate" Approach (Won't work for TabViews)
// Environment Value for Navigation
enum NavigationType: Hashable {
    case push(Route)
    case unwind(Route)
    case popToRoot
}

struct NavigateAction {
    typealias Action = (NavigationType) -> ()
    
    let action: Action
    
    func callAsFunction(_ navigationType: NavigationType) {
        action(navigationType)
    }
}

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue = NavigateAction { _ in
    }
}

extension EnvironmentValues {
    var navigate: (NavigateAction) { // key
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue}
    }
}

// "Router" Approach
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
  //  @Environment(Router.self) private var router
    @Environment(\.navigate) private var navigate
    let movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.name)
            Button("Go to Login"){
               // router.addRoute(.login)
                navigate(.push(.login))
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
    //@Environment(Router.self) private var router
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Text("LoginScreen")
            Button("Go To Register") {
                navigate(.push(.register))
              //  router.addRoute(.register)
            }
        }
    }
}

struct RegisterScreen: View {
   // @Environment(Router.self) private var router
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Text("RegisterScreen")
            Button("Go To Movie Detail Screen") {
                navigate(.unwind(.detail(Movie(name: "Batman"))))
             //   router.unwind(.detail(Movie(name: "Batman")))
            }
            
            Button("Pop To Root") {
                navigate(.popToRoot)
              //  router.popToRoot()
            }
        }
    }
}

struct ContentView: View {
    
    //@Environment(Router.self) private var router
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            Button("Movie Detail") {
                // router.addRoute(.detail(Movie(name:"Batman")))
                navigate(.push(.detail(Movie(name: "Batman"))))
            }
        }
    }
    
}


// Container is just for XCODE preview!
struct ContentViewContainer: View {
    //@State private var router = Router()
    
    @State private var routes: [Route] = []
    
    var body: some View {
        //NavigationStack(path: $router.routes) {
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

#Preview {
    ContentViewContainer()
}
