//
//  ViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.getDocument{ doc in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let auth = Auth.auth()
        auth.addStateDidChangeListener{(auth, user) in
        if (user != nil) {
            
            print("userです",user!)
        }else{
            print("no user")
            let modalViewController = LoginViewController()
            modalViewController.modalPresentationStyle = .fullScreen
            self.present(modalViewController, animated: true, completion: nil)
        }
        }
    }
    private func handleNotAuthenticated(){
        if Auth.auth().currentUser == nil {
            let vc = IntroduceViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: false)
        }
    }
}

