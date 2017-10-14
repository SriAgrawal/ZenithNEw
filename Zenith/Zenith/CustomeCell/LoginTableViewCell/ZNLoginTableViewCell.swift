//
//  ZNLoginTableViewCell.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 06/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNLoginTableViewCell: UITableViewCell {

    @IBOutlet weak var dateBookinBtn: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var leadingConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintOutlet: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
