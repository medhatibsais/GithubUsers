//
//  ProfileContentView.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 22/10/2022.
//

import SwiftUI

/// Profile Content View
struct ProfileContentView: View {
    
    /// User
    var user: User
    
    /// Body
    var body: some View {
        
        // Crate user profile view controller with profile network model environment object
        UserProfileViewController().environmentObject(ProfileNetworkModel(user: self.user))
    }
}
