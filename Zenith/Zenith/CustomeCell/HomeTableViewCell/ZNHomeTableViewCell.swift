//
//  ZNHomeTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNHomeTableViewCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLbl: UILabel!
    @IBOutlet var profileWorkLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var profileCoverImageView: UIImageView!
    @IBOutlet var outerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setting Shadow of the View
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
