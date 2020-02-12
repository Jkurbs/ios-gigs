//
//  GigController.swift
//  Gigs
//
//  Created by Kerby Jean on 2/12/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

// HttpMethods enums
enum HTTPMETHODS: String {
    case POST
    case GET
}


class AuthController {
    

    var baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")
    var bearer: Bearer?

    
    // Sign up user

    func signUp(_ user: User, _ completion: @escaping(Error?) -> ()) {
        /// Configure Url
        let url = baseUrl?.appendingPathComponent("/users/signup")
        /// Create request
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMETHODS.POST.rawValue
        
        ///Configure header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        ///Encode user to json
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding data: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error  {
                NSLog("Error with URL Session: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                    NSLog("Other error with  ")
                    completion(error)
                    return
                }
            }
            completion(nil)
        }.resume()
    }
    
    // Sign in user
    func signIn(_ user: User, _ completion: @escaping(Error?) -> ()) {
        /// Configure Url
        let url = baseUrl?.appendingPathComponent("/users/login")
        /// Create request
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMETHODS.POST.rawValue
        
        ///Configure header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        ///Encode user to json
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding data: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
            if let error = error  {
                NSLog("Error with URL Session: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding data: \(error)")
            }
            completion(nil)
        }.resume()
        
    }
}
