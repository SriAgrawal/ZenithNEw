//
//  ZNHomeModelClass.swift
//  Zenith
//
//  Created by Anjali on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNHomeModelClass: NSObject {
    
    var category_name = ""
    var cover_image = ""
    var icon_image = ""
    var category_id = ""
    var category_type = ""
    var merchant_id = ""
    var address_id = ""
    var address = ""
    var city = ""
    var state = ""
    var country = ""
    var zip = ""
    var latitude = ""
    var longitude = ""
    var distance : Float = 0.0
    var searchText = ""

    var store_name = ""
    var store_id = ""
    var email = ""
    var mobile = ""
    var book_appointment = ""
    var book_table = ""
    var order_take_away = ""
    var beaconArray = [ZNHomeModelClass]()
    var beacon_minnor : Int = 0
    var beacon_major : Int = 0
    var beacon_uid = ""
    var beacon_time : Double = 0
}
