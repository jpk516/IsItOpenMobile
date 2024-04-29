//
//  LoginFeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

//import SwiftUI
//
//struct LoginFeedView: View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var isAuthenticated: Bool = false
//    @State private var showingAlert = false
//    @State private var alertMessage: String = ""
//    @StateObject private var feedViewModel = FeedViewModel()
//
//    var body: some View {
//        NavigationView {
//            if isAuthenticated {
//                feedList
//            } else {
//                loginForm
//            }
//        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    var loginForm: some View {
//        Form {
//            TextField("Username", text: $username)
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//            SecureField("Password", text: $password)
//            Button("Log In") {
//                login()
//            }
//            .disabled(username.isEmpty || password.isEmpty)
//        }
//        .navigationBarTitle("Log In")
//    }
//
//    var feedList: some View {
//        List(feedViewModel.checkIns) { checkIn in
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
//            feedViewModel.loadCheckIns()
//        }
//    }
//
//    func login() {
//        guard let url = URL(string: "https://server.whatstarted.com/api/accounts/login") else {
//            alertMessage = "Invalid server URL."
//            showingAlert = true
//            return
//        }
//
//        let credentials = ["username": username, "password": password]
//        guard let jsonData = try? JSONEncoder().encode(credentials) else {
//            alertMessage = "Failed to encode credentials."
//            showingAlert = true
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.alertMessage = error.localizedDescription
//                    self.showingAlert = true
//                }
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                DispatchQueue.main.async {
//                    if httpResponse.statusCode == 200 {
//                        self.isAuthenticated = true
//                    } else {
//                        self.alertMessage = "Authentication failed. Status code: \(httpResponse.statusCode)"
//                        self.showingAlert = true
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.alertMessage = "Invalid response from the server."
//                    self.showingAlert = true
//                }
//            }
//        }.resume()
//    }
//}
import SwiftUI

struct LoginFeedView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @StateObject private var feedViewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            if feedViewModel.isAuthenticated {
                FeedView().environmentObject(feedViewModel)
            } else {
                loginForm
            }
        }
    }

    var loginForm: some View {
        Form {
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
            Button("Log In") {
                feedViewModel.authenticate(username: username, password: password)
            }
            .disabled(username.isEmpty || password.isEmpty)
        }
        .navigationBarTitle("Log In")
    }
}

// ViewModel to manage authentication and check-in data
//class FeedViewModel: ObservableObject {
//    @Published var isAuthenticated = false
//    @Published var checkIns: [CheckItIn] = []
//
//    func authenticate(username: String, password: String) {
//        guard let url = URL(string: "https://server.whatstarted.com/api/accounts/login") else { return }
//
//        let credentials = ["username": username, "password": password]
//        guard let jsonData = try? JSONEncoder().encode(credentials) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let httpResponse = response as? HTTPURLResponse {
//                DispatchQueue.main.async {
//                    self.isAuthenticated = httpResponse.statusCode == 200
//                    if self.isAuthenticated {
//                        self.loadCheckIns()
//                    }
//                }
//            }
//        }.resume()
//    }
//
//    func loadCheckIns() {
//        guard let url = URL(string: "https://server.whatstarted.com/api/check-ins/") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let data = data, let decodedResponse = try? JSONDecoder().decode([CheckItIn].self, from: data) {
//                DispatchQueue.main.async {
//                    self.checkIns = decodedResponse
//                }
//            } else {
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }.resume()
//    }
//}

import Foundation

class FeedViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var checkIns: [CheckItIn] = []

    func authenticate(username: String, password: String) {
        guard let url = URL(string: "https://server.whatstarted.com/api/accounts/login") else {
            print("Login URL is incorrect")
            return
        }

        let credentials = ["username": username, "password": password]
        guard let jsonData = try? JSONEncoder().encode(credentials) else {
            print("Failed to encode login credentials")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        print("Attempting to authenticate with URL: \(url)")
        print("Payload: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON Data")")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Authentication failed with error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Authentication response status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    self.isAuthenticated = httpResponse.statusCode == 200
                    if self.isAuthenticated {
                        print("Authentication successful")
                        self.loadCheckIns()
                    } else {
                        print("Authentication failed with status: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }

    func loadCheckIns() {
        guard isAuthenticated, let url = URL(string: "https://server.whatstarted.com/api/check-ins/recent/") else {
            print("User not authenticated or check-ins URL is incorrect")
            return
        }

        print("Loading check-ins from URL: \(url)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fetch check-ins failed with error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Received response status code: \(httpResponse.statusCode)")
            }
            if let data = data {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                if let decodedResponse = try? JSONDecoder().decode([CheckItIn].self, from: data) {
                    DispatchQueue.main.async {
                        self.checkIns = decodedResponse
                        print("Check-ins successfully decoded and loaded")
                    }
                } else {
                    print("Failed to decode check-ins")
                }
            }
        }.resume()
    }
}


struct CheckItIn: Codable, Identifiable {
    let id: String
    let venue: Venue
    let comment: String?
    let open: Bool
    let tags: [String]
    let user: User

    struct Venue: Codable {
        let id: String
        let name: String
    }

    struct User: Codable {
        let username: String
    }
}

//struct CheckItIn: Codable, Identifiable {
//    let venue: String
//    let user: User
//    let comment: String
//    let open: Bool
//    let tags: [String]
//    let created: Date
//    let upvoteCount: Int
//    let downvoteCount: Int
//    let votes: [Vote]
//    let hidden: Bool
//    let id: String
//
//    struct Vote: Codable {
//        let user: String
//        let up: Bool
//        let created: Date
//    }
//        struct User: Codable {
//            let username: String
//        }
//}
