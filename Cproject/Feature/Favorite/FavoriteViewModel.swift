//
//  FavoriteViewModel.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import Foundation
import Combine

final class FavoriteViewModel {
    
    enum Action {
        case getFavoriteFromAPI
        case getFavoriteSuccess(FavoritesResponse)
        case getFavoriteFailure(Error)
        case didTapPurchaseButton
    }
    
    final class State {
        @Published var tableViewModel: [FavoriteItemTableViewCellViewModel]?
    }
    
    private(set) var state: State = State()
    private var loadDataTask: Task<Void, Never>?
    
    deinit {
        loadDataTask?.cancel()
    }
    
    func process(action: Action) {
        switch action {
        case .getFavoriteFromAPI:
            getFavoriteFromAPI()
        case .getFavoriteSuccess(let favoriteResponse):
            transformFavoriteItemViewModel(favoriteResponse)
        case .getFavoriteFailure(let error):
            print(error)
        case .didTapPurchaseButton:
            break
        }
    }
}

extension FavoriteViewModel {
    
    private func getFavoriteFromAPI() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getFavoriteData()
                process(action: .getFavoriteSuccess(response))
            } catch {
                process(action: .getFavoriteFailure(error))
            }
        }
    }
    
    private func transformFavoriteItemViewModel(_ response: FavoritesResponse) {
        state.tableViewModel =  response.favorites.map {
            FavoriteItemTableViewCellViewModel(imageUrl: $0.imageUrl,
                                               productName: $0.title,
                                               productPrice: $0.discountPrice.moneyString)
        }
    }
}
