//
//  LoginFeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

import SwiftUI

struct LoginFeedView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @StateObject private var feedViewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            if isAuthenticated {
                feedList
            } else {
                loginForm
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    var loginForm: some View {
        Form {
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
            Button("Log In") {
                login()
            }
            .disabled(username.isEmpty || password.isEmpty)
        }
        .navigationBarTitle("Log In")
    }

    var feedList: some View {
        List(feedViewModel.checkIns) { checkIn in
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
            feedViewModel.loadCheckIns()
        }
    }

    func login() {
        guard let url = URL(string: "https://server.whatstarted.com/api/accounts/login") else {
            alertMessage = "Invalid server URL."
            showingAlert = true
            return
        }

        let credentials = ["username": username, "password": password]
        guard let jsonData = try? JSONEncoder().encode(credentials) else {
            alertMessage = "Failed to encode credentials."
            showingAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.isAuthenticated = true
                    } else {
                        self.alertMessage = "Authentication failed. Status code: \(httpResponse.statusCode)"
                        self.showingAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Invalid response from the server."
                    self.showingAlert = true
                }
            }
        }.resume()
    }
}
