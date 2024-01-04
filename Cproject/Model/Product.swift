//
//  Product.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let discount: String
    let originalPrice: Int
    let discountPrice: Int
}
