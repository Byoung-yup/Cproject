//
//  HomeCategoryCollectionViewCell.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/04.
//

import UIKit
import Kingfisher

struct HomeCategoryCollectionViewCellViewModel: Hashable {
    let imageName: String
    let title: String
}

final class HomeCategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseableId: String = "HomeCategoryCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func setViewModel(_ viewModel: HomeCategoryCollectionViewCellViewModel) {
        imageView.image = UIImage(named: viewModel.imageName)
        categoryLabel.text = viewModel.title
    }
}

extension HomeCategoryCollectionViewCell {
    static func categoryItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 4), heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 13, leading: 25, bottom: 13, trailing: 25)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(93))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 40, leading: 30, bottom: 0, trailing: 30)
        section.interGroupSpacing = 5
        return section
    }
}
