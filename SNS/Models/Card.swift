import UIKit
import Firebase

open class cardData: NSObject {
    
    var id: String
    var eventTitle: String?
    var eventImageURL: String?
    var ownerName: String?
    var date: String?
    var place: String?
    var appeal: String?
    
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID
        let cardDic = document.data()
        self.eventTitle = cardDic["eventTitle"]as? String
        self.eventImageURL = cardDic["eventImage"]as? String
        self.ownerName = cardDic["ownerName"]as? String
        self.date = cardDic["eventDate"]as? String
        self.appeal = cardDic["appeal"]as? String
    }

    init(document: DocumentSnapshot){
        self.id = document.documentID
        let cardDic = document.data()!
        self.eventTitle = cardDic["eventTitle"]as? String
        self.eventImageURL = cardDic["eventImage"]as? String
        self.ownerName = cardDic["ownerName"]as? String
        self.date = cardDic["eventDate"]as? String
        self.appeal = cardDic["appeal"]as? String
    }
}

