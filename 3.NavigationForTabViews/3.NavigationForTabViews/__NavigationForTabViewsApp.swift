//
//  __NavigationForTabViewsApp.swift
//  3.NavigationForTabViews
//
//  Created by Dongjun Lee on 11/7/24.
//

import SwiftUI

@main
struct __NavigationForTabViewsApp: App {
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
        }
    }
}
