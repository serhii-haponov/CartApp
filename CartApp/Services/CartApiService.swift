//
//  CartApiService.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation

protocol CartApiServiceProtocol: class {
  func getDataWith(completion: @escaping (Result<ProductsData, ErrorResult>) -> Void)
}

final class CartApiService: RequestHandler, CartApiServiceProtocol {
    
  private lazy var endPoint: String = {
    return "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list"
  }()
  
  private var task: URLSessionTask?
  
  func getDataWith(completion: @escaping (Result<ProductsData, ErrorResult>) -> Void) {
    cancelFetch()
    task = RequestService().loadData(urlString: endPoint, completion: networkResult(completion: completion))
  }
  
  private func cancelFetch() {
    if let task = task {
      task.cancel()
    }
    task = nil
  }
}
