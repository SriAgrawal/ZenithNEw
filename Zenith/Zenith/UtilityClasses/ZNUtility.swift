//
//  ZNUtility.swift
//  Zenith
//
//  Created by Suresh patel on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

let showLog = true

class ZNUtility: NSObject {

    func getCurrentShortDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getTimeFrom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
  class func getTimeStampFromDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDate = dateFormatter .date(from: date)
        
        var timeSince1970 = Int(NSTimeIntervalSince1970)
        timeSince1970 = (Int)((currentDate? .timeIntervalSince1970)!)
        return String(format:"%d", timeSince1970)
    }
    
 class func getDateFromString(_ date: String) -> String {
        
        let date = Date(timeIntervalSince1970: Double(date)!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    
}

func trimWhiteSpace (_ str: String) -> String {
    let trimmedString = str.trimmingCharacters(in: CharacterSet.whitespaces)
    return trimmedString
}

// custom log
func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    if (showLog) {
        print("\(function): \(line): \(message)")
        //Log.writeLog(message: message, clazz: file, function: function, line: line, column: column)
    }
}

func jwtTokenInfo(_ tokenStr:String) -> Dictionary<String, AnyObject>? {
    
    let segments = tokenStr.components(separatedBy: ".")
    
    var base64String = segments[1] as String
    
    if base64String.characters.count % 4 != 0 {
        let padlen = 4 - base64String.characters.count % 4
        base64String += String(repeating: "=", count: padlen)
    }
    
    if let data = Data(base64Encoded: base64String, options: []) {
        do {
            let tokenInfo = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return tokenInfo as? Dictionary<String, AnyObject>
        } catch {
            logInfo("error to generate jwtTokenInfo >>>>>>  \(error)")
        }
    }
    return nil
}

