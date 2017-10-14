//
//  ZNDishInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNDishInfo: NSObject {
    
       var itemArray              : Array<ZNDishInfo>              = []
    var dishName = String()
    var dishID = String()

    var dishImage = String()
    var dishPrice = String()
    var dishQuantity = String()
    var earnedPoints = String()
    var isSelected = Bool()
    var dishCount = NSInteger()
    var dishTotalCount = Float()

    var specialIngrediant = String()
    var dishDescription = String()
    var currencySymbol = String()

    
    class func parsePageDishData(dictData:Dictionary <String, AnyObject>?) -> ZNDishInfo {
        
        let obj = ZNDishInfo()
        obj.dishName = dictData?.validatedValue(KProductName, expected: "" as AnyObject) as! String
        obj.dishPrice = dictData?.validatedValue(KProductPrice, expected: "" as AnyObject) as! String
        obj.dishQuantity = dictData?.validatedValue(KProductQuantity, expected: "" as AnyObject) as! String
        obj.dishImage = dictData?.validatedValue(KProductImage, expected: "" as AnyObject) as! String
        obj.dishID = dictData?.validatedValue(KProductId, expected: "" as AnyObject) as! String
        obj.dishDescription = dictData?.validatedValue(KProductDescription, expected: "" as AnyObject) as! String

        obj.dishCount = 1
        obj.isSelected = false
        obj.specialIngrediant = ""
        obj.dishTotalCount = Float(obj.dishQuantity)!
        
        return obj
    }
    
    
    
    
}
