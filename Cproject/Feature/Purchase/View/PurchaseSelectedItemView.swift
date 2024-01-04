//
//  PurchaseSelectedItemView.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import UIKit

struct PurchaseSelectedItemViewModel {
    var title: String
    var description: String
}

final class PurchaseSelectedItemView: UIView {
    
    private var containerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = CPFont.UIKit.r12
        lbl.textColor = CPColor.UIKit.bk
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = CPFont.UIKit.r12
        lbl.textColor = CPColor.UIKit.gray5
        return lbl
    }()
    
    private var Spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    var viewModel: PurchaseSelectedItemViewModel
    
    private var containerStackViewConstraints: [NSLayoutConstraint]?
    
    init(viewModel: PurchaseSelectedItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if containerStackViewConstraints == nil {
            let constraints = [
                containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(constraints)
            containerStackViewConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func commonInit() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(contentStackView)
        containerStackView.addArrangedSubview(Spacer)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        setBorder()
        setViewModel()
    }
    
    private func setBorder() {
        layer.borderColor = CPColor.UIKit.gray0.cgColor
        layer.borderWidth = 1
    }
    
    private func setViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

#Preview {
    PurchaseSelectedItemView(viewModel: .init(title: "hel", description: "hi"))
}
