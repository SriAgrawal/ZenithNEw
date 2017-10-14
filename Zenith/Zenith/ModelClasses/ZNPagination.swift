//
//  ZNPagination.swift
//  Zenith
//
//  Created by Suresh patel on 23/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNPagination: NSObject {

    var count:String = "0";
    var current_page:String = "0";
    var total_page:String = "0";
    var max_page:String = "0";

    
class func parsePageDataFromDic(dict:NSDictionary) -> ZNPagination {
        
        let pageObj = ZNPagination()
        pageObj.count = dict.validatedValue(KPageSize, expected: "0" as AnyObject) as! String
        pageObj.current_page = dict.validatedValue(KPageNumber, expected: "" as AnyObject) as! String
        pageObj.total_page = dict.validatedValue(KTotalRecords, expected:"" as AnyObject) as! String
        pageObj.max_page = dict.validatedValue(KMaxPages, expected:"" as AnyObject) as! String

        return pageObj
    }
}
