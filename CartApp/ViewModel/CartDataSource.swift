//
//  CartDataSource.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import UIKit
import CoreData

class CartDataSource: NSObject {
  
  var fetchDataController: FetchDataController?
  
  init(_ fetchDataController: FetchDataController = FetchDataController()) {
    self.fetchDataController = fetchDataController
  }
  
  func getViewContext(completion: @escaping (_ viewContext: NSManagedObjectContext?) -> ()) {
    if Thread.isMainThread {
      completion((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    } else {
      DispatchQueue.main.async {
        completion((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
      }
    }
  }
  
  func saveDataWithViewContext() {
    if Thread.isMainThread {
      saveContextInMainThread()
    } else {
      DispatchQueue.main.async {
        self.saveContextInMainThread()
      }
    }
  }
  
  func saveContextInMainThread() {
    do {
      try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.save()
    } catch let error {
      debugPrint("\(type(of: self)): \(#function): \(error)")
    }
  }
  
  func clearCoreData () {
    getViewContext(completion: { (viewContext) in
      guard let context = viewContext else { return }
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
      do {
        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        _ = objects.map{$0.map{context.delete($0)}}
        self.saveDataWithViewContext()
      } catch let error {
        debugPrint("\(type(of: self)): \(#function): ERROR DELETING : \(error)")
      }
    })
  }
  
  func coreDataPerformFetch() {
    do {
      try fetchDataController?.fetchHandler?.performFetch()
    } catch (let error) {
      debugPrint("\(type(of: self)): \(#function): \(error.localizedDescription)")
    }
  }
  
  func coreDatafetchObjectAtIndex(_ index: IndexPath) -> ProductEntity? {
    guard let productEntity = fetchDataController?.fetchHandler?.object(at: index) as? ProductEntity else {
      return nil
    }
    return productEntity
  }
  
  func coreDataFetchCountForView() -> Int? {
    return fetchDataController?.fetchHandler?.sections?.first?.numberOfObjects
  }
}
