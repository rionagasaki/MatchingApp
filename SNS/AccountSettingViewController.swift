//
//  AccountSettingViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/02.
//

import UIKit

struct Section {
    let title:String
    let option: [SettingOption]
}

struct SettingOption{
    let title: String
    let iconImage: UIImage?
    let iconBackground: UIColor
    let handler:(()->Void)?
}

class AccountSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var models = [Section]()
    
    @objc func back(){
        self.dismiss(animated: true)
    }
    
    func configure(){
        models.append(Section(title: "アカウント情報", option: [
            SettingOption(title: "ユーザー名", iconImage: UIImage(systemName: "person"), iconBackground:UIColor.systemGray4){
                let modalViewController = NameChangeViewController()
                modalViewController.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                    transition.duration = 0.25
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.present(modalViewController, animated: false, completion: nil)
            },
            SettingOption(title: "メールアドレス", iconImage: UIImage(systemName: "envelope"), iconBackground:UIColor.systemGray4){
                let modalViewController = EmailChangeViewController()
                modalViewController.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                    transition.duration = 0.25
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.present(modalViewController, animated: false, completion: nil)
            },
            SettingOption(title: "居住地", iconImage: UIImage(systemName: "house"), iconBackground:UIColor.systemGray4){
                let modalViewController = AddressChangeViewController()
                modalViewController.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                    transition.duration = 0.25
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.present(modalViewController, animated: false, completion: nil)
            },
            SettingOption(title: "パスワード", iconImage: UIImage(systemName: "key"), iconBackground:UIColor.systemGray4 ){
                
            }
        ]))
        models.append( Section(title: "ブロック", option: [
            SettingOption(title: "ブロックしたユーザー", iconImage: UIImage(systemName: "person.crop.circle.badge.xmark"), iconBackground: UIColor.systemGray4){
            }
        ]))
        models.append(Section(title: "アカウント情報", option: [
            SettingOption(title: "ログアウトする", iconImage: UIImage(systemName: "arrowshape.turn.up.backward"), iconBackground: UIColor.systemGray4){
                AuthManager.shared.logoutUser{ result in
                    if result == true{
                        let modalViewController = LoginViewController()
                        modalViewController.modalPresentationStyle = .fullScreen
                        self.present(modalViewController, animated: true, completion: nil)
                    }else{
                        print("logOut Error")
                    }
                }
            },
            SettingOption(title: "アカウントを削除する", iconImage: UIImage(systemName: "minus.circle"), iconBackground:UIColor.systemRed){
            }
        ]))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].option.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].option[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCell.identifier, for: indexPath) as?
        AccountSettingCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.rgb(r: 51, g: 51, b: 51)
        cell.tintColor = .white
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].option[indexPath.row]
        model.handler!()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        
        return section.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           let header = view as! UITableViewHeaderFooterView
           header.textLabel?.textColor = .systemGray6
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Setting"
        view.backgroundColor = .systemGray5
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountSettingCell.self, forCellReuseIdentifier:AccountSettingCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        tableView.frame = CGRect(x: 0, y: backButton.bottom+10, width: view.width, height: view.height-60)
    }
    
    private let backButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor.darkGray
        return table
    }()
}

