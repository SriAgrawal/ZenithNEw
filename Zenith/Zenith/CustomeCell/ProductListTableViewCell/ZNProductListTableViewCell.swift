//
//  ZNProductListTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 09/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductListTableViewCell: UITableViewCell {

    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productQuantity: UILabel!
    @IBOutlet var productImageview: UIImageView!
    @IBOutlet var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
