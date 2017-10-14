//
//  ZNRetailersInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRetailersInfo: NSObject {

    var retailerName = String()
    var retailerRadioButton = String()
    var reatilerButton = UIButton()
    var retailerImage = String()
    var retailerNotificationStatus = String()
    var retailerID = String()
    var retailerPoints = String()
    var retailerCoverImage = String()
    var retailerRewardType = String()
    var stamp = String()



    
    
    
    class func getRetailerDetail(responseDict : Dictionary<String, AnyObject>?) -> ZNRetailersInfo {
            let objSection = ZNRetailersInfo()
            objSection.retailerName = responseDict?.validatedValue("store_name", expected:"" as AnyObject) as! String
            objSection.retailerID = responseDict?.validatedValue("store_id", expected: "" as AnyObject) as! String
        objSection.retailerImage = responseDict?.validatedValue("icon_image", expected: "" as AnyObject) as! String
        objSection.retailerNotificationStatus = responseDict?.validatedValue("notification_setting", expected: "" as AnyObject) as! String

        return objSection
    }
    
    class func getMypoints(responseDict : Dictionary<String, AnyObject>?) -> ZNRetailersInfo {
        let objSection = ZNRetailersInfo()
        objSection.retailerName = responseDict?.validatedValue("store_name", expected:"" as AnyObject) as! String
        objSection.retailerID = responseDict?.validatedValue("store_id", expected: "" as AnyObject) as! String
        objSection.retailerImage = responseDict?.validatedValue("icon_image", expected: "" as AnyObject) as! String
        objSection.retailerCoverImage = responseDict?.validatedValue("cover_image", expected: "" as AnyObject) as! String
        objSection.retailerPoints = responseDict?.validatedValue("points", expected: "" as AnyObject) as! String
        objSection.retailerRewardType = responseDict?.validatedValue("reward_type", expected: "" as AnyObject) as! String
        objSection.stamp = responseDict?.validatedValue("stamps", expected: "" as AnyObject) as! String
        
        
        return objSection
    }
    
    class func getStamp(responseDict : Dictionary<String, AnyObject>?) -> ZNRetailersInfo {
        let objSection = ZNRetailersInfo()
        objSection.retailerName = responseDict?.validatedValue("store_name", expected:"" as AnyObject) as! String
        objSection.retailerID = responseDict?.validatedValue("store_id", expected: "" as AnyObject) as! String
        objSection.retailerImage = responseDict?.validatedValue("icon_image", expected: "" as AnyObject) as! String
        objSection.retailerCoverImage = responseDict?.validatedValue("cover_image", expected: "" as AnyObject) as! String
        objSection.retailerPoints = responseDict?.validatedValue("points", expected: "" as AnyObject) as! String
        objSection.retailerRewardType = responseDict?.validatedValue("reward_type", expected: "" as AnyObject) as! String
         objSection.stamp = responseDict?.validatedValue("stamps", expected: "" as AnyObject) as! String
        
        
        return objSection
    }


    
}
