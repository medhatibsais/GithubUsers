//
//  UsersListViewController+TableViewDelegateDataSource.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit
import SwiftUI

// MARK: - UITableViewDataSource
extension UsersListViewController: UITableViewDataSource {
    
    /**
     Number of rows in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    /**
     Cell for row
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get loading table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? LoadingTableViewCellRepresentable {
        
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! LoadingTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        // Get loading table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? EmptyTableViewCellRepresentable {
        
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! EmptyTableViewCell
            
            // Setup cell
            cell.setup(with: representable)
            
            return cell
        }
        
        // Get user table view cell representable
        if let representable = self.viewModel.representableForRow(at: indexPath) as? UserTableViewCellRepresentable {
            
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: representable.cellReuseIdentifier, for: indexPath) as! UserTableViewCell
            
            // Set delegate
            cell.delegate = self
            
            // Setup cell
            cell.setup(with: representable, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    /**
     Will display cell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Check if the cell is loading table view cell representable, then get users
        if self.viewModel.representableForRow(at: indexPath) is LoadingTableViewCellRepresentable {
            self.getUsers()
        }
    }
}

// MARK: - UITableViewDelegate
extension UsersListViewController: UITableViewDelegate {
 
    /**
     Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.heightForRepresentable(at: indexPath, in: tableView)
    }
    
    /**
     Estimated height for row
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    /**
     Did select row
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get user
        if let user = self.viewModel.didSelectRepresentable(at: indexPath) {
            
            // Show user profile view
            let profileView = ProfileContentView(user: user)
            let hostingViewController = UIHostingController(rootView: profileView)
            hostingViewController.view.backgroundColor = .white
            self.navigationController?.pushViewController(hostingViewController, animated: true)
        }
    }
}
