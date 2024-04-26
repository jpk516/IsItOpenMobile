//
//  APIDeletes.swift
//  IsItOpen
//
//  Created by Steven Gibson on 4/25/24.
//

import Foundation
// Deals with Api delete end points

//class APIDeletes{
//    static func fetchDataLogoutAPI(completion: @escaping ([Logout]) -> Void) {
//        guard let loginurl = URL(string: "https://server.whatstarted.com/api/accounts/logout") else {
//            print("Invalid URL")
//            return
//        }
//        
//        var logoutrequest = URLRequest(url: loginurl)
//        logoutrequest.httpMethod = "GET" // Set the request method to GET
//        
//        let Logouttask = URLSession.shared.dataTask(with: logoutrequest) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            guard let httpLogoutResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpLogoutResponse.statusCode) else {
//                print("Invalid response")
//                return
//            }
//            
//            guard let logoutdata = data else {
//                print("No Tag data received")
//                return
//            }
//            
//            do {
//                let jsonArray = try JSONSerialization.jsonObject(with: logoutdata, options: []) as? [[String: Any]]
//                
//                var Logoutlist = [Logout]()
//                if let jsonArray = jsonArray {
//                    for item in jsonArray {
//                        let logout = parseLogout(from: item)
//                        Logoutlist.append(logout)
//                    }
//                }
//                
//                completion(Logoutlist)
//            } catch {
//                print("Error parsing JSON: \(error)")
//            }
//        }
//        
//        Logouttask.resume()
//    }
//    //Parse Logout Data
//    static func parseLogout(from json: [String: Any]) -> Logout {
//        let success = json["username"] as? Bool ?? false
//        let message = json["password"] as? String ?? ""
//
//        return Logout(success: success, message: message)
//    }
//
//}

