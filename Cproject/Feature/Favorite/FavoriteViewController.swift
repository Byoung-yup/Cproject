//
//  FavoriteViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit
import Combine

final class FavoriteViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private enum Section: Int {
        case favorite
    }
    
    private lazy var dataSource: DataSource = setDataSource()
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    
    private var viewModel: FavoriteViewModel = FavoriteViewModel()
    private var cancellables: Set<AnyCancellable> = .init()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.process(action: .getFavoriteFromAPI)
    }
    
    private func bindViewModel() {
        viewModel.state.$tableViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }.store(in: &cancellables)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, viewModel in
            switch self?.currentSection[indexPath.section] {
            case .favorite:
                return self?.favoriteCell(tableView, indexPath, viewModel)
            case .none: return nil
            }
        }
        
        return dataSource
    }
    
    private func favoriteCell(_ tableView: UITableView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UITableViewCell? {
        guard let viewModel = viewModel as? FavoriteItemTableViewCellViewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemTableViewCell.reusableId, for: indexPath) as? FavoriteItemTableViewCell else { return nil }
        cell.setViewModel(viewModel)
        return cell
    }
    
    private func applySnapShot() {
        var snapShot: SnapShot = .init()
        if let favorites = viewModel.state.tableViewModel {
            snapShot.appendSections([.favorite])
            snapShot.appendItems(favorites, toSection: .favorite)
        }
        dataSource.apply(snapShot)
    }
}
