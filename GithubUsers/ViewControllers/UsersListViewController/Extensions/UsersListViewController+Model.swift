//
//  UsersListViewController+Model.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import Foundation

// MARK: - Model
extension UsersListViewController {
    
    /**
     Get users
     */
    func getUsers() {
        
        // Get users
        UsersModel.getUsers(page: self.viewModel.getLastUserID()) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                
                // Set users
                self.viewModel.setUsers(users)
                
                // Reload table view data
                self.tableView.reloadData()
                
            case .failure(let error):
                
                // Show alert
                SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: error.localizedDescription)
            }
            
            // Hide loading view
            self.showLoadingView(false)
        }
    }
    
}
