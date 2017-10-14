//
//  ZNMyCouponsTableViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNMyCouponsTableViewCell: UITableViewCell {

    @IBOutlet weak var couponValidDate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var myCouponImageView: UIImageView!
    @IBOutlet weak var imagetrailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
