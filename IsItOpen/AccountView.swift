////
////  AccountView.swift
////  IsItOpen
////
////  Created by Jimmy Keating on 4/30/24.
////
//
//import SwiftUI
//
//struct AccountView: View {
//    @State private var achievements: [Achievements] = []
//
//    var body: some View {
//        List(achievements, id: \.id) { achievement in
//            VStack(alignment: .leading) {
//                Text(achievement.name)
//                    .font(.headline)
//                Text(achievement.description)
//                    .font(.subheadline)
//                Text("Points: \(achievement.points)")
//                    .font(.caption)
//                Text("Date: \(achievement.created, formatter: DateFormatter.shortDate)")
//                    .font(.caption)
//            }
//        }
//        .onAppear {
//            APIManager.fetchDataFromAchieveAPI { fetchedAchievements in
//                self.achievements = fetchedAchievements
//            }
//        }
//        .navigationTitle("Achievements")
//    }
//}
//
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
//
//extension DateFormatter {
//    static let shortDate: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter
//    }()
//}
//import SwiftUI
//
//struct AccountView: View {
//    @State private var user: User?
//    @State private var achievements: [Achievements] = []
//
//    var body: some View {
//        VStack {
//            if let user = user {
//                VStack(alignment: .leading) {
//                    Text("Hello \(user.username)!")
//                    Text("Email: \(user.email)")
//                    Text("Role: \(user.role)")
//                    // Add other user details as needed
//                }
//                .padding()
//            }
//            
//            Divider()
//
//            List(achievements, id: \.id) { achievement in
//                VStack(alignment: .leading) {
//                    Text(achievement.name)
//                        .font(.headline)
//                    Text(achievement.description)
//                        .font(.subheadline)
//                    Text("Points: \(achievement.points)")
//                        .font(.caption)
//                }
//            }
//        }
//        .onAppear {
//            APIManager.fetchUserData { fetchedUser in
//                self.user = fetchedUser
//            }
//            APIManager.fetchDataFromAchieveAPI { fetchedAchievements in
//                self.achievements = fetchedAchievements
//            }
//        }
//        .navigationTitle("Account Details")
//    }
//}
//
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel // Assuming this holds the login state
    @State private var user: User?
    @State private var achievements: [Achievements] = []

    var body: some View {
        NavigationView {
            VStack {
                if let user = user {
                    VStack(alignment: .leading) {
                        Text("Hello \(user.username)!")
                        Text("Email: \(user.email)")
                        Text("Role: \(user.role)")
                        // Add other user details as needed
                    }
                    .padding()
                }
                
                Divider()

                List(achievements, id: \.id) { achievement in
                    VStack(alignment: .leading) {
                        Text(achievement.name)
                            .font(.headline)
                        Text(achievement.description)
                            .font(.subheadline)
                        Text("Points: \(achievement.points)")
                            .font(.caption)
                    }
                }

                Button("Logout") {
                    logout()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
            }
            .navigationBarTitle("Account Details")
            .onAppear {
                APIManager.fetchUserData { fetchedUser in
                    self.user = fetchedUser
                }
                APIManager.fetchDataFromAchieveAPI { fetchedAchievements in
                    self.achievements = fetchedAchievements
                }
            }
        }
    }

    private func logout() {
        APIManager.logout { success in
            if success {
                // Assuming `feedViewModel` controls the authentication state
                DispatchQueue.main.async {
                    feedViewModel.isAuthenticated = false // Update authentication state
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(FeedViewModel()) // Sample environment object
    }
}
