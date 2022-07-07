//
//  IntroduceViewController.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/05/13.
//

import UIKit

class IntroduceViewController: UIPageViewController {
    
    var controllers: [UIViewController] = []
    var pageControl: UIPageControl!
    
    init(transitionStyle style:
                  UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("IntroduceViewController")
        super.viewDidLoad()
        view.backgroundColor = .white
        let firstViewController = FirstViewController()
        let secondViewController = SecondViewController()
        let thirdViewController = ThirdViewController()
        controllers = [firstViewController,secondViewController,thirdViewController]
        setViewControllers([controllers[0]], direction: .forward, animated: false)
        // Do any additional setup after loading the view.
        dataSource = self
        pageControl = UIPageControl(frame: CGRect(x:0, y: view.frame.height - 100, width: view.frame.width, height:50))
        pageControl.numberOfPages = controllers.count
        pageControl.allowsContinuousInteraction = false
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemPurple
        view.addSubview(pageControl)
    }
}

extension IntroduceViewController: UIPageViewControllerDataSource{
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
           return controllers.count
       }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = controllers.firstIndex(of: viewController)!
        print(index)
                pageControl.currentPage = index
                index = index - 1

                if index < 0 {
                    return nil
                }
                
                return controllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = controllers.firstIndex(of: viewController)!
        print(index)
        pageControl.currentPage = index

        if index == controllers.count - 1 {
                    return nil
                }
        index = index + 1
                return controllers[index]
        
    }
    
}


class FirstViewController: UIViewController {
    
    
    private var firstLabel: UILabel = {
        let label = UILabel()
        label.text = "Customize your map yourself"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        return label
    }()
    
    private let firstImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "first"))
        image.clipsToBounds = true
        return image
    }()
    
    private let beginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius =  LoginViewController.Constants.cornerRadius
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        return button
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("firstViewController")
        view.backgroundColor = .white
        view.addSubview(firstImage)
        view.addSubview(firstLabel)
        view.addSubview(beginButton)
    }
    
    override func viewDidLayoutSubviews() {
        firstImage.frame = CGRect(x:0 , y: view.safeAreaInsets.top+90, width: view.frame.size.width, height: view.frame.size.height/2.5)
        firstLabel.frame = CGRect(x:0 , y: firstImage.bottom + 20, width: view.frame.size.width, height: 70)
        beginButton.frame = CGRect(x: 20, y: firstLabel.bottom + 10, width: view.width-40, height: 52)
        
    }
}

class SecondViewController: UIViewController {
    
    private let secondImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "second"))
        image.clipsToBounds = true
        
        return image
    }()
    
    private var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your map to friend"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        return label
    }()
    
    private let beginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius =  LoginViewController.Constants.cornerRadius
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(secondImage)
        view.addSubview(secondLabel)
        view.addSubview(beginButton)
    }
    
    override func viewDidLayoutSubviews() {
        secondImage.frame = CGRect(x: 0, y: view.safeAreaInsets.top+90, width: view.frame.size.width, height: view.frame.size.height/2.5)
        secondLabel.frame = CGRect(x: 0, y: secondImage.bottom+20, width: view.width, height: 70)
        beginButton.frame = CGRect(x: 20, y: secondLabel.bottom+10, width: view.width-40, height: 52)
        
    }
    
    
}

class ThirdViewController: UIViewController {
    
    private let thirdImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "third"))
        image.clipsToBounds = true
        return image
    }()
    
    private var thirdLabel: UILabel = {
        let label = UILabel()
        label.text = "Then, let's begin Amelia!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        return label
    }()
  
    
    private let beginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius =  LoginViewController.Constants.cornerRadius
        button.setTitle("Get Started", for: .normal)
        button.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(thirdImage)
        view.addSubview(thirdLabel)
        view.addSubview(beginButton)
        beginButton.addTarget(self, action: #selector(didTapBeginButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        thirdImage.frame = CGRect(x: 0, y: view.safeAreaInsets.top+90, width: view.frame.size.width, height: view.frame.size.height/2.5)
        thirdLabel.frame = CGRect(x: 0, y: thirdImage.bottom+20, width: view.width, height: 70)
        beginButton.frame = CGRect(x:20 , y:thirdLabel.bottom+10, width: view.width-40, height: 52)
        
    }
    
    @objc private func didTapBeginButton(){
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    
    
}

