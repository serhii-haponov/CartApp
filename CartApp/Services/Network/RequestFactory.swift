//
//  RequestFactory.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation

final class RequestFactory {
  
  enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
  }
  
  static func request(method: Method, url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
  }
}
