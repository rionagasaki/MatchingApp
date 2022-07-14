//
//  AllUserSearchViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/13.
//

import UIKit

class AllUserSearchViewController: UIViewController, UISearchResultsUpdating,UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("aaa")
    }

    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        navigationItem.title = "全ユーザー検索"
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}
