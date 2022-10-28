//
//  UsersListViewController+CellDelegates.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import UIKit

// MARK: - User Table View Cell Delegate
extension UsersListViewController: UserTableViewCellDelegate {
    
    // Did load image data
    func userTableViewCell(didLoadImageData data: Data?, at indexPath: IndexPath) {
        
        // Get user
        if var user = self.viewModel.getUser(at: indexPath) {
            
            // Update avatar data
            user.avatarData = data
            
            // Update user
            self.viewModel.updateUser(at: indexPath, user: user)
        }
    }
}
