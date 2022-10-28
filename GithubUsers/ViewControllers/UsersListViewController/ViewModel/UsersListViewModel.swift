//
//  UsersListViewModel.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Users List View Model
class UsersListViewModel {
    
    /// Users
    var users: [User]
    
    /// Users map
    var usersMap: [Int: Int]
    
    /// Representables
    var representables: [TableViewCellRepresentable]
    
    /// Filtered representables
    var filteredRepresentables: [TableViewCellRepresentable]
    
    /// Search text
    var searchText: String
    
    /// Inverted images indexes
    var invertedImagesIndexes: Set<Int>
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.users = []
        self.usersMap = [:]
        self.representables = []
        self.invertedImagesIndexes = []
        self.filteredRepresentables = []
        self.searchText = ""
    }
    
    /**
     Build representable
     */
    private func buildRepresentable() {
        
        // Clear all representables
        self.representables.removeAll()
        
        // Iterate over each user
        for (index, user) in self.users.enumerated() {
            
            // Set user in map
            self.usersMap[user.id] = index
            
            // Setup representable
            let representable = UserTableViewCellRepresentable(user: user, isImageInverted: self.invertedImagesIndexes.contains(index))
            representable.itemIndex = index
            self.representables.append(representable)
        }
        
        // Add empty cell if the list is empty
        if self.representables.isEmpty {
            self.representables = [EmptyTableViewCellRepresentable(title: NSLocalizedString("usersListViewController.noUsersYet", comment: ""))]
        }
        
        // Add loading cell if we have a connection
        if NetworkingManager.shared.isReachable, !self.representables.isEmpty {
            self.representables.append(LoadingTableViewCellRepresentable())
        }
        
        // Filter content
        if !self.searchText.isEmpty {
            self.filterContent(self.searchText)
        }
    }
    
    /**
     Set users
     - Parameter users: List of users
     */
    func setUsers(_ users: [User]) {
        
        // Add the user index to invert his image
        if users.count > 3 {
            self.invertedImagesIndexes.insert(self.users.count + 3)
        }
        
        // Append users
        self.users += users
        
        // Save users
        for user in users where NetworkingManager.shared.isReachable {
            DataManager.shared.save(user: user)
        }
        
        // Build representable
        self.buildRepresentable()
    }
    
    /**
     Filter content
     - Parameter text: String
     */
    func filterContent(_ text: String) {
        
        // Set search text
        self.searchText = text
        
        // Set the filtered list based on the search text
        self.filteredRepresentables = self.representables.filter({ ($0 as? UserTableViewCellRepresentable)?.search(text: text) ?? false })
        
        // Add empty cell if the list is empty
        if self.filteredRepresentables.isEmpty {
            self.filteredRepresentables = [EmptyTableViewCellRepresentable(title: String(format: NSLocalizedString("usersListViewController.search.noResults", comment: ""), self.searchText))]
        }
    }
    
    /**
     Reset
     */
    func reset() {
        
        // Clear all data
        self.users.removeAll()
        self.invertedImagesIndexes.removeAll()
        self.representables.removeAll()
    }
    
    /**
     Get user
     - Parameter indexPath: IndexPath
     - Returns: Optional user
     */
    func getUser(at indexPath: IndexPath) -> User? {
        
        // Get representable
        if let representable = self.representableForRow(at: indexPath) as? UserTableViewCellRepresentable, representable.itemIndex < self.users.count {
            return self.users[representable.itemIndex]
        }
        
        return nil
    }
    
    /**
     Update user
     - Parameter indexPath: IndexPath
     - Parameter user: User
     */
    func updateUser(at indexPath: IndexPath, user: User) {
        
        // Get representable
        if let representable = self.representableForRow(at: indexPath) as? UserTableViewCellRepresentable, representable.itemIndex < self.users.count {
            
            // Update user
            self.users[representable.itemIndex] = user
            
            // Save
            DataManager.shared.save(user: user)
        }
    }
    
    /**
     User updated
     - Parameter user: User
     */
    func userUpdated(user: User) -> IndexPath? {
        
        // Set the updated user data
        if let index = self.usersMap[user.id] {
            self.users[index] = user
            return IndexPath(row: index, section: 0)
        }
        
        return nil
    }
    
    /**
     Get last user ID
     - Returns: Int
     */
    func getLastUserID() -> Int {
        return self.users.last?.id ?? 0
    }
    
    /**
     Number of rows
     */
    func numberOfRows(in section: Int) -> Int {
        return self.searchText.isEmpty ? self.representables.count : self.filteredRepresentables.count
    }
    
    /**
     Representable for row
     */
    func representableForRow(at indexPath: IndexPath) -> TableViewCellRepresentable? {
        
        // Check if the number of rows is valid
        if self.numberOfRows(in: indexPath.section) > indexPath.row {
            
            // Check if we have search text
            if self.searchText.isEmpty {
                return self.representables[indexPath.row]
            }
            else {
                return self.filteredRepresentables[indexPath.row]
            }
        }
        
        return nil
    }
    
    /**
     Height for representable
     */
    func heightForRepresentable(at indexPath: IndexPath, in tableView: UITableView) -> CGFloat {
        
        // Representable
        let representable = self.representableForRow(at: indexPath)
        
        // Check if the representable is empty table view cell representable
        if representable is EmptyTableViewCellRepresentable {
            return tableView.frame.size.height
        }
        
        return representable?.cellHeight ?? 0.0
    }
    
    /**
     Did select representable
     */
    func didSelectRepresentable(at indexPath: IndexPath) -> User? {
        return self.getUser(at: indexPath)
    }
    
    /**
     Handle connect to network
     */
    func handleConnectToNetwork() {
        if !(self.representables.last is LoadingTableViewCellRepresentable) {
            self.representables.append(LoadingTableViewCellRepresentable())
        }
    }
    
    /**
     Handle network connection lost
     */
    func handleNetworkConnectionLost() {
        self.reset()
    }
}
