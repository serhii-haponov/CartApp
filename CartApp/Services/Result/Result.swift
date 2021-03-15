//
//  Result.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation

enum Result <T, E: Error> {
  case Success(T)
  case Error(E)
}
