//
//  DataManager.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import UIKit
import CoreData

/// Data Manager
class DataManager {
    
    /// Notifications
    enum Notifications: String {
        case userUpdated
        
        var key: String {
            switch self {
            case .userUpdated:
                return "user"
            }
        }
    }
    
    /// Entities
    enum Entities: String {
        case userInfo = "UserInfo"
    }
    
    /// Shared
    static let shared = DataManager()
    
    /// Saving persistent container
    lazy var savingPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubUsersModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: NSLocalizedString("errors.dataManager.failedToInitiate", comment: ""))
            }
        })
        return container
    }()
    
    /// Reading persistent container
    lazy var readingPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubUsersModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: NSLocalizedString("errors.dataManager.failedToInitiate", comment: ""))
            }
        })
        return container
    }()
    
    /**
     Save
     - Parameter user: User
     - Parameter shouldInformOtherViews: Bool, flag for informing other views that a data have been saved, using notifications
     */
    func save(user: User, shouldInformOtherViews: Bool = false) {
        
        // Check if the user is already exists
        if self.isAlreadyExist(userID: user.id) {
            
            // Update user
            self.updateUser(user: user)
        }
        else {
            
            // Context
            let context = self.savingPersistentContainer.viewContext
            
            // Create entity, and user
            let entity = NSEntityDescription.entity(forEntityName: Entities.userInfo.rawValue, in: context)!
            let newUserManagedObject = NSManagedObject(entity: entity, insertInto: context)
            
            // Set user data
            self.setUserData(user, userManagedObject: newUserManagedObject)
            
            // Save changes
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    SystemUtils.showMessageAlert(title: NSLocalizedString("errors.alert.title", comment: ""), message: NSLocalizedString("errors.dataManager.failedToInitiate", comment: ""))
                }
            }
        }
        
        // Post a notification to inform other views
        if shouldInformOtherViews {
            
            NotificationCenter.default.post(name: NSNotification.Name(Self.Notifications.userUpdated.rawValue), object: nil, userInfo: [Self.Notifications.userUpdated.key: user])
        }
    }
    
    /**
     Fetch users
     - Returns: List of users
     */
    func fetchUsers() -> [User] {
        
        // Users
        var users = [User]()
        
        // Fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            
            // Set users
            if let result = try self.readingPersistentContainer.viewContext.fetch(request) as? [UserInfo] {
                users = result.map({ User(userInfo: $0) })
            }
            
        } catch {
            
            print("Failed")
        }
        
        return users
    }
    
    /**
     Fetch user
     - Parameter id: Int
     - Returns: Optional user
     */
    func fetchUser(for id: Int) -> User? {
        
        // Fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            
            // Result
            let result = try self.readingPersistentContainer.viewContext.fetch(request)
            
            // Search for user
            for userInfo in result as! [UserInfo] {
                if userInfo.id == id {
                    return User(userInfo: userInfo)
                }
            }
            
        } catch {
            
            print("Failed")
        }
        
        return nil
    }
    
    /**
     Update user
     - Parameter user: User
     */
    private func updateUser(user: User) {
        
        // Fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            
            // Results
            let results = try self.savingPersistentContainer.viewContext.fetch(request)
            
            // Search for user and update its data
            for managedObject in results as! [NSManagedObject] {
                
                if user.id == managedObject.value(forKey: User.CodingKeys.id.rawValue) as! Int16 {
                    
                    // Set user data
                    self.setUserData(user, userManagedObject: managedObject)
                    
                    // Save
                    try self.savingPersistentContainer.viewContext.save()
                    
                    break
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    /**
     Is already exist
     - Parameter userID: Int
     - Returns: Bool
     */
    private func isAlreadyExist(userID: Int) -> Bool {
        
        // Fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            
            // Results
            let result = try self.readingPersistentContainer.viewContext.fetch(request)
            
            // Search for user by his id
            for userInfo in result as! [UserInfo] where userInfo.id == userID {
                return true
            }
        }
        
        catch {
            
            print("fetch failed")
        }
        
        return false
    }
    
    /**
     Set user data
     - Parameter user: User
     - Parameter userManagedObject: NSManagedObject
     */
    private func setUserData(_ user: User, userManagedObject: NSManagedObject) {
        
        // Save user values
        userManagedObject.setValue(user.id, forKey: User.CodingKeys.id.rawValue)
        userManagedObject.setValue(user.name, forKey: User.CodingKeys.name.rawValue)
        userManagedObject.setValue(user.accountUserName, forKey: User.CodingKeys.accountUserName.rawValue)
        userManagedObject.setValue(user.company, forKey: User.CodingKeys.company.rawValue)
        userManagedObject.setValue(user.blog, forKey: User.CodingKeys.blog.rawValue)
        userManagedObject.setValue(user.followers, forKey: User.CodingKeys.followers.rawValue)
        userManagedObject.setValue(user.following, forKey: User.CodingKeys.following.rawValue)
        userManagedObject.setValue(user.notes, forKey: User.CodingKeys.notes.rawValue)
        userManagedObject.setValue(user.avatarURL, forKey: User.CodingKeys.avatarURL.rawValue)
        
        if let data = user.avatarData {
            userManagedObject.setValue(data, forKey: User.CodingKeys.avatarData.rawValue)
        }
    }
}
