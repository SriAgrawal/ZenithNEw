//
//  ZNChangeRetailerVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNChangeRetailerVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var   selectedIndex = NSIndexPath()
    var retailerInfo = ZNRetailersInfo()
    var dataSourceArray = [Any]()
    var retailerArray = [Any]()
    var retailerName :String = "retailerName"
    var retailerImage : String = "retailerImage"
    var cell1 = ZNRetailersSettingTableViewCell()
    
    @IBOutlet weak var changeRetailerTableView: UITableView!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    
    //MARK: - Helper Method
    func initialMethod()  {
        self.changeRetailerTableView.allowsSelection = false
        self.changeRetailerTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.changeRetailerTableView.register(UINib(nibName: "ZNRetailersSettingTableViewCell", bundle: nil),forCellReuseIdentifier : "ZNRetailersSettingTableViewCell")
        
        dataSourceArray = [
            [retailerName: "vmart", retailerImage:"images-6"],
            [retailerName: "Restaurent", retailerImage:"images-6"],
            [retailerName: "Nike", retailerImage:"images-6"]
        ]
    }
    
    func radioBtnAction() {
     
    }
    
    //MARK: - UITableView DataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSourceArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNRetailersSettingTableViewCell")as? ZNRetailersSettingTableViewCell
        cell1?.switchIndicator.isHidden=true
        cell1?.retailersRadioButton.tag = 100
        
        if cell1==nil{
            cell1=ZNRetailersSettingTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNRetailersSettingTableViewCell")
        }
        cell1?.retailersRadioButton .addTarget(self, action:#selector(radioBtnAction), for:.touchUpInside)
        
        let dataDict:NSDictionary = (dataSourceArray[indexPath.row]as! NSDictionary)
        cell1?.retailersLabel.text=dataDict.value(forKey: retailerName)as?String
        cell1?.retailersImageView.image=UIImage(named: dataDict.value(forKey: retailerImage)as! String)
        return cell1!
    }
    
    //MARK: - UITableView Delegate Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    //MARK: - UIButton Action Method
    @IBAction func doneButtonAction(_ sender: Any) {
        let VcObj = ZNProductListVC()
        self.navigationController?.pushViewController(VcObj, animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
