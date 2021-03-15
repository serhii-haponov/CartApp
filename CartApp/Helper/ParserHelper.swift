//
//  ParserHelper.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation

final class ParserHelper {
    
    static func parse<T: Codable>(data: Data, completion : (Result<T, ErrorResult>) -> Void) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            completion(.Success(response))
        } catch {
            completion(.Error(.parser(string: error.localizedDescription)))
        }
    }
}
