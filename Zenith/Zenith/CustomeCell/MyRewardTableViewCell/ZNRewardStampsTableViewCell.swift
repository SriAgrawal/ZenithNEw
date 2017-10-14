//
//  ZNRewardStampsTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRewardStampsTableViewCell: UITableViewCell {
 
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var stampRedeem: UIButton!
    @IBOutlet var restaurantStampPrice: UILabel!
    @IBOutlet var restaurantStampName: UILabel!
    @IBOutlet var stampImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
