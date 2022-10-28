//
//  TestCoreDataStack.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 28/10/2022.
//

import Foundation
import CoreData
@testable import GithubUsers

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        let container = NSPersistentContainer(name: "GithubUsersModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func createNewUserEntity(for user: User, with context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: DataManager.Entities.userInfo.rawValue, in: context)!
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        
        newUser.setValue(user.id, forKey: User.CodingKeys.id.rawValue)
        newUser.setValue(user.name, forKey: User.CodingKeys.name.rawValue)
        newUser.setValue(user.accountUserName, forKey: User.CodingKeys.accountUserName.rawValue)
        newUser.setValue(user.company, forKey: User.CodingKeys.company.rawValue)
        newUser.setValue(user.blog, forKey: User.CodingKeys.blog.rawValue)
        newUser.setValue(user.followers, forKey: User.CodingKeys.followers.rawValue)
        newUser.setValue(user.following, forKey: User.CodingKeys.following.rawValue)
        newUser.setValue(user.notes, forKey: User.CodingKeys.notes.rawValue)
        newUser.setValue(user.avatarURL, forKey: User.CodingKeys.avatarURL.rawValue)
        
        if let data = user.avatarData {
            newUser.setValue(data, forKey: User.CodingKeys.avatarData.rawValue)
        }
    }
    
    func getFetchedRequestObject(for entity: String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        
        return request
    }
    
    func fetchUser(with id: Int, for context: NSManagedObjectContext) -> User? {
        
        let context = self.persistentContainer.viewContext
        
        var users = [User]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        if let result = try? context.fetch(request) as? [UserInfo] {
            users = result.map({ User(userInfo: $0) })
        }
        
        return users.first(where: { $0.id == id })
    }
    
    func updateUser(_ user: User, for context: NSManagedObjectContext) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.Entities.userInfo.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject] {
                
                if user.id == data.value(forKey: User.CodingKeys.id.rawValue) as! Int16 {
                    
                    data.setValue(user.name, forKey: User.CodingKeys.name.rawValue)
                    data.setValue(user.accountUserName, forKey: User.CodingKeys.accountUserName.rawValue)
                    data.setValue(user.company, forKey: User.CodingKeys.company.rawValue)
                    data.setValue(user.blog, forKey: User.CodingKeys.blog.rawValue)
                    data.setValue(user.followers, forKey: User.CodingKeys.followers.rawValue)
                    data.setValue(user.following, forKey: User.CodingKeys.following.rawValue)
                    data.setValue(user.notes, forKey: User.CodingKeys.notes.rawValue)
                    data.setValue(user.avatarURL, forKey: User.CodingKeys.avatarURL.rawValue)
                    
                    if let imageData = user.avatarData {
                        data.setValue(imageData, forKey: User.CodingKeys.avatarData.rawValue)
                    }
                    
                    try context.save()
                    break
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
}
