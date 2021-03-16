//
//  ProductCollectionViewCell.swift
//  CartApp
//
//  Created by SerhiiHaponov on 16.03.2021.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAll()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageview.image = nil
    }
    
    // MARK: - Configuration
    
    func setWith(product: ProductEntity) {
        nameLabel.text = product.name
        priceLabel.text = String(format: "%.2f", product.price)
        if let imageUrl = product.imageUrl {
            productImageview.loadImageUsingCacheWithURLString(imageUrl, placeHolder: UIImage(named: "placeholder"))
        }
    }
    
    private func configureAll() {
        configureCell()
    }
    
    private func configureCell() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
    }
    
}
