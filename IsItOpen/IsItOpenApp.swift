//
//  IsItOpenApp.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 3/19/24.
//

//import SwiftUI
//
//@main
//struct IsItOpenApp: App {
//    var body: some Scene {
//        WindowGroup {
//            AppView()
////                .environmentObject(UserSession())
//        }
//    }
//}

import SwiftUI


@main
struct IsItOpenApp: App {
    @StateObject private var feedViewModel = FeedViewModel()  // Create a FeedViewModel instance

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(feedViewModel)  // Pass it as an EnvironmentObject
        }
    }
}
