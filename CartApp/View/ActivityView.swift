//
//  ActivityView.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import Foundation
import UIKit

struct ActivityView {
  
  lazy var loadingIdicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    loadingView.addSubview(indicator)
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
    ])
    return indicator
  }()
  
  private var loadingView: UIView
  
  init(loadingView: UIView) {
    self.loadingView = loadingView
  }
}
