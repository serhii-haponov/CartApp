//
//  ProductModel.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation


struct ProductsData: Codable {
    let products: [Product]
}

struct Product: Codable {
    let productID: String
    let name: String
    let price: Double
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case name, price, imageUrl
    }
}

