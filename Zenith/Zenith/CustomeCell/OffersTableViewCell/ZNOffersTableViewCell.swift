//
//  ZNOffersTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNOffersTableViewCell: UITableViewCell {

    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var rewardPointLabel: UILabel!
    @IBOutlet var pointPriceLabel: UILabel!
    @IBOutlet var pointNameLabel: UILabel!
    @IBOutlet var pointImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
//        productImageView.layer.borderColor = UIColor.white.cgColor
//        productImageView.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
