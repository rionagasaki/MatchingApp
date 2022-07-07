//
//  CameraViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit

class CameraViewController: UIViewController {
    
    private let cardView = CardView()
    
    private let mainView:UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.addSubview(cardView)
        mainView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = CGRect(x: 10, y: (view.frame.height/2)-(550/2), width: view.frame.width - 20, height:550)
        cardView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
    }
}
