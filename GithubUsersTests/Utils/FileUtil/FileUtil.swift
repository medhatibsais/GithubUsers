//
//  FileUtil.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 26/10/2022.
//

import Foundation

class FileUtil {
    
    class func data(for filename: String) -> Data? {
        
        guard let url = Bundle(for: self).url(forResource: filename, withExtension: nil) else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
