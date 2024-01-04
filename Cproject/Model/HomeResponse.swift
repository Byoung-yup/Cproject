//
//  HomeResponse.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/02.
//

import Foundation

struct HomeResponse: Decodable {
    let banners: [Banner]
    let horizontalProducts: [Product]
    let verticalProducts: [Product]
    let themes: [Banner]
}

struct Banner: Decodable {
    let id: Int
    let imageUrl: String
}
