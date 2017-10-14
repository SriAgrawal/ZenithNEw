//
//  ZNStoreListVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNStoreListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var storeInfo = ZNStoreInfo()
    var storeID = NSString()
    
    //Array declaration and definition
    var storeNameArray = NSMutableArray(array: ["Vmart 1", "Vmart 2", "Vmart 3", "Vmart 4", "Vmart 5"])
    var storeAddressArray = NSMutableArray(array: ["Okhla phase 1,Delhi", "Malad Sector 5,Mumbai", "Okhla phase 1,Delhi", "Okhla phase 2,Delhi", "Okhla phase 1,Delhi"])
    var storeImageArray = NSMutableArray(array: ["Vmart1", "Vmart1", "Vmart1", "Vmart1", "Vmart1"])
    var storeDistanceArray = NSMutableArray(array: ["0.5m", "0.5m", "0.5m", "0.5m", "0.5m"])
    
    @IBOutlet weak var storeListTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    //MARK: - viewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.navigationController?.isNavigationBarHidden = true
        pointsLabel.text = storeInfo.storePoint
        storeListTableView.allowsSelection = true
        self.storeListTableView.register(UINib(nibName: "ZNStoreListTableViewCell", bundle: nil),forCellReuseIdentifier: "ZNStoreListTableViewCell" )
        storeListTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    //MARK: - UITableView DataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return storeNameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNStoreListTableViewCell") as? ZNStoreListTableViewCell
        
        if cell1 == nil {
            cell1 = ZNStoreListTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreListTableViewCell")
        }
        
        if UIScreen.main.bounds.width == 320 {
            cell1?.storeNameLabel.font = cell1?.storeNameLabel.font.withSize(15)
            cell1?.storeAddressLabel.font = cell1?.storeAddressLabel.font.withSize(14)
            cell1?.arrowTrailingConstraint.constant = 6
        }
        
        storeInfo.storeName = storeNameArray.object(at: indexPath.row) as! String
        storeInfo.storeAddress = storeAddressArray.object(at: indexPath.row) as! String
        storeInfo.storeDistance = storeDistanceArray.object(at: indexPath.row) as! String
        storeInfo.storeImage = storeImageArray.object(at: indexPath.row) as! String
        
        cell1?.selectionStyle = .none
        cell1?.storeNameLabel?.text = storeInfo.storeName
        cell1?.storeAddressLabel?.text = storeInfo.storeAddress
        cell1?.storeDistanceLabel?.text = storeInfo.storeDistance
        cell1?.storeListImageView.image = UIImage(named: storeInfo.storeImage)
        return cell1!
    }
    
    //MARK: UITableView Delegate Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 114.0;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        self.storeInfo.storeId = self.storeID as String
        let vcObj = ZNRestaurantDetailVC()
        vcObj.restaurantInfo = self.storeInfo;
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
