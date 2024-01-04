//
//  PurchaseViewModel.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import Foundation
import Combine

final class PurchaseViewModel: ObservableObject {
    
    enum Action {
        case loadData
        case didTapPurchaseButton
    }
        
    struct State {
        var purchaseItems: [PurchaseSelectedItemViewModel]?
    }
    
    @Published private(set) var state: State = State()
    private(set) var showPaymentViewController: PassthroughSubject<Void, Never> = .init()
    
    func process(action: Action) {
        switch action {
        case .loadData:
            Task { await loadData() }
        case .didTapPurchaseButton:
            Task { await didTapPurchaseButton() }
        }
    }
}

extension PurchaseViewModel {
    
    @MainActor
    private func loadData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.state.purchaseItems = [
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation2", description: "수량 2개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation3", description: "수량 3개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation4", description: "수량 4개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation5", description: "수량 5개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation6", description: "수량 6개 / 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation7", description: "수량 7개 / 무료배송")
            ]
        }
    }
    
    @MainActor
    private func didTapPurchaseButton() async {
        showPaymentViewController.send()
    }
}
