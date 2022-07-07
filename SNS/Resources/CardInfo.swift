//
//  CardInfo.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/19.
//

import UIKit

class CardInfo:NSObject{
  var ownername:String
  var eventImage:UIImage?
  var place:String?
  var eventTitle:String?
  var deadLine:Bool?
    
    private init(ownwename:String, eventImage:UIImage?, place:String?,eventTitle:String?,deadLine:Bool?){
        self.ownername = ownwename
        self.eventImage = eventImage
        self.place = place
        self.eventTitle = eventTitle
        self.deadLine = deadLine
    }
    

}

