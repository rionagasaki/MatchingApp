//
//  File.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/03.
//


import UIKit
import Firebase

open class userData: NSObject {
    
    var id: String
    var username: String?
    var email: String?
    var profileImage: String?
    
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID
        let userDic = document.data()
        self.username = userDic["username"]as? String
        self.email = userDic["email"]as? String
        self.profileImage = userDic["profileImage"]as? String
    }

    init(document: DocumentSnapshot){
        self.id = document.documentID
        let userDic = document.data()!
        self.username = userDic["username"]as? String
        self.email = userDic["email"]as? String
        self.profileImage = userDic["profileImage"]as? String
    }
}
