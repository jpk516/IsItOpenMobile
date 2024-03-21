//
//  ContentView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView() // The existing content of your ContentView now moved to HomeView
        }
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
    }
}
