//
//  ZNPointsTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNPointsTableViewCell: UITableViewCell {
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!

    @IBOutlet var pointLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.borderColor = UIColor.white.cgColor
        
        //Setting Corner Radius of the Image View
        self.itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
        itemImageView.layer.borderWidth = 1.0
        itemImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.45).cgColor
        itemImageView.layer.masksToBounds = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
