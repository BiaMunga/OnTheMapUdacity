//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 13/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var objectId = ""
        static var uniqueKey = ""
        static var sessionId = ""
    }
    
    struct UserDetails {
        static var firstName = ""
        static var lastName = ""
        static var udacity = ""
    }
    
    enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1/"
    
    case getStudentLocation
    case putStudentLocation
    case postASession
    case getPublicData
        
    var stringValue: String {
    switch self {
    case .getStudentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
    case .putStudentLocation: return Endpoints.base + "StudentLocation/" + "\(Auth.objectId)"
    case .postASession: return Endpoints.base + "session"
    case .getPublicData: return Endpoints.base + "users/" + "\(Auth.uniqueKey)"
                }
    }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = Range(uncheckedBounds: (5, data.count))
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                print(error)
                completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocationDetails], Error?) -> Void) {
         let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocation.url) { data, response, error in
             guard let data = data else {
                 DispatchQueue.main.async {
                 completion([], error)
                 }
                 return
             }
             let decoder = JSONDecoder()
             do {
                 print(String(data: data, encoding: .utf8)!)
                 let students = try decoder.decode(StudentLocation.self, from: data)
                 DispatchQueue.main.async {
                    completion(students.results, nil)
                 }
             } catch {
                 DispatchQueue.main.async {
                 print(error)
                 completion([], error)
                 }
             }
         }
         task.resume()
     }
    
//    class func getStudentLocation(completion: @escaping ([StudentLocationDetails], Error?) -> Void) {
//
//         taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentLocation.self) { (students, error) in
//               if let student = students {
//                completion(student.results, nil)
//               } else {
//                   completion([], error)
//               }
//           }
//       }
    
    class func getPublicData(completion: @escaping (PublicDataRequest?, Error?) -> Void) {
     
        taskForGETRequest(url: Endpoints.getPublicData.url, responseType: PublicDataRequest.self) { (response, error) in
            if let response = response {
                UserDetails.firstName = response.firstName
                UserDetails.lastName = response.lastName
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try! JSONEncoder().encode(body)
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                completion(nil, error)
                }
                return
            }
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            do {
                print(String(data: data, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                completion(response, nil)
                }
            } catch {
                DispatchQueue.main.async {
                completion(nil, error)
                print(error)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = StudentLocationPostRequest(firstName: UserDetails.firstName, lastName: UserDetails.lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
        
        request.httpBody = try! JSONEncoder().encode(body)
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                completion(false, error)
                }
                return
            }
            do {
                print(String(data: data, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let response = try decoder.decode(StudentLocationPost.self, from: data)
                DispatchQueue.main.async {
                completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                completion(false, error)
                print(error)
                }
            }
        }
        task.resume()
    }
    
//    class func postStudentLocation(latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
//
//        let body = StudentLocationPostRequest(firstName: UserDetails.firstName, lastName: UserDetails.lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
//
//        taskForPOSTRequest(url: Endpoints.getStudentLocation.url, responseType: StudentLocationPost.self, body: body) { (response, error) in
//            if let response = response {
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
    
    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
           
        let usernameAndPassword = UdacityDetails(username: username, password: password)
        let body = Udacity(udacity: usernameAndPassword)
        
        taskForPOSTRequest(url: Endpoints.postASession.url, responseType: LoginSessionPost.self, body: body) { (response, error) in
            if let response = response {
                Auth.uniqueKey = response.account.key
                Auth.sessionId = response.session.id
                DispatchQueue.main.async {
                completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                completion(false, error)
                }
            }
        }
    }
    
   class func putStudentLocation(latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.putStudentLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = StudentLocationPostRequest(firstName: UserDetails.firstName, lastName: UserDetails.lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.uniqueKey)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                    completion(false, error)
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(StudentLocationPut.self, from: data)
                    DispatchQueue.main.async {
                    completion(true, nil)
                    }
            } catch {
                    DispatchQueue.main.async {
                    completion(false, error)
                    }
                }
        }
        task.resume()
    }
    
//    class func logout(completion: @escaping () -> Void) {
//        var request = URLRequest(url: Endpoints.postASession.url)
//        request.httpMethod = "DELETE"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = LogoutRequest(sessionId: Auth.sessionId)
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                Auth.sessionId = ""
//                completion()
//        }
//        task.resume()
//    }
        
    
}
