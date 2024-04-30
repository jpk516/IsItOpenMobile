//
//  CheckInViewModel.swift
//  IsItOpen
//
//  Created by Jimmy Keating on 4/25/24.
//

import Foundation

class CheckInViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var isPosting = false
    @Published var postSuccess = false

    init() {
        fetchTags()
    }
    
    func fetchTags() {
        guard let url = URL(string: "https://server.whatstarted.com/api/tags") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            if let fetchedTags = try? JSONDecoder().decode([Tag].self, from: data) {
                DispatchQueue.main.async {
                    self.tags = fetchedTags
                }
            }
        }.resume()
    }
    
    func postCheckIn(isOpen: String, tags: Set<Tag>, otherDetails: String) {
        guard let url = URL(string: "https://server.whatstarted.com/api/check-ins/") else { return }
        let selectedTags = tags.map { $0.name }
        let postData = CheckInPost(venue: "Harpo's Bar & Grill", user: "Jimmy", comment: otherDetails, open: isOpen == "Open", tags: selectedTags)
        
        guard let jsonData = try? JSONEncoder().encode(postData) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
            DispatchQueue.main.async {
                self.postSuccess = true  // You can use this to show a success message or perform some action on success
            }
        }.resume()
    }
}

struct Tag: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}

struct CheckInPost: Codable {
    let venue: String
    let user: String
    let comment: String
    let open: Bool
    let tags: [String]
}
