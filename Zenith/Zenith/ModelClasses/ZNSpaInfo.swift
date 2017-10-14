//
//  ZNSpaInfo.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSpaInfo: NSObject {
    
    var spaName = String()
    var spaAddress = String ()
    var spaDistance = String()
    var spaImage = String()
    var spaPoints : String = "500"
    var spaNum = String()
    var spaReward = String()
    
    
    class func getSpaList(responseArray : Array<Dictionary<String, String>>) -> Array<ZNSpaInfo> {
        var SpaArray = Array<ZNSpaInfo>()
        for spaItem in responseArray {
            let spaObj = ZNSpaInfo()
            spaObj.spaName = spaItem["spaName"]!
            spaObj.spaAddress = spaItem["spaAddress"]!
            spaObj.spaDistance = spaItem["spaDistance"]!
            spaObj.spaImage = spaItem["spaImage"]!
            SpaArray.append(spaObj)
        }
        return SpaArray
    }
    
    
    class func getSpaRewardList(responseArray : Array<Dictionary<String, String>>) -> Array<ZNSpaInfo> {
        var rewardArray = Array<ZNSpaInfo>()
        for rewardItem in responseArray {
            let rewardObj = ZNSpaInfo()
            rewardObj.spaNum = rewardItem["spaNum"]!
            rewardObj.spaReward = rewardItem["spaReward"]!
            rewardArray.append(rewardObj)
        }
        return rewardArray
    }
}
