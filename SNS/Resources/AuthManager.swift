//
//  AuthManager.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//
import FirebaseAuth

public class AuthManager{
    
    static let shared = AuthManager()
    static let uid = Auth.auth().currentUser?.uid
    
    public func registerNewUser(username: String, email: String, password: String, completion:@escaping (Bool) -> (Void)){
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            guard error == nil, result != nil else{
                completion(false)
                return
            }
            let uid = result?.user.uid
            DatabaseManager.shared.canCreateNewUser(with: email, username: username, uid: uid!){ result in
                if result == true {
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
    }
    
    public func logoutUser(completion:(Bool)->(Void)){
        do{
            try Auth.auth().signOut()
            completion(true)
        }
        catch{
            completion(false)
        }
    }
    
    public func loginUser(username: String?, email: String?, passowrd: String, completion:@escaping (Bool)->Void){
        if let email = email {
        Auth.auth().signIn(withEmail: email, password: passowrd) { authResult, error in
           
            guard authResult != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        }else if let username = username{
            Auth.auth().signIn(withEmail: username, password: passowrd) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
        }
}

}
}
