//
//  ZNUserShippingDetailTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 06/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNUserShippingDetailTableViewCell: UITableViewCell {

    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var userDetailImageView: UIImageView!
    @IBOutlet var userDetailTextField: BTCustomTextfield!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
