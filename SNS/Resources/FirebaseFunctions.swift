import Foundation
import AlgoliaSearchClient

struct searchResult:Codable{
    let searchResult:[UserSearchData]
}

struct UserSearchData: Codable {
    let objectID:ObjectID
    let username: String
    let usericonURL:String
    let follow:Bool
}
