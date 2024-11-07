//
//  ContentView.swift
//  LearnNavigation
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI

enum Sports: String { // automatically Hashable
    case golf
    case cricket
    case soccer
}

struct Movie: Hashable {
    let name: String
}

struct ContentView: View {
    @State private var movie: Movie?
    var body: some View {
        VStack {
            NavigationLink("Go To Detail View") {
                DetailView()
            }
            NavigationLink("Navigate for Int Value", value: 1)
            NavigationLink("Navigate for String Value", value: "Hello World")
            NavigationLink("Navigating using Sports Enum", value: Sports.cricket)
            
            Button("Set Favorite Movie") {
                self.movie = Movie(name: "The Lord of the Rings")
            }.buttonStyle(.borderedProminent)
        }
        // using "for"
        .navigationDestination(for: Int.self) { intValue in
            Text("\(intValue)")
        }
        .navigationDestination(for: String.self) { stringValue in
            Text(stringValue)
        }
        .navigationDestination(for: Sports.self) { sport in
            Text(sport.rawValue)
        }
        // using "item"
        .navigationDestination(item: $movie) { movie in
            Text(movie.name)
        }
    }
}



struct DetailView: View {
    var body: some View{
        Text("Detail View")
    }
}

struct MovieListScreen: View {
    let movies = ["Lord of the Rings", "28 Days Later", "Batman"]
    var body: some View {
        List(movies, id:\.self) {movie in
//            NavigationLink(movie) {
//                MovieDetailScreen(movie: movie)
//            }
            NavigationLink {
                MovieDetailScreen(movie: movie)
            } label: {
                HStack {
                    Image(systemName: "heart")
                    Text(movie)
                }
            }

        }
    }
}

struct MovieDetailScreen: View {
    let movie: String
    var body: some View {
        Text(movie).navigationTitle(movie)
    }
}

#Preview("MovieListScreen"){
    NavigationStack{
        MovieListScreen()
    }
}

#Preview {
    NavigationStack{
        ContentView()
    }
}
