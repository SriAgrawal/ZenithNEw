//
//  ZNPointStatusTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 08/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNPointStatusTableViewCell: UITableViewCell {

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemAddressLabel: UILabel!
    @IBOutlet var itemOfferLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //Setting Corner Radius  of the Image View
        self.itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
        itemImageView.layer.borderWidth = 1.0
        itemImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.45).cgColor
        itemImageView.layer.masksToBounds = false

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
