//
//  UsersModel.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Users Model
class UsersModel {
    
    /// Request Tags
    enum RequestTags: String {
        case since
    }
    
    /**
     Get users
     - Parameter page: Int
     - Parameter completion: Completion block
     */
    class func getUsers(page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        
        // Check if the network connection is lost
        if !NetworkingManager.shared.isReachable {
            
            DispatchQueue.main.async {
                
                // Get the stored users
                let users = DataManager.shared.fetchUsers()
                completion(.success(users))
            }
            return
        }
        
        // Request data
        NetworkingManager.shared.requestData(for: UsersRouter.getUsers(queryItems: [URLQueryItem(name: RequestTags.since.rawValue, value: page.description)]).getURLRequest()) { data, response, error in
            
            // Check if there is an error
            guard error == nil, data != nil else {
                
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            // Parse data as list of dictionary
            if let jsonObject = SystemUtils.responseJSONSerializer(data: data!) as? [NSDictionary] {
                
                var users = [User]()
                
                // Iterate over each object and create users list with fetched notes
                for object in jsonObject {
                    var user = User(representation: object)
                    user.notes = DataManager.shared.fetchUser(for: user.id)?.notes ?? ""
                    users.append(user)
                }
                
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion(.failure(GithubError(message: NSLocalizedString("errors.unknown", comment: ""))))
                }
            }
        }
    }
    
    /**
     Get user profile
     - Parameter userName: String
     - Parameter completion: Completion block
     */
    class func getUserProfile(for userName: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        // Request data
        NetworkingManager.shared.requestData(for: UsersRouter.getUserProfile(userName: userName).getURLRequest()) { data, response, error in
            
            // Check if there is an error
            guard error == nil, data != nil else {
                
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            // Parse data as dictionary
            if let jsonObject = SystemUtils.responseJSONSerializer(data: data!) as? NSDictionary {
                
                // Create user object
                let user = User(representation: jsonObject)
                
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            }
        }
    }
    
    /**
     Download image
     - Parameter url: URL
     - Parameter completion: Completion block
     */
    class func downloadImage(for url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // Request data
        NetworkingManager.shared.requestData(for: URLRequest(url: url)) { data, response, error in
            
            // Check if there is an error
            guard error == nil, data != nil else {
                
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data!))
            }
        }
    }
}
