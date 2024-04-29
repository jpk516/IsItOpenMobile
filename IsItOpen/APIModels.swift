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

//    struct Geo: Codable {
//        let type: String
//        let coordinates: [Double]
//        let id: String
//    }
////
//    struct Hours: Codable {
//        let day: String
//        let open: Date
//        let close: Date
//    }
//}
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
