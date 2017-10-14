//
//  ZNProfileTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProfileTableViewCell: UITableViewCell {

    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
