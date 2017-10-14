//
//  ZNRetailersSettingTableViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRetailersSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var retailersRadioButton: UIButton!
    @IBOutlet weak var switchIndicator: UISwitch!
    @IBOutlet weak var retailersLabel: UILabel!
    @IBOutlet weak var retailersImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func radioButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
