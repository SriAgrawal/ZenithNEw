//
//  ZNSaveListTableViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSaveListTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var countryLabelInfo: UILabel!
    @IBOutlet weak var cityLabelInfo: UILabel!
    @IBOutlet weak var addressLabelInfo: UILabel!
   
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
