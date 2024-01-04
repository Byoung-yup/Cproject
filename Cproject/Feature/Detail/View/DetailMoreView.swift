//
//  DetailMoreView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import SwiftUI

final class DetailMoreViewModel: ObservableObject {
    
}

struct DetailMoreView: View {
    @ObservedObject var viewModel: DetailMoreViewModel
    var onMoreTapped: () -> Void
    
    var body: some View {
        Button {
            onMoreTapped()
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text("상품정보 더보기")
                    .font(CPFont.SwiftUI.b17)
                    .foregroundStyle(CPColor.SwiftUI.keyColorBlue)
                
                Image(.down)
                    .foregroundStyle(CPColor.SwiftUI.icon)
            }
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            .border(CPColor.SwiftUI.keyColorBlue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    DetailMoreView(viewModel: .init(), onMoreTapped: {})
}
