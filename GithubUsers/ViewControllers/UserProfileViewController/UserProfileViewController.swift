//
//  UserProfileViewController.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import SwiftUI

/// User Profile View Controller
struct UserProfileViewController: View {
    
    /// Network model
    @State var networkModel: ProfileNetworkModel
    
    /// Body
    var body: some View {
        
        // Scroll view
        ScrollView {
            
            // Vertical stack
            VStack(spacing: 30) {
                
                // Image
                Image(uiImage: self.networkModel.image ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top, 10)
                
                // User name text
                if !self.networkModel.user.name.isEmpty {
                    
                    Text(String(format: "%@ %@", NSLocalizedString("userProfileViewController.labels.name.title", comment: ""), self.networkModel.user.name)).foregroundColor(.black)
                }
                
                // User company text
                if !self.networkModel.user.company.isEmpty {
                    
                    Text(String(format: "%@ %@", NSLocalizedString("userProfileViewController.labels.company.title", comment: ""), self.networkModel.user.company)).foregroundColor(.black)
                }
                
                // User blog text
                if let blog = URL(string: self.networkModel.user.blog) {
                    Link(destination: blog) {
                        Text(NSLocalizedString("userProfileViewController.labels.blog.title", comment: "")).foregroundColor(.blue)
                    }
                }
                
                // User followers text
                Text(String(format: "%@ %@", NSLocalizedString("userProfileViewController.labels.followers.title", comment: ""), self.networkModel.user.followers.description)).foregroundColor(.black)
                
                // User following text
                Text(String(format: "%@ %@", NSLocalizedString("userProfileViewController.labels.following.title", comment: ""), self.networkModel.user.following.description)).foregroundColor(.black)
                
                // Vertical stack
                VStack(alignment: .leading, spacing: 10) {
                    
                    // User notes text
                    Text(NSLocalizedString("userProfileViewController.labels.notes.title", comment: ""))
                        .foregroundColor(.black)
                    
                    // Notes text editor
                    TextEditor(text: self.$networkModel.user.notes)
                        .background(Color.white)
                        .frame(height: 200, alignment: .topLeading)
                        .border(.black)
                    
                }.background(Color.white)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                // Save button
                Button {
                    
                    // Save to database
                    DataManager.shared.save(user: self.networkModel.user, shouldInformOtherViews: true)
                    
                    // Hide keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Text(NSLocalizedString("userProfileViewController.buttons.save.title", comment: ""))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 30)
                
                
            }.background(Color.white)
                .onTapGesture {
                    
                    // Hide keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }
        }.background(Color.white)
            .navigationBarTitle(self.networkModel.user.accountUserName, displayMode: .inline)
        
            .onAppear() {
                
                // Download image
                self.networkModel.downloadImage()
                
                // Get user profile
                self.networkModel.getUserProfile()
            }
    }
}
