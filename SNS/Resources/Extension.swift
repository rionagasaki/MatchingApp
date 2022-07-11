//
//  Extension.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/08.
//

import UIKit

extension UIView {
    public var width: CGFloat{
        return frame.size.width
    }
    public var height: CGFloat{
        return frame.size.height
    }
    public var top: CGFloat {
        return frame.origin.y
    }
    public var bottom: CGFloat{
        return frame.origin.y + frame.size.height
    }
    public var left: CGFloat{
        return frame.origin.x
    }
    public var right: CGFloat{
        return frame.origin.x + frame.size.width
    }
}

extension UIImage {
    
    
    public static func resize(image: UIImage, width: Double) -> UIImage {
        let aspectScale = image.size.height / image.size.width
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    public func getImageByUrl(url: String) -> UIImage{
        guard let url = URL(string: url) else { return (UIImage(systemName: "person.fill")?.withTintColor(.darkGray))! }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
}

extension UIView {
    public func anchor(top:NSLayoutYAxisAnchor?=nil
                       ,bottom:NSLayoutYAxisAnchor?=nil,left:NSLayoutXAxisAnchor?=nil,right:NSLayoutXAxisAnchor?=nil,width:CGFloat?,height:CGFloat?,topPadding:CGFloat=0,bottomPadding:CGFloat=0,leftPadding:CGFloat=0,rightPadding:CGFloat=0){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomPadding).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: rightPadding).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}



