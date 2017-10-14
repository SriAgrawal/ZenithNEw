//
//  ZNTodayOffersTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNTodayOffersTableViewCell: UITableViewCell {
    @IBOutlet var offerPriceLabel: UILabel!

    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var offerProductLabel: UILabel!
    @IBOutlet var todayOfferImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
