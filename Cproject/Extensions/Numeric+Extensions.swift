//
//  Numeric+Extensions.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/02.
//

import Foundation

extension Numeric {
    var moneyString: String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return (formatter.string(for: self) ?? "") + "원"
    }
}
