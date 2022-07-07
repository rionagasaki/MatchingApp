//
//  ButtonAnimation.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/22.
//

import UIKit

public class ButtonAnimated: UIButton {

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.touchStartAnimation()
        }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesCancelled(touches, with: event)
            self.touchEndAnimation()
        }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            self.touchEndAnimation()
        }

        private func touchStartAnimation() {
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
                           completion: nil
            )
        }

        private func touchEndAnimation() {
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
                           completion: nil
            )
        }
    static public func nextButton()->Self{
        let button = Self()
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.setTitle("次へ", for: .normal)
        button.setTitleColor(UIColor(named: "white"), for: .normal)
        return button
    }
}
