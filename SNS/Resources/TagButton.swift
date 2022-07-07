//
//  TagButton.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/20.
//

import UIKit

public final class TagButton:ButtonAnimated{
       
    public var tapped = false
    
    private func setUp() {
        self.layer.cornerRadius = 20
        self.titleLabel?.textAlignment = .center
        
        if !tapped {
            self.backgroundColor = .systemGray6
            self.setTitleColor(UIColor.black, for: .normal)
        }else{
            self.backgroundColor = .black
            self.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    public var title: String {
            get {
                self.titleLabel!.text ?? ""
            }
            set {
                self.setTitle(newValue, for: .normal)
            }
    }
    
    public func tagTapped(){
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        setUp()
    }
        
    override init(frame: CGRect) {
       super.init(frame: frame)
       setUp()
    }
}
