//
//  CameraViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import KRProgressHUD

class CameraViewController: UIViewController {
    
    var listener: ListenerRegistration?
    private var cards = [cardData]()
    
    private let mainView:UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        mainView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        view.addSubview(mainView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillApeear")
        cards = []
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        let cardRef = Firestore.firestore().collection("Cards")
        self.listener = cardRef.addSnapshotListener(){ (querySnapshot, error) in
            if let error = error {
                print("addEventLisner失敗\(error)")
                return
            }
            self.cards = []
            if querySnapshot?.isEmpty == true { return }
            for document in querySnapshot!.documents {
                let cardDate = cardData(document: document)
                self.cards.append(cardDate)
                print("count",self.cards.count)
                for card in self.cards{
                    let cardView = CardView(model: card)
                    self.mainView.addSubview(cardView)
                    cardView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: self.mainView.frame.height)
                }
            }
            print("end")
            KRProgressHUD.dismiss()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.listener?.remove()
        cards = []
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = CGRect(x: 10, y: (view.frame.height/2)-(550/2), width: view.frame.width - 20, height:550)
    }
}
