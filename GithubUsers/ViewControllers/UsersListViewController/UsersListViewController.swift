//
//  UsersListViewController.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Users List View Controller
class UsersListViewController: BaseViewController {

    /// Search bar
    @IBOutlet private weak var searchBar: UISearchBar!
    
    /// Table view
    @IBOutlet private(set) weak var tableView: UITableView!
    
    /// Table view bottom constraint
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    /// View model
    private(set) var viewModel: UsersListViewModel!
    
    /**
     View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = NSLocalizedString("usersListViewController.title", comment: "")
        
        // Init view model
        self.viewModel = UsersListViewModel()
        
        // Setup table view
        self.setupTableView()
        
        // Setup search bar
        self.setupSearchBar()
        
        // Show loading view
        self.showLoadingView(true)
        
        // Get users
        self.getUsers()
    }
    
    /**
     View will appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Register for keyboard notifications
        self.registerForKeyboardNotifications()
    }
    
    /**
     View will disappear
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unregister for keyboard notifications
        self.unregisterForKeyboardNotifications()
    }
    
    /**
     Setup table view
     */
    private func setupTableView() {
        
        // Set table view separator style to none
        self.tableView.separatorStyle = .none
        
        // Set delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register cells
        UserTableViewCell.register(in: self.tableView)
        LoadingTableViewCell.register(in: self.tableView)
        EmptyTableViewCell.register(in: self.tableView)
    }
    
    /**
     Setup search bar
     */
    private func setupSearchBar() {
        
        // Setup search bar
        self.searchBar.barTintColor = .black
        self.searchBar.searchTextField.backgroundColor = .black
        self.searchBar.searchTextField.textColor = .white
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("usersListViewController.searchBar.placeholder", comment: ""), attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        
        if let searchImageView = self.searchBar.searchTextField.leftView as? UIImageView {
            searchImageView.tintColor = UIColor.white.withAlphaComponent(0.7)
        }
        
        // Set delegate
        self.searchBar.delegate = self
    }
    
    /**
     Register notifications
     */
    override func registerNotifications() {
        super.registerNotifications()
        
        // Add observer for user updated
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotifications(_:)), name: NSNotification.Name(DataManager.Notifications.userUpdated.rawValue), object: nil)
    }
    
    /**
     Handle notifications
     - Parameter notification: NSNotification
     */
    @objc override func handleNotifications(_ notification: NSNotification) {
        
        // Row to be reloaded
        var rowToBeReloaded: IndexPath?
        
        // Check if the notification is related to user updated, and get the user object
        if notification.name.rawValue == DataManager.Notifications.userUpdated.rawValue, let user = notification.userInfo?[DataManager.Notifications.userUpdated.key] as? User {
            
            // Set index path to reload
            if let indexPath = self.viewModel.userUpdated(user: user) {
                rowToBeReloaded = indexPath
            }
        }
        else if notification.name.rawValue == NetworkingManager.Notifications.connectionEstablished.rawValue {
            
            // Handle connect to network
            self.viewModel.handleConnectToNetwork()
        }
        else if notification.name.rawValue == NetworkingManager.Notifications.connectionLost.rawValue {
            
            // Handle network connection lost
            self.viewModel.handleNetworkConnectionLost()
            
            // Get users
            self.getUsers()
        }
        
        DispatchQueue.main.async {
            
            if let rowToBeReloaded = rowToBeReloaded {
                
                // Reload table view row
                self.tableView.reloadRows(at: [rowToBeReloaded], with: .automatic)
            }
            else {
                
                // Reload table view data
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Keyboard Notifications
    
    /**
     Register this view controller to receive keyboard notifications
     */
    private func registerForKeyboardNotifications() {
        
        // Add observers to detect when the keyboard opens and closed
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     Unregister this view controller for keyboard notifications
     */
    private func unregisterForKeyboardNotifications(){
        
        // Remove the observers on keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     Keyboard will show
     - Parameter notification: The notification object
     */
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let info = notification.userInfo , let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue , let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // Get keyboard frame
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        // Get Space between safe area and superview
        let spaceBetweenSafeAreaAndSuperView: CGFloat = self.view.safeAreaInsets.bottom
        
        // Update constraints
        self.tableViewBottomConstraint.constant = (keyboardFrame.size.height - spaceBetweenSafeAreaAndSuperView)
        
        // Animate change in height
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    /**
     Keyboard will hide
     - Parameter notification: The notification object
     */
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        guard let info = notification.userInfo , let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // Update constraints
        self.tableViewBottomConstraint.constant = 0
        
        // Animate change in height
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

