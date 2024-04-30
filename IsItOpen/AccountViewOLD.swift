//
//  AccountView.swift
//  iio2
//
//  Created by Jimmy Keating on 3/21/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = "Something went wrong. Please try again."

    var body: some View {
        NavigationView {
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
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
                    print("HTTP Status Code: \(httpResponse.statusCode)") // Logging the HTTP status code
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
