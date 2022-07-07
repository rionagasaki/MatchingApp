//
//  FirebaseDatabase.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import FirebaseFirestore
import FirebaseAuth

public class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid
    
    public func canCreateNewUser(with email:String, username: String, uid:String, completion:@escaping(Bool)->Void){
        
        db.collection("user").document(uid).setData([ "username":username,
                                                    "email": email]){ err in
            if (err != nil){
                print("account create error", err!)
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    public func getDocument(completion:@escaping(userData)->Void){
        db.collection("user").document(uid!).getDocument{ (document, err) in
            if let err = err {
                print("getDocument Fall\(err)")
                return
            }
            let doc = userData(document: document!)
            completion(doc)
        }
    }
    
    public func updateDocument(key:String,text:String){
        db.collection("user").document(uid!).updateData([
            key: text
        ]){ err in
            if let err = err{
                print("updateDocument失敗\(err)")
                return
            }
            print("all Success")
        }
    }
    
    public func addMessage(message:String){
        db.collection("chat").addDocument(data: [
            "sender": uid!,
            "message": message
        ])
    }
}
