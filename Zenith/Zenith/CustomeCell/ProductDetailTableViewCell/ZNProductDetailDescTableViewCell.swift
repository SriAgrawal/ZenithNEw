//
//  ZNProductDetailDescTableViewCell.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductDetailDescTableViewCell: UITableViewCell {

    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
