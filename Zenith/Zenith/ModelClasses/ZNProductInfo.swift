//
//  ZNProductInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductInfo: NSObject {
    
    var earnPoint = "500"
    var productId : String = ""
    var productName : String = ""
    var productPoint : String = ""
    var productImage : String = ""
    var storeCoverImage : String = ""
    var productStartDate = String()
    var productEndDate = String()
    var productPrice : String = ""
    var productType : String = ""
    var productQuantity : String = ""
    var productDescription : String = ""
    var productDiscount = String()
    var productDiscountValue :String = ""
    var rewardCoupons :String = ""
    var couponCode :String = ""
    var couponImage :String = ""
    var couponId :String = ""
    var retailersName = String()
    var retailersId = String()
    var addressId = String()
    var storeId = String()
    var storeName = String()
    var storeAddress = String()
    var productArray = Array<ZNProductInfo>()
    

    class func getTodaysOffers(responseDic : Array<Dictionary<String,Any>>) -> Array<ZNProductInfo> {
        var SectionArray = Array<ZNProductInfo>()
        
        for rowItem in responseDic {
            let objSection = ZNProductInfo()
            
            objSection.retailersName = rowItem.validatedValue("store_name", expected: "" as AnyObject) as! String
            objSection.retailersId = rowItem.validatedValue("store_id", expected: "" as AnyObject) as! String
            for rowItem in rowItem.validatedValue("offer_array", expected: NSArray()) as! Array<Dictionary<String, Any>> as Array {
                let rowObj = ZNProductInfo()
                rowObj.earnPoint = rowItem.validatedValue("points", expected: "" as AnyObject) as! String
                rowObj.productId = rowItem.validatedValue("offer_id", expected: "" as AnyObject) as! String
                rowObj.productName = rowItem.validatedValue("title", expected: "" as AnyObject) as! String
                rowObj.productDescription = rowItem.validatedValue("description", expected: "" as AnyObject) as! String
                rowObj.productStartDate = ZNUtility.getDateFromString(rowItem.validatedValue("start_date", expected: "" as AnyObject) as! String)
                rowObj.productEndDate = ZNUtility.getDateFromString(rowItem.validatedValue("end_date", expected: "" as AnyObject) as! String)
                rowObj.productImage = rowItem.validatedValue("offer_image", expected: "" as AnyObject) as! String
                rowObj.storeCoverImage = rowItem.validatedValue("cover_image", expected: "" as AnyObject)as! String
                rowObj.addressId = rowItem.validatedValue("address_id", expected: "" as AnyObject)as! String
                rowObj.storeId = rowItem.validatedValue("store_id", expected: "" as AnyObject)as! String
                rowObj.storeName = rowItem.validatedValue("store_name", expected: "" as AnyObject)as! String
                rowObj.storeAddress = "\(rowItem.validatedValue(KAddress, expected: "" as AnyObject)), \(rowItem.validatedValue(KCity, expected: "" as AnyObject)), \(rowItem.validatedValue(Kcountry, expected: "" as AnyObject))"
                objSection.productArray.append(rowObj)
            }
            SectionArray.append(objSection)
        }
        return SectionArray
    }
    
    class func getOffersList(responseDic : Dictionary<String, Any>) -> ZNProductInfo{
        let rowObj = ZNProductInfo()
        rowObj.earnPoint = responseDic.validatedValue("points", expected: "" as AnyObject) as! String
        rowObj.productPoint = responseDic.validatedValue("stamps", expected: "" as AnyObject) as! String
        rowObj.productId = responseDic.validatedValue("offer_id", expected: "" as AnyObject) as! String
        rowObj.productName = responseDic.validatedValue("title", expected: "" as AnyObject) as! String
        rowObj.productDescription = responseDic.validatedValue("description", expected: "" as AnyObject) as! String
        rowObj.productStartDate = ZNUtility.getDateFromString(responseDic.validatedValue("start_date", expected: "" as AnyObject) as! String)
        rowObj.productEndDate = ZNUtility.getDateFromString(responseDic.validatedValue("end_date", expected: "" as AnyObject) as! String)
        rowObj.couponImage = responseDic.validatedValue("coupon_image", expected: "" as AnyObject) as! String
        rowObj.couponId = responseDic.validatedValue("coupon_id", expected: "" as AnyObject) as! String
        rowObj.couponCode = responseDic.validatedValue("coupon_code", expected: "" as AnyObject) as! String
        rowObj.productImage = responseDic.validatedValue("offer_image", expected: "" as AnyObject) as! String
        rowObj.storeCoverImage = responseDic.validatedValue("cover_image", expected: "" as AnyObject)as! String
        rowObj.addressId = responseDic.validatedValue("address_id", expected: "" as AnyObject)as! String
        rowObj.storeId = responseDic.validatedValue("store_id", expected: "" as AnyObject)as! String
        rowObj.storeName = responseDic.validatedValue("store_name", expected: "" as AnyObject)as! String
        rowObj.storeAddress = "\(responseDic.validatedValue(KAddress, expected: "" as AnyObject)), \(responseDic.validatedValue(KCity, expected: "" as AnyObject)), \(responseDic.validatedValue(Kcountry, expected: "" as AnyObject))"
        
        return rowObj
    }

 class func getRewardPoints(responseArray : Array<Dictionary<String, Any>>) -> Array<ZNProductInfo> {
    var pointArray = Array<ZNProductInfo>()
    for pointItem in responseArray {
        let pointObj = ZNProductInfo()
        pointObj.productName = pointItem["pointName"]! as! String
        pointObj.productPrice = pointItem["pointPrice"]! as! String
        pointObj.productPoint = pointItem["rewardPoints"]! as! String
        pointObj.productImage = pointItem["pointImage"]! as! String
        pointArray.append(pointObj)
    }
    return pointArray
}
    
    class func getStoreOfferDetail(responseDict : Dictionary<String, AnyObject>?) -> ZNProductInfo {
        let objSection = ZNProductInfo()
        objSection.productId = responseDict?.validatedValue("offer_id", expected:"" as AnyObject) as! String
        objSection.productName = responseDict?.validatedValue("title", expected: "" as AnyObject) as! String
        objSection.productDescription = responseDict?.validatedValue("description", expected: "" as AnyObject) as! String
        objSection.productImage = responseDict?.validatedValue("offer_image", expected: "" as AnyObject) as! String
         objSection.couponImage = responseDict?.validatedValue("coupon_image", expected: "" as AnyObject) as! String
         objSection.couponId = responseDict?.validatedValue("coupon_id", expected: "" as AnyObject) as! String
         objSection.couponCode = responseDict?.validatedValue("coupon_code", expected: "" as AnyObject) as! String
        objSection.productStartDate = getDateFromString(strDate: responseDict?.validatedValue("start_date", expected: "" as AnyObject) as! String) 
        objSection.productEndDate = getDateFromString(strDate: responseDict?.validatedValue("end_date", expected: "" as AnyObject) as! String)
        objSection.storeCoverImage = responseDict?.validatedValue("cover_image", expected: "" as AnyObject) as! String
        
        objSection.addressId = responseDict?.validatedValue("address_id", expected: "" as AnyObject)as! String
        objSection.storeId = responseDict?.validatedValue("store_id", expected: "" as AnyObject)as! String
        objSection.storeName = responseDict?.validatedValue("store_name", expected: "" as AnyObject)as! String
        objSection.storeAddress = String.init(format: "%@, %@, %@", responseDict?.validatedValue(KAddress, expected: "" as AnyObject) as! CVarArg,responseDict?.validatedValue(KCity, expected: "" as AnyObject) as! CVarArg,responseDict?.validatedValue(Kcountry, expected: "" as AnyObject) as! CVarArg)
        return objSection
    }
}

     func getDateFromString(strDate: String) -> String {
        
        let date = Date(timeIntervalSince1970: Double(strDate)!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
