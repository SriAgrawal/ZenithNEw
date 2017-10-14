//
//  ZNOrderListTableViewCell.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNOrderListTableViewCell: UITableViewCell {

    @IBOutlet var distDescription: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dishListImageView.layer.borderColor = UIColor.white.cgColor
        dishListImageView.layer.cornerRadius = 4
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
