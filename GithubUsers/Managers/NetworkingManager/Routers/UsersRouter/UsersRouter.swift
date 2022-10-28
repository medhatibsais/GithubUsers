//
//  UsersRouter.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Users Router
enum UsersRouter {
    
    /// Get users
    case getUsers(queryItems: [URLQueryItem])
    
    /// Get user profile
    case getUserProfile(userName: String)
    
    /// Method
    var method: String {
        switch self {
        case .getUsers, .getUserProfile:
            return "GET"
        }
    }
    
    /// Path
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUserProfile(let userName):
            return String(format: "/users/%@", userName)
        }
    }
    
    /// Base URL string
    var baseURLString: String {
        return "https://api.github.com"
    }
    
    /**
     Get URL request
     - Returns: URLRequest
     */
    func getURLRequest() -> URLRequest {
        
        // Build URL string
        let urlString = self.baseURLString + self.path
        
        // URL component
        var urlComponent = URLComponents(string: urlString)!
        
        switch self {
        case .getUsers(let queryItems):
            
            // Set query items
            urlComponent.queryItems = queryItems
            
        default:
            break
        }
        
        // Create request
        var request = URLRequest(url: urlComponent.url!)
        
        // Set http method
        request.httpMethod = self.method
     
        return request
    }
}
