//
//  TableViewCellRepresentable.swift
//  GithubUsers
//
//  Created by Medhat Ibsais on 21/10/2022.
//

import UIKit

/// Table View Cell Representable
protocol TableViewCellRepresentable {
    
    /// Cell height
    var cellHeight: CGFloat { get set }
    
    /// Cell reuse identifier
    var cellReuseIdentifier: String { get set }
    
    /// Item index
    var itemIndex: Int { get set }
}
