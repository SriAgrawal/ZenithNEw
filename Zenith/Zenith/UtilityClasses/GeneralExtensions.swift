//
//  GeneralExtensions.swift
//  Template
//
//  Created by Raj Kumar Sharma on 04/04/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import UIKit
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let imageCache = NSCache<AnyObject, AnyObject>()

func datePredicateForNumberOfDays(number : Int, predicateKey : String) -> NSPredicate {
    var calendar = Calendar.current
    calendar.timeZone = NSTimeZone.local
    
    // Get today's beginning & end
    let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
    components.day! += number
    let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
    // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
    
    // Set predicate as date being today's date
    let datePredicate = NSPredicate(format: "(%@ <= \(predicateKey)) AND (\(predicateKey) < %@)", argumentArray: [dateFrom, dateTo])
    
    return datePredicate
}

// MARK:- String Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func nsRange( from range : Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper   = UTF16View.Index(range.upperBound,   within: utf16)
        return NSRange(location: utf16.startIndex.distance(to:  lower), length: lower.distance(to: upper))
        
   }
    
   }

// MARK:- Array Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

//MARK:- Date Extension
extension Date {
    var millisecondsSince1970:Int {
            return Int((self.timeIntervalSince1970).rounded())
    }
        
    init(milliseconds:Int) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) yrs ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) w ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) d ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hrs ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) mins ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) sec ago" }
        return ""
    }
    
    
    func onlyDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateStringWithoutTime = dateFormatter.string(from: self)
        let dateWithoutTime = dateFormatter.date(from: dateStringWithoutTime)
        
        return dateWithoutTime
        
    }
}

// MARK:- Dictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


extension Dictionary {
    
    func toJSON() ->NSData {
        
        let bytes = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        return bytes as NSData
    }
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)" as AnyObject
            }
                
                // checking if object is of desired class
            else if ((object as AnyObject).isKind(of: expected.classForCoder) == false) {
                //logInfo("case // checking if object is of desired class....not")
                
                return expected
            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    //logInfo("null string")
                    return "" as AnyObject
                }
            }
            
            return object as AnyObject
        } else {
            
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            
            return expected
        }
    }
   
}

// MARK:- UIColor Extension

//extension UIColor {
//    class func appYellowColor() -> UIColor {
//       // return RGBA(r: 238, g: 92, b: 48, a: 1)
//    }
//    class func appBlueColor() -> UIColor {
//        return UIColor(red: 45.0/255.0, green: 195.0/255.0, blue: 250.0/255.0, alpha: 1.0)
//        
//    }
//}

// MARK:- UIImageView Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
extension UIImageView {

    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        // check for cache
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            
            self.image = cachedImage
            
            return
        }
        
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard
                
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                
                let data = data, error == nil,
                
                let image = UIImage(data: data)
                
                else {
                    
                    self.image = UIImage.init(named: "placeholder")
                    
                    return
            }
            
            DispatchQueue.main.async() { () -> Void in
                
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                
                self.image = image
            }
            }.resume()
        
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
        
    }
    
    
     func loadImageFromLocalPath(fileURL: String) {
        do {
            let imageData = try Data(contentsOf: URL.init(string: fileURL)!)
            DispatchQueue.main.async() { () -> Void in
                self.image = UIImage(data: imageData)
                return
            }
        } catch {
            print("Error loading image : \(error)")
            return
        }
    }

}

// MARK:- NSDictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension NSDictionary {
    
    func toNSData() -> NSData {
        return try! JSONSerialization.data(withJSONObject: self, options: []) as NSData
    }
    
    func toJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
    
    
    
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)" as AnyObject
            }
                
                // checking if object is of desired class
                //            else if (object.isKind(of: expected.classForCoder) == false) {
                //                //logInfo("case // checking if object is of desired class....not")
                //
                //                return expected
                //            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    //logInfo("null string")
                    return "" as AnyObject
                }
            }
            
            return object as AnyObject
            
        } else {
            
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            
            return expected
        }
    }
}

// MARK:- UIView Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.clear
        }
        set {
            
            self.layer.borderColor = newValue?.cgColor
            self.layer.borderWidth = 1.0
        }
    }
    
    func shadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }
    
    func setNormalRoundedShadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
    }
    
    func setBorder(color:UIColor, borderWidth:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
  
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
    
    
    //MARK:- UILAbel Extension
    func drawTextInRect(rect: CGRect) {
        
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        self.drawTextInRect(rect: UIEdgeInsetsInsetRect(rect, insets))
        
    }
    
   
    func setCharacterSpacig(string:String) -> NSMutableAttributedString {
        
        let attributedStr = NSMutableAttributedString(string: string)
        attributedStr.addAttribute(NSKernAttributeName, value: 1.25, range: NSMakeRange(0, attributedStr.length))
        return attributedStr
    }
    
//// MARK:- UIViewController Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//private var progressHUDTimer: Timer?
//
//extension UIViewController {
//
//    // TODO: Review both methods below: `showProgressHUD` and `hideProgressHUD`.
//    // There might be a better API design.
//    
//    /// Creates a new HUD, adds it to this view controller view and shows it.
//    /// The counterpart to this method is `hideProgressHUD`.
//    func showProgressHUD(animated animated: Bool = true, whiteColor: Bool = false) {
//        hideProgressHUD(animated: false)
//        /// Grace period is the time (in seconds) that the background operation
//        /// may be run without showing the HUD. If the task finishes before the
//        /// grace time runs out, the HUD will not be shown at all.
//        ///
//        /// This *was* supposed to be done by the `graceTime` property, but it
//        /// doesn't seem to be working at all. So we rolled our own implementation.
//        let graceTime = 0.100
//        progressHUDTimer = Timer.scheduledTimerWithTimeInterval(graceTime) {
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: animated)
//            hud.taskInProgress = true
//            hud.graceTime = 0
//            hud.square = true
//            hud.minSize = CGSize(width: 50, height: 50)
//            if whiteColor {
//                hud.color = UIColor.whiteColor()
//                hud.activityIndicatorColor = UIColor.grayColor()
//            }
//        }
//    }
//    
//    /// Finds all the HUD subviews and hides them.
//    func hideProgressHUD(animated animated: Bool = true) {
//        progressHUDTimer?.dispose()
//        progressHUDTimer = nil
//        for hud in MBProgressHUD.allHUDsForView(self.view) as! [MBProgressHUD] {
//            hud.taskInProgress = false
//            hud.hide(true)
//        }
//    }
//
//}
    
    
}

//MARK:- UILabel Extension

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
    
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    func makeAtttributedText(range: NSRange , text: String , size : CGFloat)  {
        let stringAttributed = NSMutableAttributedString.init(string: text as String)
        let font = UIFont.textBookFont(fontSize: size)
        stringAttributed.addAttribute(NSFontAttributeName, value:font, range: range)
        stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 0/255, green: 181/255, blue: 251/255, alpha: 1.0),  range: range)
        self.attributedText = stringAttributed

 }
}


//MARK:- UIButton Extension

extension UIButton {
    
    func underlineButton(text: String) {
        
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    func underlineWithSpaceButton(spacing:CGFloat, text: String) {
        
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
        titleString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }

    func addCharactersSpacing(spacing:CGFloat, text:String) {
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}


//MARK:- UITextView Extension

extension UITextView {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font as Any, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
}

//MARK:- UIFont Extension

extension UIFont {
    
    class func textBookFont(fontSize: CGFloat) -> UIFont {
        let font = UIFont(name: "ITCKabelStd-Book", size: fontSize)!
        return font
    }
    class func textMediumFont(fontSize: CGFloat) -> UIFont {
        let font = UIFont(name: "ITCKabelStd-Medium", size: fontSize)!
        return font
    }
    class func textBoldFont(fontSize: CGFloat) -> UIFont {
        let font = UIFont(name: "ITCKabelStd-Bold", size: fontSize)!
        return font
    }
    class func textDemiFont(fontSize: CGFloat) -> UIFont {
        let font = UIFont(name: "ITCKabelStd-Demi", size: fontSize)!
        return font
    }
}




