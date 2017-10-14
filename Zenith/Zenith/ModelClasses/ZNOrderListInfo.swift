//
//  ZNOrderListInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNOrderListInfo: NSObject {

    var dishName = String()
    var dishPrice = String()
    var dishCount = NSInteger()
    var isChecked = Bool()
    var dishImage = UIImage()  
    var dishVat : String = "5%"
    var dishTax : String = "10%"
    var totalAmount : String = "$85"
    var extra = String()
    
    
}
