//
//  SearchTagViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/19.
//

import UIKit
import InstantSearchClient
import AlgoliaSearchClient

class SearchTagViewController: UIViewController,UISearchBarDelegate {
    
    private let searchController = UISearchController()
    private var searchResults = [SearchResult]()
    private let client = SearchClient(appID: "YMO2DITRYL", apiKey: "c4598c2c77037d5739d9ceed1da75800").index(withName: "SNS")
    
    private let resultTableView:UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultTableView)
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        navigationItem.title = "タグ検索"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .white
        tableViewConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.frame = CGRect(x: 0, y: view.safeAreaInsets.bottom, width: view.frame.width, height:searchController.searchBar.intrinsicContentSize.height)
        resultTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.bottom+view.height/10, width: view.frame.width, height: view.frame.height)
    }
    
    func tableViewConfigure(){
       
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        resultTableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    
    }
    
    func searchConfigure(username:String, profileImage:String,uid:String){
        searchResults.append(SearchResult(username: username, profileImage: profileImage, objectID:uid))
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.searchBar.text == "" || searchController.searchBar.text == nil{
            return
        }
        let text = searchController.searchBar.text
        self.searchResults = []
        let results = try! client.search(query: Query(text))
        if results.hits == [] {
            print("no result!")
            return
        }
        results.hits.forEach { result in
            self.searchResults = []
            let jsonStr = try! JSONSerialization.data(withJSONObject: result.object.object()!, options: .prettyPrinted)
            let decode = JSONDecoder()
            let jsonData = try! decode.decode(SearchResult.self, from: jsonStr)
            searchConfigure(username: jsonData.username, profileImage: jsonData.profileImage, uid: jsonData.objectID)
            resultTableView.reloadData()
        }
    }
}

extension SearchTagViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = searchResults[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else{
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        cell.tintColor = .white
        cell.config(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
