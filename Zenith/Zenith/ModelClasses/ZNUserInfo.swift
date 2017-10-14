//
//  ZNUserInfo.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNUserInfo: NSObject {
    
    var email = String()
    var password = String()
    var termsAndConditions = Bool()
    var firstName = String()
    var lastName = String()
    var dob = String()
    var mobileNumber = String()
    var confirmPassword = String()
    var oldPassword = String()
    var newPassword = String()
    var desc = String()
    var profileImageBase64 = String()
    var socialType = String()
    
    

    //Appointment Info
    var bodyMassage = String()
    var dateOfBooking = String()
    
    //User Delivery Address Info
    var name = String()
    var pincode = String()
    var postcode = String()
    var address = String()
    var country = String()
    var landmark = String()
    
    //Payment Method 
    var paymentMethod = String()
    
  class func getDataOfProfile(userInfo: Dictionary<String, AnyObject>?) -> ZNUserInfo {
        
        let userObj = ZNUserInfo()
    
            userObj.firstName = userInfo?.validatedValue(KfirstName, expected: "" as AnyObject) as! String
            userObj.lastName = userInfo?.validatedValue(KLastName, expected: "" as AnyObject) as! String
            userObj.email = userInfo?.validatedValue(Kemail, expected: "" as AnyObject) as! String
            userObj.mobileNumber = userInfo?.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
            userObj.dob = userInfo?.validatedValue(Kdob, expected: "" as AnyObject) as! String
            userObj.profileImageBase64 = userInfo?.validatedValue(KProfileImage, expected: "" as AnyObject) as! String
            userObj.socialType = userInfo?.validatedValue("social_type", expected: "" as AnyObject) as! String
        return userObj
    }
    
    class func getDataOfAddress(userInfo: Dictionary<String, AnyObject>?) -> ZNUserInfo {
        
        let userObj = ZNUserInfo()
        
        userObj.name = userInfo?.validatedValue(KName, expected: "" as AnyObject) as! String
        userObj.postcode = userInfo?.validatedValue(Kpostcode, expected: "" as AnyObject) as! String
        userObj.mobileNumber = userInfo?.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
        userObj.address = userInfo?.validatedValue(KAddress, expected: "" as AnyObject) as! String
        userObj.country = userInfo?.validatedValue(Kcountry, expected: "" as AnyObject) as! String
        userObj.landmark = userInfo?.validatedValue("landmark", expected: "" as AnyObject) as! String
        return userObj
    }
}
