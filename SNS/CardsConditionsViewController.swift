//
//  CardsConditionsViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/17.
//

import UIKit

class CardsConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
    }
    
    
    
    private let conditionTableView:UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        return tableView
    }()
    
}
