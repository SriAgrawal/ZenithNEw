//
//  ZNAddCardTableViewCell.swift
//  Zenith
//
//  Created by Ankit Kumar Gupta on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNAddCardTableViewCell: UITableViewCell {

    @IBOutlet var cardDetailTextField: UITextField!
    @IBOutlet var cardDetailButton: UIButton!
    @IBOutlet var cardDetailTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
