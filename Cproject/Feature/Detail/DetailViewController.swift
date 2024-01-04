//
//  DetailViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit
import SwiftUI
import Combine

final class DetailViewController: UIViewController {
    
    let viewModel: DetailViewModel = DetailViewModel()
    lazy var rootView: UIHostingController = UIHostingController(rootView: DetailRootView(viewModel: viewModel))
    
    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        addRootView()
        bindViewModelAction()
    }
    
    private func addRootView() {
        addChild(rootView)
        view.addSubview(rootView.view)
        
        rootView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            rootView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModelAction() {
        viewModel.showOptionViewController.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let viewController = OptionViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }.store(in: &cancellables)
        
        viewModel.showPurchaseViewController.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let viewController = PurchaseViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }.store(in: &cancellables)
    }
}
