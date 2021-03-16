//
//  FetchDataController.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import UIKit
import CoreData

struct FetchDataController {
  
  lazy var fetchHandler: NSFetchedResultsController<NSFetchRequestResult>? = {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ProductEntity.self))
    
    // sort contents by name
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let dataFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!, sectionNameKeyPath: nil, cacheName: nil)
    
    return dataFetchResultController
  }()
}

