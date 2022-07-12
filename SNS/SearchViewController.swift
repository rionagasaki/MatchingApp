//
//  SearchViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/12.
//

import UIKit
import InstantSearchClient
import AlgoliaSearchClient

class SearchViewController: UIViewController, UISearchResultsUpdating,UISearchBarDelegate {

    private let searchController = UISearchController()
    
    private let myPage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "search")
        return imageView
    }()
    
    let client = SearchClient(appID: "YMO2DITRYL", apiKey: "7d8cdfd1cdc3c1ab61c6499dc5107548")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = client.index(withName: "Amelia")
       
        
        navigationItem.titleView = myPage
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.scopeButtonTitles = ["店名","タグ","ユーザー"]
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
    }
    
   

}
