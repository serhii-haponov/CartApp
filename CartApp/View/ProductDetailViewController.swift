//
//  ProductDetailViewController.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var image: String?
    
    @IBOutlet private weak var productImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            productImageView.loadImageUsingCacheWithURLString(image, placeHolder: UIImage(named: "placeholder"))
        }
    }
}
