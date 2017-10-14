//
//  ZNRestaurantVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRestaurantVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var storeInfo = ZNStoreInfo()
    var nameArray = NSMutableArray(array:["Khana Khazana", "Delhi Street", "Bebooz", "Clork in", "Chowdary"])
    var addressArray = NSMutableArray(array:["Okhla Phase 1, Delhi", "Malad sector 5, Mumbai", "Okhla phase 1,Delhi", "Okhla phase 2,Delhi", "Okhla phase 1,Delhi"])
    var distanceArray = NSMutableArray(array:["0.5m", "1.5m", "2.5m", "3.5m", "4.0m"])
    var imageArray = NSMutableArray(array:["khanaKhazana", "restaurant", "burgur_Icon", "khanaKhazana", "chinese_Thali"])
    
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    
    //MARK:- UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        
        self.navigationController?.isNavigationBarHidden = true
        restaurantTableView.allowsSelection = true
        pointLabel.text = storeInfo.storePoint
        
        //register cell
        self.restaurantTableView.register(UINib(nibName: "ZNRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNRestaurantTableViewCell")
       }
    
    //MARK: - UITableViewDataSource and Delegate Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 : ZNRestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZNRestaurantTableViewCell", for: indexPath) as! ZNRestaurantTableViewCell
        
        cell1.selectionStyle = .none
        
        storeInfo.storeName = nameArray.object (at: indexPath.row) as! String
        storeInfo.storeImage = imageArray.object(at: indexPath.row) as! String
        storeInfo.storeAddress = addressArray.object(at: indexPath.row) as! String
        storeInfo.storeDistance = distanceArray.object(at: indexPath.row) as! String
        
        cell1.RestaurantNameLabel.text = storeInfo.storeName
        cell1.restaurantAddressLabel.text = storeInfo.storeAddress
        cell1.restaurantDistanceLabel.text = storeInfo.storeDistance
        cell1.restaurantImageView.image = UIImage(named: storeInfo.storeImage)
        
        if UIScreen.main.bounds.width == 320 {
            cell1.RestaurantNameLabel.font = cell1.RestaurantNameLabel.font.withSize(15)
            cell1.restaurantAddressLabel.font = cell1.restaurantAddressLabel.font.withSize(14)
            cell1.restaurantDistanceLabel.font = cell1.restaurantDistanceLabel.font.withSize(14)
            cell1.arrowTrailingConstraint.constant = 4
        }
        return cell1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcObj = ZNRestaurantDetailVC()
        vcObj.restaurantInfo = self.storeInfo
        self.navigationController?.pushViewController(vcObj, animated: true)
    }

    //MARK: - UIButtonAction Method
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
