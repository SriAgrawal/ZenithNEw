//
//  ZNProductDetailTableViewCell.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductDetailTableViewCell: UITableViewCell {
   
    @IBOutlet weak var productSpecLabel: UILabel!
    @IBOutlet weak var productValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
