//
//  HomeReccomendTableViewCell.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/07/20.
//

import UIKit

class HomeReccomendTableViewCell: UITableViewCell {

    static let identifier = "ReccomendTableView"
    
    var recommends = [Reccomend]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        recommendCollectionView.register(HomeReccomendTableViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        addSubview(recommendCollectionView)
        recommendCollectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private let recommendCollectionView:UICollectionView = {
       let collectionView = UICollectionView()
        collectionView.backgroundColor = .systemOrange
        return collectionView
    }()
    
    public static func configure(){
        
    }
}
extension HomeReccomendTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = recommends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
        cell.configure(with: model)
        return cell
    }
}
