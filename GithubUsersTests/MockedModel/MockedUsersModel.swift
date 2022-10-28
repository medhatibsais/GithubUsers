//
//  MockedUsersModel.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 26/10/2022.
//

import Foundation
@testable import GithubUsers

class MockedUsersModel {
    
    enum RequestTags: String {
        case since
    }
    
    class func getUsers(url: URL, using session: URLSession = URLSession.shared, completion: @escaping (Result<[User], Error>) -> Void) {
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // Get data
            if let data = data {
                
                // Currencies
                var users: [User] = []
                
                // Serialize object
                if let jsonObject = SystemUtils.responseJSONSerializer(data: data) as? [NSDictionary] {
                    
                    users = jsonObject.map({ User(representation: $0) })
                        
                    // Call completion
                    completion(.success(users))
                    return
                }
            }
            
            completion(.failure(GithubError(message: "")))
        }
        
        task.resume()
    }
    
    class func getUserProfile(url: URL, using session: URLSession = URLSession.shared, completion: @escaping (Result<User, Error>) -> Void) {
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // Get data
            if let data = data {
                
                // Serialize object
                if let jsonObject = SystemUtils.responseJSONSerializer(data: data) as? NSDictionary {
                        
                    // Call completion
                    completion(.success(User(representation: jsonObject)))
                    return
                }
            }
            
            completion(.failure(GithubError(message: "")))
        }
        
        task.resume()
    }
}
