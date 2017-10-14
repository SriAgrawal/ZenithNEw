//
//  ZNJoinUsTableCell.swift
//  Zenith
//
//  Created by Shridhar Agarwal on 17/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNJoinUsTableCell: UITableViewCell {

    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
