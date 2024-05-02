import Foundation

class APIManager {
    static func fetchDataFromAPI(completion: @escaping ([Venue]) -> Void) {
        guard let url = URL(string: "https://server.whatstarted.com/api/venues") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Set the request method to GET
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                var venues = [Venue]()
                if let jsonArray = jsonArray {
                    for item in jsonArray {
                        // Parse venue data and create Venue objects
                        let venue = parseVenue(from: item)
                        venues.append(venue)
                    }
                }
                
                completion(venues) // Pass the data to the completion closure
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    static func fetchDataFromTagAPI(completion: @escaping ([Tags]?) -> Void) {
        guard let url = URL(string: "https://server.whatstarted.com/api/tags") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var tagrequest = URLRequest(url: url)
        tagrequest.httpMethod = "GET"
        
        let tagtask = URLSession.shared.dataTask(with: tagrequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("Invalid response: (response.statusCode)")
                completion(nil)
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                var tags = [Tags]()
                if let jsonArray = jsonArray {
                    for item in jsonArray {
                        let tag = parseTag(from: item)
                        tags.append(tag)
                    }
                }
                
                completion(tags)
            } catch {
                print("Error parsing JSON: (error.localizedDescription)")
                completion(nil)
            }
        }
        
        tagtask.resume()
    }

    static func postCheckInData(venue: String, comment: String, open: Bool, tags: [String], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://server.whatstarted.com/api/check-ins") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "venue": venue,
            "comment": comment,
            "open": open,
            "tags": tags
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            // Debug: Output the JSON body to the console
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Posting the following data to /api/check-ins: \(jsonString)")
            }
        } catch {
            print("Error serializing check-in data: \(error)")
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                print("Successfully posted check-in.")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response from server: \(responseString)")
                }
                completion(true)
            } else {
                print("Failed to post check-in. Status code: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Error response from server: \(responseString)")
                }
                completion(false)
            }
        }

        task.resume()
    }


    
    
    
    static func parseVenue(from json: [String: Any]) -> Venue {
        // Implement parsing logic to create a Venue object from JSON data
        // This function can be reused if needed in other parts of your code
        // Example:
        let name = json["name"] as? String ?? ""
        let googlePlaceID = json["google_place_id"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let phone = json["phone"] as? String ?? ""
        let email = json["email"] as? String ?? ""
        let website = json["website"] as? String ?? ""
        let image = json["image"] as? String ?? ""
        let type = json["type"] as? String ?? ""
        let address = json["address"] as? String ?? ""
        let city = json["city"] as? String ?? ""
        let state = json["state"] as? String ?? ""
        let zip = json["zip"] as? String ?? ""
        
        // Parse geo data
        let geoData = json["geo"] as? [String: Any] ?? [:]
        let geoType = geoData["type"] as? String ?? ""
        let coordinates = geoData["coordinates"] as? [Double] ?? []
        let geoID = geoData["_id"] as? String ?? ""
        let geo = Venue.Geo(type: geoType, coordinates: coordinates, id: geoID)
        
        // Parse hours data
        var hours = [Venue.Hours]()
        if let hoursData = json["hours"] as? [[String: Any]] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this format according to your date string format
            dateFormatter.timeZone = TimeZone(identifier: "America/St.Louis") // Assuming Central Standard Time (CST)
            
            for hourData in hoursData {
                let day = hourData["day"] as? String ?? ""
                let openString = hourData["open"] as? String ?? ""
                let closeString = hourData["close"] as? String ?? ""
                
                if let openDate = dateFormatter.date(from: openString),
                   let closeDate = dateFormatter.date(from: closeString) {
                    let hour = Venue.Hours(day: day, open: openDate, close: closeDate)
                    hours.append(hour)
                }
            }
        }
//        var hours = [Venue.Hours]()
//        if let hoursData = json["hours"] as? [[String: Any]] {
//            for hourData in hoursData {
//                let day = hourData["day"] as? String ?? ""
//                let openString = hourData["open"] as? String ?? ""
//                let closeString = hourData["close"] as? String ?? ""
//                let formatter = ISO8601DateFormatter()
//                formatter.formatOptions = [.withInternetDateTime]
//                let openDate = formatter.date(from: openString) ?? Date()
//                let closeDate = formatter.date(from: closeString) ?? Date()
//                let hour = Venue.Hours(day: day, open: openDate, close: closeDate)
//                hours.append(hour)
////            }
//            print("Hours data", hours)
//        }
        
        
        // Parse other properties
        let active = json["active"] as? Bool ?? false
        let createdString = json["created"] as? String ?? ""
        let modifiedString = json["modified"] as? String ?? ""
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let createdDate = formatter.date(from: createdString) ?? Date()
        let modifiedDate = formatter.date(from: modifiedString) ?? Date()
        let id = json["_id"] as? String ?? ""
        
        return Venue(name: name, googlePlaceID: googlePlaceID, description: description, phone: phone, email: email, website: website, image: image, type: type, address: address, city: city, state: state, zip: zip, geo: geo, hours: hours, active: active, created: createdDate, modified: modifiedDate, id: id)
    }
    //Favorites Data
    
    static func parseFavorites(from json: [String: Any]) -> Favorites {
        // Implement parsing logic to create a Venue object from JSON data
        // This function can be reused if needed in other parts of your code
        // Example:
        let name = json["name"] as? String ?? ""
        let googlePlaceID = json["google_place_id"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let phone = json["phone"] as? String ?? ""
        let email = json["email"] as? String ?? ""
        let website = json["website"] as? String ?? ""
        let image = json["image"] as? String ?? ""
        let type = json["type"] as? String ?? ""
        let address = json["address"] as? String ?? ""
        let city = json["city"] as? String ?? ""
        let state = json["state"] as? String ?? ""
        let zip = json["zip"] as? String ?? ""
        
        // Parse geo data
        let geoData = json["geo"] as? [String: Any] ?? [:]
        let geoType = geoData["type"] as? String ?? ""
        let coordinates = geoData["coordinates"] as? [Double] ?? []
        let geoID = geoData["_id"] as? String ?? ""
        let geo = Favorites.Geo(type: geoType, coordinates: coordinates, id: geoID)
        
        // Parse hours data
        var hours = [Favorites.Hours]()
        if let hoursData = json["hours"] as? [[String: Any]] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this format according to your date string format
            dateFormatter.timeZone = TimeZone(identifier: "America/St.Louis") // Assuming Central Standard Time (CST)
            
            for hourData in hoursData {
                let day = hourData["day"] as? String ?? ""
                let openString = hourData["open"] as? String ?? ""
                let closeString = hourData["close"] as? String ?? ""
                
                if let openDate = dateFormatter.date(from: openString),
                   let closeDate = dateFormatter.date(from: closeString) {
                    let hour = Favorites.Hours(day: day, open: openDate, close: closeDate)
                    hours.append(hour)
                }
            }
        }
//        var hours = [Favorites.Hours]()
//        if let hoursData = json["hours"] as? [[String: Any]] {
//            for hourData in hoursData {
//                let day = hourData["day"] as? String ?? ""
//                let openString = hourData["open"] as? String ?? ""
//                let closeString = hourData["close"] as? String ?? ""
//                let formatter = ISO8601DateFormatter()
//                formatter.formatOptions = [.withInternetDateTime]
//                let openDate = formatter.date(from: openString) ?? Date()
//                let closeDate = formatter.date(from: closeString) ?? Date()
//                let hour = Favorites.Hours(day: day, open: openDate, close: closeDate)
//                hours.append(hour)
//            }
//        }
        
        
        // Parse other properties
        let active = json["active"] as? Bool ?? false
        let createdString = json["created"] as? String ?? ""
        let modifiedString = json["modified"] as? String ?? ""
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let createdDate = formatter.date(from: createdString) ?? Date()
        let modifiedDate = formatter.date(from: modifiedString) ?? Date()
        let id = json["_id"] as? String ?? ""
        
        return Favorites(name: name, googlePlaceID: googlePlaceID, description: description, phone: phone, email: email, website: website, image: image, type: type, address: address, city: city, state: state, zip: zip, geo: geo, hours: hours, active: active, created: createdDate, modified: modifiedDate, id: id)
    }
    
    
    //Parsing Tag Data
    static func parseTag(from json: [String: Any]) -> Tags {
        let name = json["name"] as? String ?? ""
        let id = json["_id"] as? String ?? ""
        
        return Tags(name: name, id: id)
    }

        static func fetchDataFromFavAPI(completion: @escaping ([Favorites]) -> Void) {
            guard let url = URL(string: "https://server.whatstarted.com/api/accounts/favorites") else {
                print("Invalid URL")
                return
            }
            
            var tagrequest = URLRequest(url: url)
            tagrequest.httpMethod = "GET" // Set the request method to GET
            
            let tagtask = URLSession.shared.dataTask(with: tagrequest) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpTagResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpTagResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                guard let Tagdata = data else {
                    print("No Tag data received")
                    return
                }
                
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: Tagdata, options: []) as? [[String: Any]]
                    
                    var tags = [Favorites]()
                    if let jsonArray = jsonArray {
                        for item in jsonArray {
                            // Parse venue data and create Venue objects
                            let tag = parseFavorites(from: item)
                            tags.append(tag)
                        }
                    }
                    
                    completion(tags) // Pass the data to the completion closure
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            tagtask.resume()
        }
        
        
            static func fetchDataFromAchieveAPI(completion: @escaping ([Achievements]) -> Void) {
                guard let url = URL(string: "https://server.whatstarted.com/api/achievements") else {
                    print("Invalid URL")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET" // Set the request method to GET
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Invalid response")
                        return
                    }
                    
                    guard let jsonData = data else {
                        print("No data received")
                        return
                    }
                    
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
                        
                        var achievements = [Achievements]()
                        if let jsonArray = jsonArray {
                            for item in jsonArray {
                                if let achievement = parseAchievement(from: item) {
                                    achievements.append(achievement)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            completion(achievements) // Pass the data to the completion closure on the main thread
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                
                task.resume()
            }
            
            static func parseAchievement(from json: [String: Any]) -> Achievements? {
                guard let name = json["name"] as? String,
                      let description = json["description"] as? String,
                      let points = json["points"] as? Int,
                      let id = json["_id"] as? String,
                      let createdString = json["created"] as? String else {
                    return nil
                }
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                guard let created = formatter.date(from: createdString) else {
                    return nil
                }
                
                return Achievements(name: name, description: description, points: points, created: created, id: id)
            }
    static func fetchUserData(completion: @escaping (User?) -> Void) {
            guard let url = URL(string: "https://server.whatstarted.com/api/accounts/authenticated") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }

                guard let jsonData = data else {
                    print("No data received")
                    return
                }

                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let userData = jsonObject["user"] as? [String: Any] {
                        let user = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: userData))
                        DispatchQueue.main.async {
                            completion(user)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }

            task.resume()
        }
    }
        
        


