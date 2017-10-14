//
//  ZNCategoryInfo.swift
//  Zenith
//
//  Created by Ankit Kumar Gupta on 25/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNCategoryInfo: NSObject {
    
    var name: String = ""
    var type: String = ""
    var dishArray = [Any]()
    var categoryID: String = ""
    var totalDish: String = ""
    var totalPrice =  Float()
    var currencySymbol = String()

    
    class func parsePageCategoryData(dict:Dictionary <String, AnyObject>?) -> ZNCategoryInfo {
        
        let obj = ZNCategoryInfo()
        obj.name = dict?.validatedValue(KCategoryName, expected: "" as AnyObject) as! String
        obj.categoryID = dict?.validatedValue(KCategory_Id, expected: "" as AnyObject) as! String
        obj.type = dict?.validatedValue(KCategory_Type, expected: "" as AnyObject) as! String
        
        

        let response = dict as! NSDictionary
        
        if let dictNew = response.object(forKey: "products") as? NSArray {
            
            for rowItem in dictNew as! Array<Dictionary<String,Any>>{
                
                obj.dishArray += [ZNDishInfo .parsePageDishData(dictData: rowItem as Dictionary<String, AnyObject>)]
                
                
            }
        }
        
        
        return obj
    }

}
