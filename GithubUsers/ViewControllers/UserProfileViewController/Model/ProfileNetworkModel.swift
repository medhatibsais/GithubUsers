//
//  ProfileNetworkModel.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import UIKit

/// Profile Network Model
class ProfileNetworkModel: ObservableObject {
    
    /// User
    @Published var user: User
    
    /// Image
    @Published var image: UIImage?
    
    /**
     Initializer
     - Parameter user: User
     */
    init(user: User) {
        
        // Set user
        self.user = user
        
        // Observe connection established notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotifications(_:)), name: NSNotification.Name(NetworkingManager.Notifications.connectionEstablished.rawValue), object: nil)
    }
    
    /**
     Handle notifications
     - Parameter notification: NSNotification
     */
    @objc private func handleNotifications(_ notification: NSNotification) {
        
        // Get user profile
        if notification.name.rawValue == NetworkingManager.Notifications.connectionEstablished.rawValue {
            self.getUserProfile()
            self.downloadImage()
        }
    }
    
    /**
     Get user profile
     */
    func getUserProfile() {
        
        // Get user profile
        UsersModel.getUserProfile(for: self.user.accountUserName) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                
                // Get needed info before the new object
                let userID = user.id
                let userName = user.accountUserName
                let userNotes = self.user.notes
                
                // Set user
                self.user = user
                
                // Set back the saved data
                self.user.id = userID
                self.user.accountUserName = userName
                self.user.notes = userNotes
                
            case .failure(let error):
                
                // Show alert
                SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: error.localizedDescription)
            }
        }
    }
    
    /**
     Download image
     */
    func downloadImage() {
        
        // Get URL
        guard let url = URL(string: self.user.avatarURL) else { return }
        
        // Download image
        UsersModel.downloadImage(for: url) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let imageData):
                
                // Set image and avatar data
                self.image = UIImage(data: imageData)
                self.user.avatarData = imageData
                
                // Save to data base
                DataManager.shared.save(user: self.user, shouldInformOtherViews: true)
                
            case .failure(let error):
                
                // Show alert
                SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: error.localizedDescription)
            }
        }
    }
}
