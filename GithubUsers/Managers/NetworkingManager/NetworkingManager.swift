//
//  NetworkingManager.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit
import Network

/// Networking Manager
class NetworkingManager {
    
    /// Notifications
    enum Notifications: String {
        case connectionLost
        case connectionEstablished
    }
    
    /// Shared
    static let shared: NetworkingManager = NetworkingManager()
    
    /// Is reachable
    private(set) var isReachable: Bool = false
    
    /// Monitor
    private let monitor = NWPathMonitor()
    
    /// Operation queue
    private let operationQueue: OperationQueue = OperationQueue()
    
    /**
     Initializer
     */
    private init() {
        
        // Set max operations 1 at a time
        self.operationQueue.maxConcurrentOperationCount = 1
    }
    
    /**
     Configure
     */
    func configure() {
        
        // Listen to network status
        self.monitor.pathUpdateHandler = { path in
            
            // Set is reachable flag
            self.isReachable = path.status == .satisfied
            
            switch path.status {
            case .satisfied:
                
                // Post a notification
                NotificationCenter.default.post(Notification(name: Notification.Name(Self.Notifications.connectionEstablished.rawValue)))
            default:
                
                // Show alert
                SystemUtils.showMessageAlert(title: NSLocalizedString("networkingStatus.offline.title", comment: ""), message: NSLocalizedString("networkingStatus.offline.message", comment: ""))
                
                // Post a notification
                NotificationCenter.default.post(Notification(name: Notification.Name(Self.Notifications.connectionLost.rawValue)))
            }
        }
        
        // Queue for monitoring
        let queue = DispatchQueue(label: "Monitor")
        
        // Start monitoring
        self.monitor.start(queue: queue)
    }
    
    /**
     Request data
     - Parameter urlRequest: URLRequest
     - Parameter completion: Completion block
     */
    func requestData(for urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        // Request URL
        self.operationQueue.addBarrierBlock {
            URLSession.shared.dataTask(with: urlRequest, completionHandler: completion).resume()
        }
    }
}
