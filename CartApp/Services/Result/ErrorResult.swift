//
//  ErrorResult.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

enum ErrorResult: Error {
  case network(string: String)
  case parser(string: String)
  case custom(string: String)
  
  var value: String {
    switch self {
    case .network(string: let value):
      return value
    case .parser(string: let value):
      return value
    case let .custom(string: value):
      return value
    }
  }
}
