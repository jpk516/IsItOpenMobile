//
//  RootView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/30/24.
//

import SwiftUI

//struct RootView: View {
//    @EnvironmentObject var viewModel: FeedViewModel  // Access the shared FeedViewModel instance
//
//    var body: some View {
//        if viewModel.isAuthenticated {
//            FeedView().environmentObject(viewModel)  // Pass the ViewModel to the FeedView
//        } else {
//            LoginFeedView().environmentObject(viewModel)  // Pass the ViewModel to the LoginFeedView
//        }
//    }
//}
import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: FeedViewModel

    var body: some View {
        if viewModel.isAuthenticated {
            AppView() // Navigate to HomeView if authenticated
        } else {
            LoginFeedView() // Show LoginFeedView if not authenticated
        }
    }
}
