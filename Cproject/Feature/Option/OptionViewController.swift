//
//  OptionViewController.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit
import SwiftUI

final class OptionViewController: UIViewController {
    
    let viewModel: OptionViewModel = OptionViewModel()
    lazy var rootView: UIHostingController = UIHostingController(rootView: OptionRootView(viewModel: viewModel))

    override func viewDidLoad() {
        super.viewDidLoad()

        addRootView()
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
}
