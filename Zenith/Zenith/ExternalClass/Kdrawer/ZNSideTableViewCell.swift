//
//  ZNSideTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSideTableViewCell: UITableViewCell {
    @IBOutlet var menuListLabel: UILabel!
    @IBOutlet var notificationCountLabel: UILabel!
    @IBOutlet var menuImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
