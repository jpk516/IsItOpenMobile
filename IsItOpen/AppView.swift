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
            AccountView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            FavoritesView()
                .tabItem{
                    Label("Favorites", systemImage: "heart.fill")
                }
            TagsView()
                .tabItem{
                    Label("Tag Test", systemImage: "circle")
                }

        }
    }
}
