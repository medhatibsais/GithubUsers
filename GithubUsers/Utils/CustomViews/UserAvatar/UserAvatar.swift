//
//  UserAvatar.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 25/10/2022.
//

import UIKit

/// User Avatar
class UserAvatar: UIImageView {
    
    /// Image cache
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    /**
     Setup
     - Parameter url: URL
     - Parameter isImageInverted: Bool
     - Parameter completion: Completion block
     */
    func setup(with url: URL, isImageInverted: Bool, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Get cached image, or download it if its not cached
        if let cachedImage = self.imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            // Invert the image if its must be inverted
            if isImageInverted, let invertedImage = SystemUtils.invertImage(cachedImage) {
                self.image = invertedImage
            }
            else {
                self.image = cachedImage
            }
            
            completion(.success(nil))
            return
        }
        
        /**
         Download image
         */
        UsersModel.downloadImage(for: url) { result in
            
            switch result {
            case .success(let data):
                
                // Invert the image if its must be inverted
                if isImageInverted, let image = UIImage(data: data), let invertedImage = SystemUtils.invertImage(image) {
                    self.image = invertedImage
                }
                else {
                    self.image = UIImage(data: data)
                }
                
                // Save image to cache
                self.saveImageToCache(for: url)
                
                // Call completion
                completion(.success(data))
                
            case .failure(let error):
                
                // Call completion
                completion(.failure(error))
            }
        }
    }
    
    /**
     Save image to cache
     - Parameter key: URL
     */
    private func saveImageToCache(for key: URL) {
        
        // Get image
        if let image = self.image {
            self.imageCache.setObject(image, forKey: key as AnyObject)
        }
    }
}
