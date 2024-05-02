//
//  LoginFeedView.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

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
    let upvoteCount: Int
    let downvoteCount: Int

    struct Venue: Codable {
        let id: String
        let name: String
        let description: String
        let phone: String
        let email: String
        let website: String
        let type: String
        let address: String
        let city: String
        let state: String
        let zip: String
        let active: Bool
        let geo: Geo
        
        struct Geo: Codable {
            let type: String
            let coordinates: [Double]
        }

        let hours: [Hour]
        
        struct Hour: Codable {
            let day: String
            let open: String?
            let close: String?
            let id: String
            
            enum CodingKeys: String, CodingKey {
                case day, open, close
                case id = "_id"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "_id", name, description, phone, email, website, type, address, city, state, zip, active, geo, hours
        }
    }

    struct User: Codable {
        let username: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", venue, comment, open, tags, user, upvoteCount, downvoteCount
    }
}


//import SwiftUI
//
//struct LoginFeedView: View {
//    @EnvironmentObject var feedViewModel: FeedViewModel
//    @State private var username: String = ""
//    @State private var password: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if feedViewModel.isAuthenticated {
//                    FeedView()
//                } else {
//                    loginForm
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//
//    var loginForm: some View {
//        VStack(spacing: 20) {
//            // Placeholder logo
//            Image("Logo") // Placeholder for your logo
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//
//            Text("Welcome! Please log in")
//                .font(.title3)
//                .foregroundColor(.gray)
//
//            // Username input
//            TextField("Username", text: $username)
//                .autocapitalization(.none)
//                .disableAutocorrection(true)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//
//            // Password input
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//                .submitLabel(.done)
//                .onSubmit {
//                    performLogin()
//                }
//
//            // Login button
//            Button("Log In") {
//                performLogin()
//            }
//            .disabled(username.isEmpty || password.isEmpty)
//            .buttonStyle(RoundedRectangleButtonStyle())
//            .padding()
//
//        }
//        .padding()
//    }
//
//    private func performLogin() {
//        feedViewModel.authenticate(username: username, password: password)
//    }
//}
//
//// Custom button style for a nicer UI

import SwiftUI

struct LoginFeedView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingResetPassword = false
    @State private var alertMessage: String?
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Logo") // Placeholder for your logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)

                Text("Welcome! Please log in")
                    .font(.title3)
                    .foregroundColor(.gray)

                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .submitLabel(.done)
                    .onSubmit {
                        performLogin()
                    }

                HStack {
                    // Log In button
                    Button("Log In") {
                        performLogin()
                    }
                    .disabled(username.isEmpty || password.isEmpty)
                    .buttonStyle(RoundedRectangleButtonStyle())
                    .padding()

                    // Reset Password button
                    Button("Reset Password") {
                        showingResetPassword = true
                    }
                    .buttonStyle(RoundedRectangleButtonStyle())
                    .padding()
                }
            }
            .padding()
            .sheet(isPresented: $showingResetPassword) {
                ResetPasswordView(showingResetPassword: $showingResetPassword, alertMessage: $alertMessage, showAlert: $showAlert)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func performLogin() {
        feedViewModel.authenticate(username: username, password: password)
    }
}

// Custom button style for a nicer UI
struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ResetPasswordView: View {
    @Binding var showingResetPassword: Bool
    @Binding var alertMessage: String?
    @Binding var showAlert: Bool
    @State private var email: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Your Password")
                .font(.headline)

            TextField("Email address", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Send Reset Email") {
                sendResetEmail()
            }
            .disabled(email.isEmpty)
            
            .padding()
        }
        .padding()
    }

    private func sendResetEmail() {
        // Here you would call your API to handle the password reset
        APIManager.postForgotPassword(email: email) { success in
            if success {
                alertMessage = "An email has been sent to reset your password."
            } else {
                alertMessage = "Failed to send reset email. Please try again later."
            }
            showAlert = true
            showingResetPassword = false
        }
    }
}

