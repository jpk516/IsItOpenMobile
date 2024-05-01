//
//  APIModels.swift
//  IsItOpen
//
//  Created by Steven Gibson on 4/25/24.
//

import Foundation

struct Venue: Codable, Identifiable {
    let name: String
    let googlePlaceID: String
    let description: String
    let phone: String
    let email: String
    let website: String
    let image: String
    let type: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let geo: Geo
    let hours: [Hours]
    let active: Bool
    let created: Date
    let modified: Date
    let id: String


    struct Hours: Codable {
          let day: String
          var open: Date?
          var close: Date?
      }

      struct Geo: Codable {
          let type: String
          let coordinates: [Double]
          let id: String
      }
    
  }

struct Tags: Codable {
    let name: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case id = "_id"
    }

}
//Checkins
struct CheckIn: Codable {
    let venue: String
    let user: String
    let comment: String
    let open: Bool
    let tags: [String]
    let created: Date
    let upvoteCount: Int
    let downvoteCount: Int
    let votes: [Vote]
    let hidden: Bool
    let id: String

    struct Vote: Codable {
        let user: String
        let up: Bool
        let created: Date
    }
}
//Achievments
struct Achievements: Codable {
    let name: String
    let description: String
    let points: Int
    let created: Date
    let id: String

    
    enum CodingKeys: String, CodingKey {
        case name, description, points, created
        case id = "_id"
    }
}

struct Favorites: Codable, Identifiable{
    let name: String
    let googlePlaceID: String
    let description: String
    let phone: String
    let email: String
    let website: String
    let image: String
    let type: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let geo: Geo
    let hours: [Hours]
    let active: Bool
    let created: Date
    let modified: Date
    let id: String

    struct Hours: Codable {
          let day: String
          var open: Date?
          var close: Date?
      }

      struct Geo: Codable {
          let type: String
          let coordinates: [Double]
          let id: String
      }

  }
struct Achievement: Codable {
    let achievement: String
    let awarded: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case achievement, awarded
        case id = "_id"
    }
}
struct User: Codable {
    let id: String
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let role: String
    let achievements: [Achievement]  // Assuming achievements are an array of Strings. Update if different.
    let created: String
    let disabled: Bool
    let favorites: [Favorite]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, email, firstName, lastName, role, achievements, created, disabled, favorites
    }
}
struct Favorite: Codable {
    let venue: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case venue
        case id = "_id"
    }
}
extension Venue {
    func isOpenNow() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.weekdaySymbols[calendar.component(.weekday, from: now) - 1].lowercased()
        
        guard let todayHours = hours.first(where: { $0.day.lowercased() == dayOfWeek }) else {
            return false
        }
        
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let currentTime = currentHour * 60 + currentMinute

        if let open = todayHours.open, let close = todayHours.close {
            let openHour = calendar.component(.hour, from: open)
            let openMinute = calendar.component(.minute, from: open)
            let closeHour = calendar.component(.hour, from: close)
            let closeMinute = calendar.component(.minute, from: close)

            let openingTime = openHour * 60 + openMinute
            let closingTime = closeHour * 60 + closeMinute

            return currentTime >= openingTime && currentTime <= closingTime
        }
        
        return false
    }
}
