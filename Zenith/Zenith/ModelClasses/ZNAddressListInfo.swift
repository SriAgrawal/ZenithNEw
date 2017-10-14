//
//  ZNAddressListInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNAddressListInfo: NSObject {
    var addressLabel = String()
    var nameLabel = String()
    var mobileLabel = String()
    var landMarkLabel : String = "Delhi"
    var countryLabel : String = "India"
    var addressId : String = ""
    
    var cardName : String = ""
    var cardNumber : String = ""
    var cardExpiry : String = ""
    var cardID : String = ""

    
    
    
    class func getAddressArray(responseArray : Array<Dictionary<String, String>>) -> Array<ZNAddressListInfo> {
        var addressInfoArray = Array<ZNAddressListInfo>()
        for addressItem in responseArray {
            let addressObj = ZNAddressListInfo()
            addressObj.addressId = addressItem.validatedValue(KAddress_Id, expected: "" as String as AnyObject) as! String
            addressObj.addressLabel = addressItem.validatedValue(KAddress, expected: "" as String as AnyObject) as! String
            addressObj.landMarkLabel = addressItem.validatedValue("landmark", expected: "" as String as AnyObject) as! String
            addressObj.countryLabel = addressItem.validatedValue(Kcountry, expected: "" as String as AnyObject) as! String
            addressObj.nameLabel = addressItem.validatedValue(KName, expected: "" as String as AnyObject) as! String
            addressObj.mobileLabel = addressItem.validatedValue(KPhoneNumber, expected: "" as String as AnyObject) as! String
            addressInfoArray.append(addressObj)
        }
        return addressInfoArray
    }
    
    
    
    
//    "address_id": "1",
//    "name": "fadffaf",
//    "address": "D115 Okhla",
//    "postcode": "110030",
//    "mobile": "204343417",
//    "landmark": "Mother dairy",
//    "country": "India",
//    "updated": "1499252563",
//    "created": "1499252563"
    


    class func getCardArray(responseArray : Array<Dictionary<String, String>>) -> Array<ZNAddressListInfo> {
        var cardInfoArray = Array<ZNAddressListInfo>()
        for cardItem in responseArray {
            let cardObj = ZNAddressListInfo()
            cardObj.cardName = cardItem["cardName"]!
            cardObj.cardNumber = cardItem["cardNumber"]!
            cardObj.cardExpiry = cardItem["cardExpiry"]!
            
            
            cardObj.cardName = cardItem["cardName"]!
            cardObj.cardNumber = cardItem["cardNumber"]!
            cardObj.cardExpiry = cardItem["cardExpiry"]!
            
            
            cardInfoArray.append(cardObj)
        }
        return cardInfoArray
    }

}
