//
//  backButton.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/20.
//

import UIKit

extension UIButton {
    
   static public func backButton()->UIButton{
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        return button
    }
}
