import Foundation

class APIManager {
    // deals with gathering data from API
    //Venues
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
    //Tags
    static func fetchDataFromTagAPI(completion: @escaping ([Tags]) -> Void) {
        guard let url = URL(string: "https://server.whatstarted.com/api/tags") else {
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
                
                var tags = [Tags]()
                if let jsonArray = jsonArray {
                    for item in jsonArray {
                        // Parse venue data and create Venue objects
                        let tag = parseTag(from: item)
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
    
    //Checkins
    static func fetchDataFromCheckInAPI(completion: @escaping ([CheckIn]) -> Void) {
        guard let url = URL(string: "https://server.whatstarted.com/api/check-ins") else {
            print("Invalid URL")
            return
        }
        
        var checkinrequest = URLRequest(url: url)
        checkinrequest.httpMethod = "GET" // Set the request method to GET
        
        let checkintask = URLSession.shared.dataTask(with: checkinrequest) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpCheckInResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpCheckInResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let CheckIndata = data else {
                print("No Tag data received")
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: CheckIndata, options: []) as? [[String: Any]]
                
                var checkinlist = [CheckIn]()
                if let jsonArray = jsonArray {
                    for item in jsonArray {
                        // Parse venue data and create Venue objects
                        let checkin = parseCheckin(from: item)
                        checkinlist.append(checkin)
                    }
                }
                
                completion(checkinlist) // Pass the data to the completion closure
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        checkintask.resume()
    }
    
    //checkin votes

    
    
    //Account Login
    static func fetchDataLoginAPI(completion: @escaping ([Login]) -> Void) {
        guard let loginurl = URL(string: "https://server.whatstarted.com/api/accounts/login") else {
            print("Invalid URL")
            return
        }
        
        var Accountrequest = URLRequest(url: loginurl)
        Accountrequest.httpMethod = "GET" // Set the request method to GET
        
        let Accounttask = URLSession.shared.dataTask(with: Accountrequest) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpAccountResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpAccountResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let Accountdata = data else {
                print("No Tag data received")
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: Accountdata, options: []) as? [[String: Any]]
                
                var accountlist = [Login]()
                if let jsonArray = jsonArray {
                    for item in jsonArray {
                        // Parse venue data and create Venue objects
                        let login = parseLogin(from: item)
                        accountlist.append(login)
                    }
                }
                
                completion(accountlist) // Pass the data to the completion closure
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        Accounttask.resume()
    }
    //Account Favorites
    //Achievements
    //
    
//Parsing Data for each Api call
    
    //Parsing Venue Data
    static func parseVenue(from json: [String: Any]) -> Venue {
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
            for hourData in hoursData {
                let day = hourData["day"] as? String ?? ""
                let openString = hourData["open"] as? String ?? ""
                let closeString = hourData["close"] as? String ?? ""
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                let openDate = formatter.date(from: openString) ?? Date()
                let closeDate = formatter.date(from: closeString) ?? Date()
                let hour = Venue.Hours(day: day, open: openDate, close: closeDate)
                hours.append(hour)
            }
        }
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
    
    //Parsing Tag Data
    static func parseTag(from json: [String: Any]) -> Tags {
        let name = json["name"] as? String ?? ""
        let id = json["_id"] as? String ?? ""
        
        return Tags(name: name, id: id)
    }
    
    //Parse Login Data
    static func parseLogin(from json: [String: Any]) -> Login {
        let username = json["username"] as? String ?? ""
        let password = json["password"] as? String ?? ""

        return Login(username: username, password: password)
    }
    
    //Parse Checkin Data
    static func parseCheckin(from json: [String: Any]) -> CheckIn {
        let venue = json["venue"] as? String ?? ""
        let user = json["user"] as? String ?? ""
        let comment = json["comment"] as? String ?? ""
        let tags = json["tags"] as? [String] ?? []
        
        let open = json["open"] as? Bool ?? false
        let hidden = json["hidden"] as? Bool ?? false
        
        let createdString = json["created"] as? String ?? ""
        let dateFormatter = ISO8601DateFormatter()
        let created = dateFormatter.date(from: createdString) ?? Date()
        
        
        let upvoteCount = json["upvoteCount"] as? Int ?? 0
        let downvoteCount = json["downvoteCount"] as? Int ?? 0
        let id = json["_id"] as? String ?? ""
        
        var votes = [CheckIn.Vote]()
            if let votesData = json["votes"] as? [[String: Any]] {
                for voteData in votesData {
                    if let voteUser = voteData["user"] as? String,
                       let up = voteData["up"] as? Bool,
                       let createdString = voteData["created"] as? String,
                       let createdDate = dateFormatter.date(from: createdString) {
                        let vote = CheckIn.Vote(user: voteUser, up: up, created: createdDate)
                        votes.append(vote)
                    }
                }
            }

        return CheckIn(venue: venue, user: user, comment: comment, open: open, tags: tags, created: created, upvoteCount: upvoteCount, downvoteCount: downvoteCount, votes: votes, hidden: hidden, id: id)
    }
}



