//
//  IsItOpenApp.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 3/19/24.
//

import SwiftUI

@main
struct IsItOpenApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView()
                    .tabItem {
                        Label("Home", systemImage: "map")
                    }
                
                AllVenuesView(venues: []) // Pass your venues list here
                    .tabItem {
                        Label("Venues", systemImage: "list.dash")
                    }
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
            }
        }
    }
}
