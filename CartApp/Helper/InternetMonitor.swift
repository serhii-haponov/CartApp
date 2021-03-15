//
//  InternetMonitor.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import Foundation
import Network

public class InternetMonitor {
  
  private var monitor: NWPathMonitor? = NWPathMonitor()
  var isReachable: Bool?

  func checkInternetConnection(completion: @escaping (Result<Bool, ErrorResult>) -> Void) {
    
    monitor?.pathUpdateHandler = { path in
      switch path.status {
      case .satisfied:
        print("Internet connection good!")
        self.setupBoolIsReachable(canReach: true)
        self.monitor?.cancel()
        completion(.Success(true))
        break
      case .unsatisfied:
        self.setupBoolIsReachable(canReach: false)
          completion(.Error(.network(string: "Internet connection seems to be offline!!!")))
        break
      case .requiresConnection:
        self.setupBoolIsReachable(canReach: false)
          completion(.Error(.network(string: "Internet connection seems to be offline!!!")))
        break
      @unknown default:
        fatalError()
      }
    }
    let queue = DispatchQueue.global(qos: .background)
    monitor?.start(queue: queue)
  }
  
  private func setupBoolIsReachable(canReach : Bool) {
    isReachable = canReach
  }
}
