//
//  ZNThankYou.swift
//  Zenith
//
//  Created by Anjali on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNThankYou: NSObject {

    var itemArray              : Array<ZNThankYou>              = []
    var message = ""

    var orderMessage            = ""
    var bookingDate             = ""
    var bookingTime             = ""
    var tableNo                 = ""
    var noOfPeople              = ""

    
    var transactionId           = ""
    var titleString             = ""
    var valueString             = ""
    var helpString              = ""
    var bookingId               = 0
    var appointmentId           = 0
    var customerId              = ""
    var mobileNumber            = ""

    
    
    class func getThankBookTableData(responseDict : Dictionary<String, AnyObject>?) -> ZNThankYou {
        let modalObj = ZNThankYou()
        modalObj.noOfPeople = responseDict?.validatedValue(KnumberOfPerson, expected: "" as AnyObject) as! String
        modalObj.bookingTime = responseDict?.validatedValue(KBookTime, expected: "" as AnyObject) as! String
        modalObj.helpString = responseDict?.validatedValue(KHelpNumber, expected: "" as AnyObject) as! String
        modalObj.bookingDate = ZNUtility.getDateFromString(responseDict?.validatedValue(KBookDate, expected: "" as AnyObject) as! String)
        modalObj.bookingId = responseDict?.validatedValue(KBookingId, expected: 0 as AnyObject) as! Int
        modalObj.customerId = responseDict?.validatedValue(KCustomerId, expected: "" as AnyObject) as! String
        return modalObj
    }
    class func getThankAppointmentData(responseDict : Dictionary<String, AnyObject>?) -> ZNThankYou {
        let modalObj = ZNThankYou()
        modalObj.noOfPeople = responseDict?.validatedValue(KnumberOfPerson, expected: "" as AnyObject) as! String
        modalObj.helpString = responseDict?.validatedValue(KHelpNumber, expected: "" as AnyObject) as! String
        modalObj.mobileNumber = responseDict?.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
        modalObj.bookingDate = ZNUtility.getDateFromString(responseDict?.validatedValue(KBookDate, expected: "" as AnyObject) as! String)
        modalObj.appointmentId = responseDict?.validatedValue(KAppointmentId, expected: 0 as AnyObject) as! Int
        modalObj.customerId = responseDict?.validatedValue(KCustomerId, expected: "" as AnyObject) as! String
        return modalObj
    }

}

