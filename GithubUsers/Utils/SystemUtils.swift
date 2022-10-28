//
//  SystemUtils.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

enum RequestStatus {
    case success
    case failed
    case loading
}

/// SystemUtils
class SystemUtils {
    
    /**
     Response JSON serializer
     - Parameter data: Data
     - Returns: Dictionary of string and Any type
     */
    class func responseJSONSerializer(data: Data) -> Any {
        
        // Serialize JSON object
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) else {
            return [:]
        }
        
        // Return the object
        return jsonObject
    }
    
    /**
     Invert image
     - Parameter image: UIImage
     - Returns: Optional UIImage
     */
    class func invertImage(_ image: UIImage) -> UIImage? {
        
        // CI Image
        let beginImage = CIImage(image: image)
        
        // Get filter
        if let filter = CIFilter(name: "CIColorInvert") {
            
            // Set the image
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            
            // Get the output image
            if let outputImage = filter.outputImage {
             return UIImage(ciImage: outputImage)
            }
        }
        
        return nil
    }
    
    /**
     Show message alert
     - Parameter title: String
     - Parameter message: String
     */
    class func showMessageAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
         
            // Alert acontroller
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Add action
            alert.addAction(UIAlertAction(title: NSLocalizedString("alerts.actions.ok.title", comment: ""), style: .default))
            
            // Get the active window scene
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
              return
            }
            
            // Get root view controller
            let viewController = sceneDelegate.window?.rootViewController
            
            // Present on the root view controller
            viewController?.present(alert, animated: true)
        }
    }
}
