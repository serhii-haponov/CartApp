//
//  RequestHandler.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation

class RequestHandler {
  
  func networkResult<T: Codable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
    ((Result<Data, ErrorResult>) -> Void) {
      
      return { dataResult in
        DispatchQueue.global(qos: .background).async(execute: {
          switch dataResult {
          case .Success(let data) :
            ParserHelper.parse(data: data, completion: completion)
            break
          case .Error(let error) :
            print("Network error \(error)")
            completion(.Error(.network(string: "Network error " + error.localizedDescription)))
            break
          }
        })
      }
  }
}
