//
//  OptionRootView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import SwiftUI

struct OptionRootView: View {
    @ObservedObject var viewModel: OptionViewModel
    
    var body: some View {
        Text("옵션 화면")
    }
}

#Preview {
    OptionRootView(viewModel: OptionViewModel())
}
