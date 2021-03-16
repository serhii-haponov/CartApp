//
//  ProductEntity.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var productID: String?
}

extension ProductEntity : Identifiable {

}
