//
//  TagSelectViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/06/20.
//

import UIKit

class TagSelectViewController: UIViewController {
    
    public var cardInfo:CardInfo?
    
    private let liveTag = TagButton()
    private let dateTag = TagButton()
    private let saunaTag = TagButton()
    private let speechTag = TagButton()
    private let cafeTag = TagButton()
    private let sportTag = TagButton()
    private let gymTag = TagButton()
    private let shoppingTag = TagButton()
    private let bathTag = TagButton()
    private let movieTag = TagButton()
    private let otherTag = TagButton()
    private var tagArray:[TagButton] = []
    private var tagBool:[Bool] = []
    public var tagTitle:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        view.addSubview(nextButton)
        tagArray = [liveTag,dateTag,saunaTag,speechTag,cafeTag,sportTag,gymTag,shoppingTag,bathTag,movieTag,otherTag]
        tagBool = tagArray.map{ element in
            element.tapped
        }
        liveTag.title = "日本料理"
        dateTag.title = "寿司"
        saunaTag.title = "魚介料理・海鮮料理"
        speechTag.title = "天ぷら・揚げ物"
        cafeTag.title = "そば・うどん・麺類"
        sportTag.title = "うなぎ・どじょう・あなご"
        gymTag.title = "焼き鳥・串焼き・鳥料理"
        shoppingTag.title = "すき焼き・しゃぶしゃぶ"
        bathTag.title = "おでん"
        movieTag.title = "お好み焼き・たこ焼き"
        otherTag.title = "丼もの"
        
        tagArray.forEach{element in
               view.addSubview(element)
               element.addTarget(self, action: #selector(tagTapped(_:_:)), for: .touchUpInside)
        }
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(tagBool)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.safeAreaInsets.left+20, y: view.safeAreaInsets.bottom+20, width: 30, height: 30)
        mainLabel.frame = CGRect(x:(view.frame.width/2)-(mainLabel.intrinsicContentSize.width/2), y: 100, width: mainLabel.intrinsicContentSize.width, height: mainLabel.intrinsicContentSize.height)
        liveTag.frame = CGRect(x: view.safeAreaInsets.left+30, y: mainLabel.bottom+40, width: liveTag.intrinsicContentSize.width+20, height: liveTag.intrinsicContentSize.height+5)
        
        stackSetUp(liveTag, dateTag)
        stackSetUp(dateTag, saunaTag)
        stackSetUp(saunaTag, speechTag)
        stackSetUp(speechTag, cafeTag)
        stackSetUp(cafeTag, sportTag)
        stackSetUp(sportTag, gymTag)
        stackSetUp(gymTag, shoppingTag)
        stackSetUp(shoppingTag, bathTag)
        stackSetUp(bathTag, movieTag)
        stackSetUp(movieTag, otherTag)
        
        nextButton.frame = CGRect(x: (view.frame.width/2)-150, y: otherTag.bottom+40, width: 300, height: 55)
    }
    private let mainLabel:UILabel = {
        let label = UILabel()
        label.text = "タグを追加してください(1つ以上)"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    private let nextButton:ButtonAnimated = {
        let button = ButtonAnimated.nextButton()
        button.isEnabled = false
        button.backgroundColor = .systemGray3
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let backButton:UIButton = {
        UIButton.backButton()
    }()
    
    @objc func back(){
        let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
    @objc func tagTapped(_ sender:TagButton, _ event: UIEvent){
        print(sender.title)
        sender.tapped = !sender.tapped
        sender.tagTapped()
        self.tagBool = []
        tagBool = tagArray.map{ element in
            element.tapped
        }
        if sender.tapped {
            tagTitle.append(sender.title)
        }
        if self.tagBool.contains(true) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(UIColor.white, for: .normal)
        }else{
            nextButton.backgroundColor = .systemGray3
            nextButton.setTitleColor(UIColor.black, for: .normal)
            nextButton.isEnabled = false
        }
    }
    @objc func nextScreen(){
        let modalViewController = AppealViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        cardInfo?.tagName = tagTitle
        modalViewController.cardInfo = cardInfo
        let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
        self.present(modalViewController, animated: false, completion: nil)
    }
    private func stackSetUp(_ preTag:TagButton, _ Tag:TagButton){
        if preTag.frame.maxX + Tag.intrinsicContentSize.width + 10 < view.frame.width - 30 {
            Tag.frame = CGRect(x: preTag.right+5, y: preTag.frame.minY, width: Tag.intrinsicContentSize.width+20, height: Tag.intrinsicContentSize.height+5)
        }
        else{
            Tag.frame = CGRect(x: view.safeAreaInsets.left+30, y: preTag.bottom+10, width: Tag.intrinsicContentSize.width+20, height: Tag.intrinsicContentSize.height+5)
        }
    }
}
