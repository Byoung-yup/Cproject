//
//  PurchaseViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit
import Combine

final class PurchaseViewController: UIViewController {
    
    private var rootView: PurchaseRootView = PurchaseRootView()
    
    private var viewModel: PurchaseViewModel = PurchaseViewModel()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.process(action: .loadData)
    }
    
    private func bindViewModel() {
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let viewModels = self?.viewModel.state.purchaseItems else { return }
                self?.rootView.setPurchaseItem(viewModels)
            }.store(in: &cancellables)
        
        viewModel.showPaymentViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let paymentVC: PaymentViewController = PaymentViewController()
                self?.navigationController?.pushViewController(paymentVC, animated: true)
            }.store(in: &cancellables)
    }
}

#Preview {
    PurchaseViewController()
}
