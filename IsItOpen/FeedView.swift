//
//  FeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//


//import SwiftUI
//
//struct FeedView: View {
//    @EnvironmentObject var viewModel: FeedViewModel
//
//    var body: some View {
//        List(viewModel.checkIns) { checkIn in
//            VStack(alignment: .leading) {
//                Text("\(checkIn.user.username) checked in at \(checkIn.venue.name) and reports it's \(checkIn.open ? "still open" : "closed")!")
//                    .bold()
//                if !checkIn.tags.isEmpty {
//                    Text("Tags: \(checkIn.tags.joined(separator: ", "))")
//                }
//                if let comment = checkIn.comment, !comment.isEmpty {
//                    Text("Comment: \(comment)")
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Recent Check-Ins")
//        .onAppear {
//            if viewModel.isAuthenticated {
//                viewModel.loadCheckIns()
//            } else {
//                print("Not authenticated")
//            }
//        }
//    }
//}

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel

    var body: some View {
        NavigationView {
            List(viewModel.checkIns) { checkIn in
                CheckInCard(checkIn: checkIn)
            }
            .navigationTitle("Recent Check-Ins")
            .navigationBarItems(trailing: Button("Refresh") {
                viewModel.loadCheckIns()
            })
            .onAppear {
                if viewModel.isAuthenticated {
                    viewModel.loadCheckIns()
                } else {
                    print("Not authenticated")
                }
            }
        }
    }
}

struct CheckInCard: View {
    var checkIn: CheckItIn

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(checkIn.venue.name)
                    .font(.headline)
                Spacer()
                Text(checkIn.open ? "Open" : "Closed")
                    .foregroundColor(checkIn.open ? .green : .red)
                    .bold()
            }

            Text("Checked in by \(checkIn.user.username)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let comment = checkIn.comment, !comment.isEmpty {
                Text("Comment: \(comment)")
                    .italic()
            }

            if !checkIn.tags.isEmpty {
                Text("Tags: \(checkIn.tags.joined(separator: ", "))")
                    .font(.footnote)
                    .padding(.top, 5)
            }

            Divider()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
