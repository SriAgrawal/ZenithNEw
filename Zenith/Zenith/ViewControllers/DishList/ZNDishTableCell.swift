//
//  ZNDishTableCell.swift
//  Zenith
//
//  Created by Shridhar Agarwal on 19/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNDishTableCell: UITableViewCell {

    @IBOutlet var noOfDishLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDiscriptionLabel: UILabel!
    @IBOutlet weak var dishListImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var extraTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
