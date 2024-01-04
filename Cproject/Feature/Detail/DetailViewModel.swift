//
//  DetailViewModel.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    enum Action {
        case loadData
        case loading(Bool)
        case getDataSuccess(ProductDetailResponse)
        case getDataFailure(Error)
        case didTapChangeOption
        case didTapMore
        case didTapFavorite
        case didTapPurchase
    }
    
    struct State {
        var isError: String?
        var isLoading: Bool = false
        var banners: DetailBannerViewModel?
        var rate: DetailRateViewModel?
        var title: String?
        var option: DetailOptionViewModel?
        var price: DetailPriceViewModel?
        var mainImageUrls: [String]?
        var more: DetailMoreViewModel?
        var purchase: DetailPurchaseViewModel?
    }
    
    @Published private(set) var state: State = .init()
    private(set) var showOptionViewController: PassthroughSubject<Void, Never> = .init()
    private(set) var showPurchaseViewController: PassthroughSubject<Void, Never> = .init()
    
    
    private var loadDataTask: Task<Void, Never>?
    private var isFavorite: Bool = false
    private var needShowMore: Bool = true
    
    deinit {
        loadDataTask?.cancel()
    }
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .loading(isLoading):
            Task { await toggleLoading(isLoading) }
        case let .getDataSuccess(response):
            Task { await transformProductDetailResponse(response) }
        case let .getDataFailure(error):
            Task { await getDataFailure(error) }
        case .didTapChangeOption:
            showOptionViewController.send()
        case .didTapMore:
            Task { await toggleMore() }
        case .didTapFavorite:
            Task { await toggleFavorite() }
        case .didTapPurchase:
            showPurchaseViewController.send()
        }
    }
}

extension DetailViewModel {
    
    private func loadData() {
        loadDataTask = Task {
            defer {
                process(action: .loading(false))
            }
            do {
                process(action: .loading(true))
                let response = try await NetworkService.shared.getProductDetailData()
                process(action: .getDataSuccess(response))
            } catch {
                process(action: .getDataFailure(error))
            }
        }
    }
    
    @MainActor
    private func toggleLoading(_ isLoading: Bool) async {
        state.isLoading = isLoading
    }
    
    @MainActor
    private func toggleFavorite() async {
        isFavorite.toggle()
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func toggleMore() async {
        needShowMore = false
        state.more = needShowMore ? DetailMoreViewModel() : nil
    }
    
    @MainActor
    private func transformProductDetailResponse(_ response: ProductDetailResponse) async {
        state.isError = nil
        state.banners = DetailBannerViewModel(imageUrls: response.bannerImages)
        state.rate = DetailRateViewModel(rate: response.product.rate)
        state.title = response.product.name
        state.option = DetailOptionViewModel(type: response.option.type,
                                             name: response.option.name,
                                             imageUrl: response.option.image)
        state.price = DetailPriceViewModel(discountRate: "\(response.product.discountPercent)%",
                                           originPrice: response.product.originalPrice.moneyString,
                                           currentPrice: response.product.discountPrice.moneyString,
                                           shippingType: "무료배송")
        state.mainImageUrls = response.detailImages
        state.more = needShowMore ? DetailMoreViewModel() : nil
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func getDataFailure(_ error: Error) async {
        state.isError = "에러가 발생하였습니다. \(error.localizedDescription)"
    }
}