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

struct SearchSection {
    let title:String
    let option:[SearchOption]
}

struct SearchOption{
    let title: String
    let iconImage: UIImage
    let handler:(()->Void)?
}

class SearchViewController: UIViewController, UISearchResultsUpdating,UISearchBarDelegate {
    
    private var models = [SearchSection]()

    private let searchController = UISearchController()
    let client = SearchClient(appID: "YMO2DITRYL", apiKey: "7d8cdfd1cdc3c1ab61c6499dc5107548").index(withName: "Amelia")
    
    private let myPage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "search")
        return imageView
    }()
    
    private let searchListTableView:UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .purple
        tableView.backgroundColor = UIColor.darkGray
        return tableView
    }()
    
    func configure(){
        models.append(SearchSection(title: "口コミを探す", option:[SearchOption(title: "店名から探す", iconImage: UIImage(systemName: "house")!){
            let modalViewController = AllUserSearchViewController()
            self.navigationController?.pushViewController(modalViewController, animated: true)
        }, SearchOption(title: "タグから探す", iconImage: UIImage(systemName: "tag")!){
            let modalViewController = AllUserSearchViewController()
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
        searchListTableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        searchListTableView.isScrollEnabled = false
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        configure()
        searchListTableView.register(SearchCategoriesTableViewCell.self, forCellReuseIdentifier: SearchCategoriesTableViewCell.identifier)
        navigationItem.titleView = myPage
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.scopeButtonTitles = ["店名","タグ","ユーザー"]
        searchListTableView.tableHeaderView = searchController.searchBar
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchListTableView.frame = CGRect(x:0, y:view.safeAreaInsets.bottom, width: view.frame.width, height: 500)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let results = try! client.search(query: Query(text))
        if results.hits == [] {
            print("no result!")
            return
        }
        print(results.hits[0].object["company"]! as Any)
    }
}
extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].option.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].option[indexPath.row]
        model.handler!()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].option[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesTableViewCell.identifier, for: indexPath) as?
        SearchCategoriesTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        cell.tintColor = .white
        cell.configure(with: model)
        return cell
    }
}
