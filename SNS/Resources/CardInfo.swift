//
//  CardInfo.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/19.
//

import UIKit

class CardInfo:NSObject{
  var ownername:String
  var ownerUid:String
  var eventImage:UIImage
  var place:String
  var eventTitle:String
  var eventDate:[String]
  var tagName:[String]
  var appeal:String
  var deadLine:Bool
  
    public init(ownwename:String,ownerUid:String, eventImage:UIImage, place:String,eventTitle:String,deadLine:Bool,eventDate:[String], tagName:[String], appeal:String){
        self.ownername = ownwename
        self.ownerUid = ownerUid
        self.eventImage = eventImage
        self.place = place
        self.eventTitle = eventTitle
        self.eventDate = eventDate
        self.tagName = tagName
        self.appeal = appeal
        self.deadLine = deadLine
    }
}

