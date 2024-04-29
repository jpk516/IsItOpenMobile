//
//  AppView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            LoginFeedView()
                .tabItem {
                    Label("Feed", systemImage: "fork.knife")
                }
            HotView()
                .tabItem {
                    Label("What's Hot", systemImage: "flame.fill")
                }
            

        }
    }
}
