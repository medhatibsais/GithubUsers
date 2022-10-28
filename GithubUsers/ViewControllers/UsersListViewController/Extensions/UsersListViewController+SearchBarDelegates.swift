//
//  UsersListViewController+SearchBarDelegates.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import UIKit

// MARK: - Search Bar Delegate
extension UsersListViewController: UISearchBarDelegate {
    
    /**
     Text did change
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        // Filter content
        self.viewModel.filterContent(searchText)
        
        // Reload table view data
        self.tableView.reloadData()
    }
    
    /**
     Search button clicked
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Force end editing the view, in order to dismiss the keyboard
        self.view.endEditing(true)
    }
}
