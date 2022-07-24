//
//  SerachData.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/19.
//

import UIKit

public struct SearchSection {
    let title:String
    let option:[SearchOption]
}

public struct SearchOption{
    let title: String
    let iconImage: UIImage
    let handler:(()->Void)?
}

public struct SearchResult:Codable{
    let username: String
    let profileImage: String
    let objectID: String
}
