//
//  DataParser.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 26/10/2022.
//

import Foundation
@testable import GithubUsers

class DataParser {
    
    class func parseUsers(data: Data) -> [User] {
        
        // Users
        var users: [User] = []
        
        // json object
        let jsonObject = SystemUtils.responseJSONSerializer(data: data)
        
        // Serialize object
        if let jsonObjects = jsonObject as? [NSDictionary] {
            users = jsonObjects.map({ User(representation: $0) })
        }
        
        return users
    }
    
    class func parseUserProfile(data: Data) -> User? {
        
        // Serialize object
        if let jsonObject = SystemUtils.responseJSONSerializer(data: data) as? NSDictionary {
            return User(representation: jsonObject)
        }
        
        return nil
    }
}
