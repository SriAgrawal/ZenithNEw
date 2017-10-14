//
//  ZNCardOnfo.swift
//  Zenith
//
//  Created by Ankit Kumar Gupta on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNCardOnfo: NSObject {

    
    var strCardNumber:String = ""
    var strCardRxpiryNumber:String = ""
    var strCVVNumber:String = ""
    var strName:String = ""
    var strMonth:String = ""
    var strYear:String = ""

    var strCardID:String = ""

    
    
    class func getCardInfo(responseDict : Dictionary<String, AnyObject>?) -> ZNCardOnfo {
        let objSection = ZNCardOnfo()
        objSection.strCardNumber = AESCrypt.decrypt(responseDict?.validatedValue("card_number", expected:"" as AnyObject) as! String, password: KEncryptionKey)
        
         objSection.strYear = AESCrypt.decrypt(responseDict?.validatedValue("expiry_year", expected:"" as AnyObject) as! String, password: KEncryptionKey)
        
         objSection.strMonth = AESCrypt.decrypt(responseDict?.validatedValue("expiry_month", expected:"" as AnyObject) as! String, password: KEncryptionKey)
        
        //let mont : String = responseDict?.validatedValue("expiry_year", expected:"" as AnyObject) as! String
        
      //  objSection.strYear = AESCrypt.decrypt(mont, password: KEncryptionKey)
        
        
        objSection.strCardID  = responseDict?.validatedValue("card_id", expected:"" as AnyObject) as! String
        
        objSection.strName  = responseDict?.validatedValue("name_on_card", expected:"" as AnyObject) as! String
        
        objSection.strCardRxpiryNumber = String (format: "%@/%@",objSection.strMonth,objSection.strYear )

        return objSection
    }
    
}
