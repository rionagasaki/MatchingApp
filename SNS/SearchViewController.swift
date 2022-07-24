//
//  SearchViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/12.
//

import UIKit
import FirebaseFunctions
import InstantSearchClient
import AlgoliaSearchClient
import SwiftyJSON

class SearchViewController: UIViewController,UISearchBarDelegate {
    
    private var models = [SearchSection]()
    private var searchResults = [SearchResult]()
    private let searchController = UISearchController()
    private let client = SearchClient(appID: "YMO2DITRYL", apiKey: "c4598c2c77037d5739d9ceed1da75800").index(withName: "SNS")
    private let client2 = SearchClient(appID: "YMO2DITRYL", apiKey: "350c6a8f60284db42d1b182ec7bdb76c").index(withName: "SNS")

    private let myPage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "search")
        return imageView
    }()
    
    private let searchListTableView:UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = UIColor.darkGray
        return tableView
    }()
    
    private let resultTableView:UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    
    private let noResultView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        return view
        
    }()
    
    private let noResultImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.resize(image: UIImage(systemName: "magnifyingglass.circle")!.withTintColor(.white), width: 150)
        return imageView
    }()
    
    private let noResultLabel:UILabel = {
       let label = UILabel()
        label.text = "検索結果に一致するデータがありません。キーワード等を変えて、再度お試しください。"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func searchConfigure(username:String, profileImage:String,uid:String){
        searchResults.append(SearchResult(username: username, profileImage: profileImage, objectID:uid))
    }
    
    func configure(){
        models.append(SearchSection(title: "口コミを探す", option:[SearchOption(title: "店名から探す", iconImage: UIImage(systemName: "house")!){
            let modalViewController = AllUserSearchViewController()
            self.navigationController?.pushViewController(modalViewController, animated: true)
        }, SearchOption(title: "タグから探す", iconImage: UIImage(systemName: "tag")!){
            let modalViewController = SearchTagViewController()
            self.navigationController?.pushViewController(modalViewController, animated: true)
        }]))
        
        models.append(SearchSection(title: "ユーザーを探す", option:[SearchOption(title: "全ユーザーから探す", iconImage: UIImage(systemName: "person")!){
            let modalViewController = AllUserSearchViewController()
            self.navigationController?.pushViewController(modalViewController, animated: true)
             },SearchOption(title: "友達から探す", iconImage: UIImage(systemName: "person")!){
                 let modalViewController = AllUserSearchViewController()
                 self.navigationController?.pushViewController(modalViewController, animated: true)
        }]))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchListTableView)
        view.addSubview(noResultView)
        self.noResultView.addSubview(noResultImageView)
        self.noResultView.addSubview(noResultLabel)
        noResultView.isHidden = true
        resultTableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.isHidden = true
        resultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        resultTableView.separatorColor = .white
        
        searchListTableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        searchListTableView.isScrollEnabled = false
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        configure()
        searchListTableView.register(SearchCategoriesTableViewCell.self, forCellReuseIdentifier: SearchCategoriesTableViewCell.identifier)
        navigationItem.titleView = myPage
        navigationItem.searchController = searchController
        searchController.searchBar.setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.white), for: .search, state: .normal)
        searchController.searchBar.tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["店名","タグ","ユーザー"]
        searchController.searchBar.searchTextField.textColor = .white
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchListTableView.frame = CGRect(x:0, y:view.safeAreaInsets.bottom, width: view.frame.width, height: 500)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.noResultView.isHidden = true
        self.resultTableView.removeFromSuperview()
        self.noResultView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.noResultView.addSubview(resultTableView)
        noResultView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        resultTableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        noResultView.frame = CGRect(x: 0, y: searchController.searchBar.bottom+searchController.searchBar.frame.height/2, width: view.width, height: 500)
        noResultImageView.frame = CGRect(x:(view.frame.width/2)-(noResultImageView.intrinsicContentSize.width/2), y: view.height/10, width: noResultImageView.intrinsicContentSize.width, height: noResultImageView.intrinsicContentSize.height)
        noResultLabel.frame = CGRect(x: 20, y: noResultImageView.bottom+20, width: view.frame.width-40, height: 70)
        resultTableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.searchBar.text == "" || searchController.searchBar.text == nil{
            return
        }
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        filterForSearchTextAndScopeButton(searchText: searchText,scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String){
        switch scopeButton {
        case "店名":
            self.searchResults = []
            let results = try! client2.search(query: Query(searchText))
            if results.hits == [] {
                print("no result!")
                self.searchResults = []
                self.noResultView.isHidden = false
                self.noResultLabel.isHidden = false
                self.noResultImageView.isHidden = false
                self.noResultLabel.isHidden = false
                self.resultTableView.isHidden = true
                return
            }
            self.noResultView.isHidden = true
            results.hits.forEach { result in
                self.searchResults = []
                let jsonStr = try! JSONSerialization.data(withJSONObject: result.object.object()!, options: .prettyPrinted)
                let decode = JSONDecoder()
                let jsonData = try! decode.decode(SearchResult.self, from: jsonStr)
                searchConfigure(username: jsonData.username, profileImage: jsonData.profileImage, uid: jsonData.objectID)
                resultTableView.reloadData()
                self.noResultLabel.isHidden = true
                self.noResultImageView.isHidden = true
                self.noResultView.isHidden = false
                self.resultTableView.isHidden = false
            }
        case "タグ":
           print("タグ")
        default:
            self.searchResults = []
            let results = try! client.search(query: Query(searchText))
            if results.hits == [] {
                print("no result!")
                self.searchResults = []
                self.noResultView.isHidden = false
                self.noResultLabel.isHidden = false
                self.noResultImageView.isHidden = false
                self.noResultLabel.isHidden = false
                self.resultTableView.isHidden = true
                return
            }
            self.noResultView.isHidden = true
            results.hits.forEach { result in
                self.searchResults = []
                let jsonStr = try! JSONSerialization.data(withJSONObject: result.object.object()!, options: .prettyPrinted)
                let decode = JSONDecoder()
                let jsonData = try! decode.decode(SearchResult.self, from: jsonStr)
                searchConfigure(username: jsonData.username, profileImage: jsonData.profileImage, uid: jsonData.objectID)
                resultTableView.reloadData()
                self.noResultLabel.isHidden = true
                self.noResultImageView.isHidden = true
                self.noResultView.isHidden = false
                self.resultTableView.isHidden = false
            }
        }
    }
}
extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchListTableView{
            return models[section].option.count
        }else{
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView{
            return 100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchListTableView{
            return models.count
        }else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == searchListTableView{
            let model = models[indexPath.section].option[indexPath.row]
            model.handler!()
        }else {
            print(searchResults[indexPath.row].username)
            let modalViewController = UserProfileViewController()
            navigationController?.pushViewController(modalViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView == searchListTableView {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == searchListTableView{
            let section = models[section]
            return section.title
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchListTableView {
            let model = models[indexPath.section].option[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesTableViewCell.identifier, for: indexPath) as?
            SearchCategoriesTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
            cell.tintColor = .white
            cell.configure(with: model)
            return cell
        }else {
            if searchResults.isEmpty == true { return UITableViewCell() }
            let model = searchResults[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as?
                    SearchResultTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
            cell.tintColor = .white
            cell.config(model: model)
            return cell
        }
    }
}

