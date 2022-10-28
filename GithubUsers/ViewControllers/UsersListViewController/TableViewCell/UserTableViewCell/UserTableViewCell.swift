//
//  UserTableViewCell.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// User Table View Cell
class UserTableViewCell: UITableViewCell {

    /// Container view
    @IBOutlet private weak var containerView: UIView!
    
    /// User profile image
    @IBOutlet private weak var userProfileImage: UserAvatar!
    
    /// User name label
    @IBOutlet private weak var userNameLabel: UILabel!
    
    /// Index path
    private var indexPath: IndexPath!
    
    /// Delegate
    weak var delegate: UserTableViewCellDelegate?
    
    /**
     Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set selection style to none
        self.selectionStyle = .none
    }
    
    /**
     Prepare for reuse
     */
    override func prepareForReuse() {
        super.prepareForReuse()

        // Rest profile image and name label
        self.userProfileImage.image = nil
        self.userNameLabel.attributedText = nil
    }
    
    /**
     Draw
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Round container view
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.clipsToBounds = true
        
        // Round user profile image
        self.userProfileImage.layer.cornerRadius = 20
        self.userProfileImage.clipsToBounds = true
    }
    
    /**
     Setup
     - Parameter representable: User Table View Cell Representable
     - Parameter indexPath: IndexPath
     */
    func setup(with representable: UserTableViewCellRepresentable, indexPath: IndexPath) {
        
        // Set index path
        self.indexPath = indexPath
        
        // Set profile image tag
        self.userProfileImage.tag = indexPath.row
        
        // Get URL
        if let url = URL(string: representable.imageURL) {
            
            // Setup profile image
            self.userProfileImage.setup(with: url, indexPath: indexPath, isImageInverted: representable.isImageInverted) { result in
                
                switch result {
                case .success(let data):
                    if let data = data {
                        
                        // Call delegate
                        self.delegate?.userTableViewCell(didLoadImageData: data, at: self.indexPath)
                    }
                    
                case .failure:
                    break
                }
            }
        }
        
        // Set user name label attributed text
        self.userNameLabel.attributedText = representable.userNameAttributedString
    }
    
    // MARK: - Class methods
    
    /**
     Get reuse identifier
     - Returns: String
     */
    class func getReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    /**
     Register
     - Parameter tableView: UITableView
     */
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: Bundle.main), forCellReuseIdentifier: Self.getReuseIdentifier())
    }
    
    /**
     Get height
     - Returns: CGFloat
     */
    class func getHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}

/// User Table View Cell Delegate
protocol UserTableViewCellDelegate: NSObjectProtocol {
    
    /**
     Did load image data
     - Parameter data: Optional Data
     - Parameter indexPath: Index Path
     */
    func userTableViewCell(didLoadImageData data: Data?, at indexPath: IndexPath)
}
