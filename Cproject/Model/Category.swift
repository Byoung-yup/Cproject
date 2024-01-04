//
//  Category.swift
//  Cproject
//
//  Created by 김병엽 on 2024/01/04.
//

import Foundation

struct Categories {
    let items: [Category]
    
    init(items: [Category] = [
        Category(imageName: "category1Big", title: "패션"),
        Category(imageName: "category2Big", title: "식품"),
        Category(imageName: "category3Big", title: "생활용품"),
        Category(imageName: "category4Big", title: "가전디지털"),
        Category(imageName: "category5Big", title: "스포츠"),
        Category(imageName: "category6Big", title: "애완용품"),
        Category(imageName: "category7Big", title: "파티용품"),
        Category(imageName: "category8Big", title: "가구")
    ]) {
        self.items = items
    }
}

struct Category {
    let imageName: String
    let title: String
}
