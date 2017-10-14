//
//  ZNStoreDetailTableViewCell.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNStoreDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeListImageView: UIImageView!
    @IBOutlet weak var arrowTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
