//
//  ZNDishListCollectionViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNDishListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dishQuantityLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     //   dishImageView.layer.borderColor = UIColor.white.cgColor
       // dishImageView.layer.cornerRadius = 4
   
    }

}
