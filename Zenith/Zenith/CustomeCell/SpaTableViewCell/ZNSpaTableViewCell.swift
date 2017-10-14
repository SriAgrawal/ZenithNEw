//
//  ZNSpaTableViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSpaTableViewCell: UITableViewCell {

    @IBOutlet weak var spaImage: UIImageView!
    @IBOutlet weak var spaNameLabel: UILabel!
    @IBOutlet weak var spaAddressLabel: UILabel!
    @IBOutlet weak var arrowTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
