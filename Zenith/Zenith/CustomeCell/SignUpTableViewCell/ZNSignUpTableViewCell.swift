//
//  ZNSignUpTableViewCell.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSignUpTableViewCell: UITableViewCell {
    
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var dobButton: UIButton!
    
    @IBOutlet var signUpTextField: UITextField!
    
    @IBOutlet var signUpImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
