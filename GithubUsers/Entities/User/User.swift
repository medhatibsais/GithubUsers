//
//  User.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// User
struct User: Codable, Equatable {
    
    /// ID
    var id: Int
    
    /// Avatar URL
    var avatarURL: String
    
    /// Name
    var name: String
    
    /// Account user name
    var accountUserName: String
    
    /// Company
    var company: String
    
    /// Blog
    var blog: String
    
    /// Followers
    var followers: Int
    
    /// Following
    var following: Int
    
    /// Notes
    var notes: String
    
    /// Avatar data
    var avatarData: Data?
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.id = 0
        self.avatarURL = ""
        self.name = ""
        self.accountUserName = ""
        self.company = ""
        self.blog = ""
        self.notes = ""
        self.followers = 0
        self.following = 0
    }
    
    /**
     Initializer
     - Parameter userInfo: UserInfo
     */
    init(userInfo: UserInfo) {
        
        // Set values from database
        self.avatarURL = userInfo.avatar_url ?? ""
        self.id = Int(userInfo.id)
        self.name = userInfo.name ?? ""
        self.accountUserName = userInfo.login ?? ""
        self.company = userInfo.company ?? ""
        self.blog = userInfo.blog ?? ""
        self.followers = Int(userInfo.followers)
        self.following = Int(userInfo.following)
        self.notes = userInfo.notes ?? ""
        self.avatarData = userInfo.avatarData
    }
    
    /**
     Initializer
     - Parameter representation: NSDictionary
     */
    init(representation: NSDictionary) {
        self.init()
        
        // Set ID
        if let value = representation.value(forKey: CodingKeys.id.rawValue) as? Int {
            self.id = value
        }
        
        // Set avatar URL
        if let value = representation.value(forKey: CodingKeys.avatarURL.rawValue) as? String {
            self.avatarURL = value
        }
        
        // Set name
        if let value = representation.value(forKey: CodingKeys.name.rawValue) as? String {
            self.name = value
        }
        
        // Set account user name
        if let value = representation.value(forKey: CodingKeys.accountUserName.rawValue) as? String {
            self.accountUserName = value
        }
        
        // Set company
        if let value = representation.value(forKey: CodingKeys.company.rawValue) as? String {
            self.company = value
        }
        
        // Set blog
        if let value = representation.value(forKey: CodingKeys.blog.rawValue) as? String {
            self.blog = value
        }
        
        // Set followers
        if let value = representation.value(forKey: CodingKeys.followers.rawValue) as? Int {
            self.followers = value
        }
        
        // Set following
        if let value = representation.value(forKey: CodingKeys.following.rawValue) as? Int {
            self.following = value
        }
    }
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case company
        case blog
        case followers
        case following
        case avatarURL = "avatar_url"
        case accountUserName = "login"
        case notes
        case avatarData
    }
}
