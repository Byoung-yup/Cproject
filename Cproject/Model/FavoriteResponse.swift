//
//  FavoriteResponse.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/03.
//

import Foundation

struct FavoritesResponse: Decodable {
    let favorites: [Product]
}
