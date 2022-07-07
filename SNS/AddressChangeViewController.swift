//
//  AddressChangeViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/07.
//

import UIKit

class AddressChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.frame.width/20, y: view.safeAreaInsets.top+20, width: backButton.intrinsicContentSize.width, height: backButton.intrinsicContentSize.height)
    }
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("設定一覧", for: .normal)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.configuration?.imagePadding = CGFloat(20)
        button.tintColor = .white
        return button
    }()
    
        @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    
    private let addressTextField:UITextField = {
       let textField = UITextField()
        return textField
    }()
}
