//
//  ZNRewardPointsTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRewardPointsTableViewCell: UITableViewCell {
    
    @IBOutlet var rewardPointLabel: UILabel!
    @IBOutlet var pointPriceLabel: UILabel!
    @IBOutlet var pointNameLabel: UILabel!
    @IBOutlet var pointImageView: UIImageView!
    @IBOutlet var trailingConstraintLabel: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
