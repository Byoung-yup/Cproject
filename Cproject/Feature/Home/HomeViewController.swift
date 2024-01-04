//
//  HomeViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/02.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private enum Section: Int {
        case banner
        case horizontalProductItem
        case separateLine1
        case category
        case couponButton
        case verticalProductItem
        case separateLine2
        case theme
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var dataSource: DataSource = setDataSource()
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = setCompositionalLayout()
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    
    private var didTapCouponDownload: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    private var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
        collectionView.collectionViewLayout = compositionalLayout
        collectionView.delegate = self
        
        viewModel.process(action: .loadData)
        viewModel.process(action: .loadCoupon)
    }
    
    private func setCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch self?.currentSection[section] {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .category:
                return HomeCategoryCollectionViewCell.categoryItemLayout()
            case .couponButton:
                return HomeCouponButtonCollectionViewCell.couponButtonItemLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductItemLayout()
            case .separateLine1, .separateLine2:
                return HomeSeparateLineCollectionViewCell.separateLineLayout()
            case .theme:
                return HomeThemeCollectionViewCell.themeLayout()
            case .none:
                return nil
            }
        }
    }
    
    private func bindingViewModel() {
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }.store(in: &cancellables)
        
        didTapCouponDownload.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.process(action: .didTapCouponButton)
            }.store(in: &cancellables)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource =  UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, viewModel in
            switch self?.currentSection[indexPath.section] {
            case .banner:
                return self?.bannerCell(collectionView, indexPath, viewModel)
            case .horizontalProductItem, .verticalProductItem:
                return self?.productCell(collectionView, indexPath, viewModel)
            case .category:
                return self?.categoryCell(collectionView, indexPath, viewModel)
            case .couponButton:
                return self?.couponButtonCell(collectionView, indexPath, viewModel)
            case .separateLine1, .separateLine2:
                return self?.separateLineCell(collectionView, indexPath, viewModel)
            case .theme:
                return self?.themeCell(collectionView, indexPath, viewModel)
            case .none:
                return .init()
            }
        })
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let viewModel = self?.viewModel.state.collectionViewModels.themeViewModels?.headerViewModel else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeThemeHeaderCollectionReusableView.reusableId, for: indexPath) as? HomeThemeHeaderCollectionReusableView
            headerView?.setViewModel(viewModel)
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapShot() {
        var snapShot: SnapShot = SnapShot()
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels, toSection: .banner)
        }
        
        if let horizontalProductViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels {
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
            
            snapShot.appendSections([.separateLine1])
            snapShot.appendItems(viewModel.state.collectionViewModels.separateLineViewModels, toSection: .separateLine1)
        }
        
        if let categoryViewModels = viewModel.state.collectionViewModels.categoryViewModels {
            snapShot.appendSections([.category])
            snapShot.appendItems(categoryViewModels, toSection: .category)
        }
        
        if let couponViewModels = viewModel.state.collectionViewModels.couponState {
            snapShot.appendSections([.couponButton])
            snapShot.appendItems(couponViewModels, toSection: .couponButton)
        }
        
        if let verticalProductViewModels = viewModel.state.collectionViewModels.verticalProductViewModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        }
        
        if let themeViewModels = viewModel.state.collectionViewModels.themeViewModels {
            snapShot.appendSections([.separateLine2])
            snapShot.appendItems(viewModel.state.collectionViewModels.separateLineViewModels2, toSection: .separateLine2)
            
            snapShot.appendSections([.theme])
            snapShot.appendItems(themeViewModels.items, toSection: .theme)
        }
        dataSource.apply(snapShot)
    }
    
    private func bannerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.reuseableId, for: indexPath) as? HomeBannerCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func productCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeProductCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCollectionViewCell.reuseableId, for: indexPath) as? HomeProductCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func categoryCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeCategoryCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.reuseableId, for: indexPath) as? HomeCategoryCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func couponButtonCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeCouponButtonCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeCouponButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCouponButtonCollectionViewCell.reuseableId, for: indexPath) as? HomeCouponButtonCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel, didTapCouponDownload)
        return cell
    }
    
    private func separateLineCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeSeparateLineCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeSeparateLineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSeparateLineCollectionViewCell.reuseableId, for: indexPath) as? HomeSeparateLineCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func themeCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UICollectionViewCell {
        guard let viewModel = viewModel as? HomeThemeCollectionViewCellViewModel else { return .init() }
        guard let cell: HomeThemeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeThemeCollectionViewCell.reuseableId, for: indexPath) as? HomeThemeCollectionViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        let favoriteStoryboard = UIStoryboard(name: "Favorite", bundle: nil)
        if let favoriteVC = favoriteStoryboard.instantiateInitialViewController() {
            navigationController?.pushViewController(favoriteVC, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSection[indexPath.section] {
        case .banner:
            break
        case .separateLine1, .separateLine2:
            break
        case .category:
            break
        case .couponButton:
            break
        case .horizontalProductItem, .verticalProductItem:
            let storyboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            guard let viewController: UIViewController = storyboard.instantiateInitialViewController() else { return }
            navigationController?.pushViewController(viewController, animated: true)
        case .theme:
            break
        }
    }
}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
}
