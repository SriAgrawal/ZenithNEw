//
//  ZNTodayOfferHeaderCell.swift
//  Zenith
//
//  Created by Suresh patel on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNTodayOfferHeaderCell: UITableViewCell {

    @IBOutlet var retailersName: UILabel!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var retailersNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
