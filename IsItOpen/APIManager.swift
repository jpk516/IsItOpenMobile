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
    
    static func fetchDataFromTagAPI(completion: @escaping ([Tags]) -> Void) {
            guard let url = URL(string: "https://server.whatstarted.com/api/tags") else {
                print("Invalid URL")
                return
            }

            var tagrequest = URLRequest(url: url)
            tagrequest.httpMethod = "GET" // Set the request method to GET

            let tagtask = URLSession.shared.dataTask(with: tagrequest) { data, response, error in
                if let error = error {
                    print("Error: (error)")
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
                    print("Error parsing JSON: (error)")
                }
            }

            tagtask.resume()
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
    //Parsing Tag Data
        static func parseTag(from json: [String: Any]) -> Tags {
            let name = json["name"] as? String ?? ""
            let id = json["_id"] as? String ?? ""

            return Tags(name: name, id: id)
        }
}


