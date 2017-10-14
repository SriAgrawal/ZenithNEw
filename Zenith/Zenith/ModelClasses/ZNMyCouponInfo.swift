//
//  ZNMyCouponInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNMyCouponInfo: NSObject {
    
    var productName : String = "Levis Jeans"
    var productPrice : String = "2800"
    var couponPrice : String = " ₹ 1250 "
    var couponImage = String()
    var productBrand : String = "Levis"
    var couponCode : String = "XYZ201"
    
    
    class func getCouponList(responseArray : Array<Dictionary<String, String>>) -> Array<ZNMyCouponInfo> {
        var CouponArray = Array<ZNMyCouponInfo>()
        for couponItem in responseArray {
            let couponObj = ZNMyCouponInfo()
            couponObj.productName = couponItem["productName"]!
            couponObj.productPrice = couponItem["productPrice"]!
            couponObj.couponPrice = couponItem["couponPrice"]!
            couponObj.couponImage = couponItem["couponImage"]!
            couponObj.couponCode = couponItem["couponCode"]!
            CouponArray.append(couponObj)
        }
        return CouponArray
    }
}
