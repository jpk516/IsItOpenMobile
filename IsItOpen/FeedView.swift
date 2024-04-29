//
//  FeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

//import Foundation
//
//struct CheckItIn: Codable, Identifiable {
//    let id: String
//    let venue: Venue
//    let comment: String?
//    let open: Bool
//    let tags: [String]
//    let user: User
//    
//    struct Venue: Codable {
//        let id: String
//        let name: String
//    }
//    
//    struct User: Codable {
//        let username: String
//    }
//}
//
//class FeedViewModel: ObservableObject {
//    @Published var isAuthenticated = false
//    @Published var checkIns: [CheckItIn] = []
//
//    func loadCheckIns() {
//        guard isAuthenticated else { return }
//        guard let url = URL(string: "https://server.whatstarted.com/api/check-ins/recent/") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode([CheckItIn].self, from: data) {
//                    DispatchQueue.main.async {
//                        self.checkIns = decodedResponse
//                    }
//                    return
//                }
//            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//        }.resume()
//    }
//}
//
//
//import SwiftUI
//
//struct FeedView: View {
//    @StateObject private var viewModel = FeedViewModel()
//
//    var body: some View {
//        Group {
//            if viewModel.isAuthenticated {
//                List(viewModel.checkIns) { checkIn in
//                    VStack(alignment: .leading) {
//                        Text("\(checkIn.user.username) checked in at \(checkIn.venue.name) and reports it's \(checkIn.open ? "still open" : "closed")!")
//                            .bold()
//                        if !checkIn.tags.isEmpty {
//                            Text("Tags: \(checkIn.tags.joined(separator: ", "))")
//                        }
//                        if let comment = checkIn.comment, !comment.isEmpty {
//                            Text("Comment: \(comment)")
//                        }
//                    }
//                    .padding()
//                }
//                .navigationTitle("Recent Check-Ins")
//                .onAppear {
//                    viewModel.loadCheckIns()
//                }
//            } else {
//                LoginView(isAuthenticated: $viewModel.isAuthenticated)
//            }
//        }
//    }
//}

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel

    var body: some View {
        List(viewModel.checkIns) { checkIn in
            VStack(alignment: .leading) {
                Text("\(checkIn.user.username) checked in at \(checkIn.venue.name) and reports it's \(checkIn.open ? "still open" : "closed")!")
                    .bold()
                if !checkIn.tags.isEmpty {
                    Text("Tags: \(checkIn.tags.joined(separator: ", "))")
                }
                if let comment = checkIn.comment, !comment.isEmpty {
                    Text("Comment: \(comment)")
                }
            }
            .padding()
        }
        .navigationTitle("Recent Check-Ins")
        .onAppear {
            if viewModel.isAuthenticated {
                viewModel.loadCheckIns()
            } else {
                print("Not authenticated")
            }
        }
    }
}
