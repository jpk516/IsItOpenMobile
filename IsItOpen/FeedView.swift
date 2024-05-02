//
//  FeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel

    var body: some View {
        NavigationView {
            List(viewModel.checkIns) { checkIn in
                CheckInCard(checkIn: checkIn)
            }
            .refreshable {
                // Call the function to reload data when user pulls to refresh
                viewModel.loadCheckIns()
            }
            .navigationBarTitle("Recent Check-Ins", displayMode: .inline)
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
    @EnvironmentObject var viewModel: FeedViewModel
    var checkIn: CheckItIn

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text(checkIn.venue.name)
                    .font(.headline)
                Text(checkIn.open ? "Open" : "Closed")
                    .foregroundColor(checkIn.open ? .green : .red)
                    .bold()
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
            }

            Divider()

            HStack {
                // Upvote button
                Button(action: { vote(up: true) }) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(.green)
                        Text("\(checkIn.upvoteCount)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.green.opacity(0.2))
                .frame(maxWidth: .infinity) // Ensure it takes half the width

                // Downvote button
                Button(action: { vote(up: false) }) {
                    HStack {
                        Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(.red)
                        Text("\(checkIn.downvoteCount)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.red.opacity(0.2))
                .frame(maxWidth: .infinity) // Ensure it takes half the width
            }
            .frame(height: 44) // Fixed height for both buttons
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func vote(up: Bool) {
        APIManager.postVote(checkInId: checkIn.id, up: up) { success in
            if success {
                print("Vote successful")
                viewModel.loadCheckIns()
            } else {
                print("Vote failed")
            }
        }
    }
}
