//
//  ZNStoreListVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNStoreListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    private var storeName: String = "storeName"
    private var storeAddress: String = "storeAddress"
    private var storeTime: String = "storeTime"
    private var storeImage: String = "storeImage"


    
    
    
    @IBOutlet weak var storeListTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var dataSourceArray = [Any]()

  //  @IBOutlet var dataSourceArray: NSArray?
    
    
    var storeInfo = ZNStoreInfo()
    
    //MARK: - viewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
       self.initialMethod()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - helperMethod
    func initialMethod()
    {
     self.storeListTableView.tableHeaderView = headerView
    self.storeListTableView.allowsSelection =  false
        self.storeListTableView.register(UINib(nibName: "ZNStoreListTableViewCell", bundle: nil),forCellReuseIdentifier: "ZNStoreListTableViewCell" )
        storeListTableView.tableFooterView = UIView(frame: CGRect.zero)

    self.dataSourceArray = [
    [storeName : "vmart1", storeAddress: "Okhla phase 1,Delhi", storeTime: "0.5m",storeImage: "images-6"],
        [storeName : "vmart2", storeAddress: "Malad Sector 5,Mumbai", storeTime: "1.5m",
         storeImage: "images-6"],
        [storeName : "vmart3", storeAddress: "Okhla phase 1,Delhi", storeTime: "2.5m", storeImage: "images-6"],
        [storeName : "vmart4", storeAddress: "Okhla phase 2,Delhi", storeTime: "3.5m", storeImage: "images-6"],
        [storeName : "vmart5", storeAddress: "Okhla phase 1,Delhi", storeTime: "4.0m",storeImage: "images-6"]

        ]
    
    
    
    }

    
    
    
    //MARK: - tableViewDataSource method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSourceArray.count
    }

 public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
 {
 var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNStoreListTableViewCell") as? ZNStoreListTableViewCell
   
  cell1?.quantityLabel.isHidden = true
    if cell1 == nil {
      cell1 = ZNStoreListTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreListTableViewCell")
    }
    
    let dataDict: NSDictionary = (dataSourceArray[indexPath.row] as! NSDictionary )
   
    cell1?.storeNameLabel.text=storeInfo.storeName
    cell1?.storeAddressLabel.text=storeInfo.storeAddress
    cell1?.storeTimeLabel.text=storeInfo.storeTime
    cell1?.storeNameLabel?.text = (dataDict.value(forKey: storeName) as! String)
    cell1?.storeAddressLabel?.text = (dataDict.value(forKey: storeAddress) as! String)
    cell1?.storeTimeLabel?.text = (dataDict.value(forKey: storeTime) as! String)
    cell1?.storeListImageView.image = UIImage(named: dataDict.value(forKey: storeImage) as! String)


    
    cell1?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    
    return cell1!
   
    }
    
  
  
    //MARK: tableViewDelegate method

     public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75;
    }
    @IBAction func backButtonAction(_ sender: Any) {
   self.navigationController?.popViewController(animated: true)
    }
}
