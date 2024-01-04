//
//  HomeThemeHeaderCollectionReusableView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit

struct HomeThemeHeaderCollectionReusableViewViewModel {
    var headerText: String
}

final class HomeThemeHeaderCollectionReusableView: UICollectionReusableView {
        
    static let reusableId: String = "HomeThemeHeaderCollectionReusableView"
    
    @IBOutlet weak var themeHeaderLabel: UILabel!
    
    func setViewModel(_ viewModel: HomeThemeHeaderCollectionReusableViewViewModel) {
        themeHeaderLabel.text = viewModel.headerText
    }
}
