//
//  Searchable.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import Foundation

/// Searchable
protocol Searchable {
    
    /**
     Search
     - Parameter text: String
     - Returns: Bool, to indicate that the provided search text is exists in the user name string
     */
    func search(text: String) -> Bool
}
