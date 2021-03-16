//
//  CartListViewModel.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import CoreData
import Network
import UIKit

class CartListViewModel {
    
  var dataSource: CartDataSource?
  private var apiService: CartApiServiceProtocol?
  var checkInternetHandling: ((Bool?) -> Void)?
  var errorHandling: ((ErrorResult?) -> Void)?
  let isLoading = Observable<Bool>(value: false)
  let isCollectionViewHidden = Observable<Bool>(value: false)
  
  init(dataSource: CartDataSource = CartDataSource(),
       apiService: CartApiServiceProtocol = CartApiService()) {
    self.dataSource = dataSource
    self.apiService = apiService
  }
  
  func fetchCartData(completion: @escaping (_ sucess: Bool) -> ()) {
    guard let service = apiService else {
      errorHandling?(.custom(string: "Sevice missing!!!"))
      return
    }
    service.getDataWith { (result) in
      switch result {
      case .Success(let data):
        self.clearData()
        self.saveInCoreDataWith(products: data.products)
        completion(true)
      case .Error(let message):
        DispatchQueue.main.async {
          self.errorHandling?(message)
          print(message)
          completion(false)
        }
      }
    }
  }
  
  func performFetch() {
    dataSource?.coreDataPerformFetch()
  }
  
  func fetchObjectAtIndex(index: IndexPath) -> ProductEntity? {
    guard let productObj = dataSource?.coreDatafetchObjectAtIndex(index) else {
      return nil
    }
    return productObj
  }
  
  func fetchCountForView() -> Int {
    return dataSource?.coreDataFetchCountForView() ?? 0
  }
  
  // MARK: - Data Process
  
  private func createProductEntityFrom(product: Product) {
    dataSource?.getViewContext(completion: { (viewContext) in
      guard let context = viewContext else { return }
      if let productEntity = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: context) as? ProductEntity {
        productEntity.productID = product.productID
        productEntity.name = product.name
        productEntity.price = product.price
        productEntity.imageUrl = product.imageUrl
      }
    })
  }
  
  private func saveInCoreDataWith(products: [Product]) {
    _ = products.map{ createProductEntityFrom(product: $0) }
    dataSource?.saveDataWithViewContext()
  }
  
  private func clearData() {
    dataSource?.clearCoreData()
  }
}
