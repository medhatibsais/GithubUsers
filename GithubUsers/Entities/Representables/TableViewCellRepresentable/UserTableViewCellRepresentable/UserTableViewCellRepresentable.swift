//
//  UserTableViewCellRepresentable.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// User Table View Cell Representable
class UserTableViewCellRepresentable: TableViewCellRepresentable, Searchable {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String
    
    /// Item index
    var itemIndex: Int
    
    /// Is image inverted
    var isImageInverted: Bool
    
    /// Image URL
    private(set) var imageURL: String
    
    /// User name attributed string
    private(set) var userNameAttributedString: NSAttributedString
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.cellHeight = UserTableViewCell.getHeight()
        self.cellReuseIdentifier = UserTableViewCell.getReuseIdentifier()
        self.itemIndex = -1
        self.isImageInverted = false
        self.imageURL = ""
        self.userNameAttributedString = NSAttributedString()
    }
    
    /**
     Initializer
     - Parameter user: User
     - Parameter isImageInverted: Bool
     */
    convenience init(user: User, isImageInverted: Bool) {
        self.init()
        
        // Set is image inverted
        self.isImageInverted = isImageInverted
        
        // Set image URL
        self.imageURL = user.avatarURL
        
        // Set user name attributed string
        self.userNameAttributedString = NSAttributedString(string: user.accountUserName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    /**
     Search
     - Parameter text: String
     - Returns: Bool, to indicate that the provided search text is exists in the user name string
     */
    func search(text: String) -> Bool {
        return self.userNameAttributedString.string.lowercased().contains(text.lowercased())
    }
}
