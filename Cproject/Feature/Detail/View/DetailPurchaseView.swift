//
//  DetailPurchaseView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import SwiftUI

final class DetailPurchaseViewModel: ObservableObject {
    
    @Published var isFavorite: Bool
    
    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

struct DetailPurchaseView: View {
    @ObservedObject var viewModel: DetailPurchaseViewModel
    var onFavoriteTapped: () -> Void
    var onPurchaseTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                onFavoriteTapped()
            } label: {
                viewModel.isFavorite ? Image(.favoriteOn) : Image(.favoriteOff)
            }

            Button {
                onPurchaseTapped()
            } label: {
                Text("구매하기")
                    .font(CPFont.SwiftUI.m16)
                    .foregroundStyle(CPColor.SwiftUI.wh)
            }
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .background(CPColor.SwiftUI.keyColorBlue)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    DetailPurchaseView(viewModel: .init(isFavorite: true),
                       onFavoriteTapped: {},
                       onPurchaseTapped: {})
}
