//
//  DetailOptionView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import SwiftUI
import Kingfisher

final class DetailOptionViewModel: ObservableObject {
    @Published var type: String
    @Published var name: String
    @Published var imageUrl: String
    
    init(type: String, name: String, imageUrl: String) {
        self.type = type
        self.name = name
        self.imageUrl = imageUrl
    }
}

struct DetailOptionView: View {
    @ObservedObject var viewModel: DetailOptionViewModel
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.type)
                    .font(CPFont.SwiftUI.r12)
                    .foregroundStyle(CPColor.SwiftUI.gray5)
                Text(viewModel.name)
                    .font(CPFont.SwiftUI.b14)
                    .foregroundStyle(CPColor.SwiftUI.bk)
            }
            
            Spacer()
            
            KFImage(URL(string: viewModel.imageUrl))
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    DetailOptionView(viewModel: .init(type: "색상",
                                      name: "코랄",
                                      imageUrl: "https://picsum.photos/id/96/100/100"))
}
