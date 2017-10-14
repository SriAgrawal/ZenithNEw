//
//  ZNRetailersSettingVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRetailersSettingVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private var retailerName: String = "retailerName"
    private var retailerImage: String = "retailerImage"
    @IBOutlet weak var retailersTableView: UITableView!
    @IBOutlet weak var emptylabel: UILabel!
    var dataSourceArray = [Any]()
    
    var retailerInfo = ZNRetailersInfo()
    var pagNo : String = "1"
    var pageSize : String = "10"
    var pagination = ZNPagination()
    var loadExecute = Bool()
    
    //MARK: - UIView LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.navigationController?.isNavigationBarHidden = true
        self.retailersTableView.allowsSelection = false
        self.retailersTableView.register(UINib(nibName: "ZNRetailersSettingTableViewCell", bundle: nil),forCellReuseIdentifier:"ZNRetailersSettingTableViewCell")
        self.retailersTableView.tableFooterView = UIView(frame: CGRect.zero)

        callApiMethodToGetRetailer(pageNumber: pagNo)
    }
    
    //MARK: - UITableView DataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSourceArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNRetailersSettingTableViewCell")as? ZNRetailersSettingTableViewCell
        
        if cell1 == nil{
            cell1 = ZNRetailersSettingTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNRetailersSettingTableViewCell")
        }
        
        let dataDict:ZNRetailersInfo = (self.dataSourceArray[indexPath.row]as! ZNRetailersInfo)
        cell1?.retailersLabel.text = dataDict.retailerName

        cell1?.retailersImageView.sd_setImage(with: URL(string:dataDict.retailerImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
        
        if dataDict.retailerNotificationStatus == "1" {
            cell1?.switchIndicator .setOn(true, animated: true)
        } else{
            cell1?.switchIndicator .setOn(false, animated: true)
        }
        
        cell1?.switchIndicator.tag = indexPath.row+1000
        
        cell1?.switchIndicator .addTarget(self, action:#selector(switchButtonAction), for: .valueChanged)
        
        
        
        return cell1!
    }
    
    //MARK: - UITableView Delegate Method
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 121.0
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func switchButtonAction(mySwitch: UISwitch) -> Void {
        self.view .endEditing(true)
        
        let dataDict:ZNRetailersInfo = (self.dataSourceArray[mySwitch.tag - 1000] as! ZNRetailersInfo)

        if dataDict.retailerNotificationStatus == "1" {
            dataDict.retailerNotificationStatus = "0"
        }else {
            dataDict.retailerNotificationStatus = "1"
        }
        
        self .callApiMethodToUpdateRetailerSetting(objData: dataDict)
      //  self.retailersTableView .reloadData()
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset <= 10.0) {
            if (self.pagination.current_page < self.pagination.max_page && loadExecute){
                loadExecute = false
                
                let stringNumber = pagination.current_page
                let numberFromString = Int(stringNumber)!+1
                let x : Int = numberFromString
                let myString = String(x)
                self.callApiMethodToGetRetailer(pageNumber:myString)

            }
        }
    }
    
    
    func callApiMethodToGetRetailer(pageNumber:String) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "10"

        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: Kretailer_details) { (result :AnyObject?, error :NSError?) in
            
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)

                 
                    if let dict = response.object(forKey: "retailer_setting") as? NSArray {
                       
                        if dict.count == 0 {
                            self.emptylabel.isHidden = false
                        }
                    else{
                            self.emptylabel.isHidden = true
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            self.dataSourceArray += [ZNRetailersInfo .getRetailerDetail(responseDict:rowItem as Dictionary<String, AnyObject>)]
                                }
                        }
                        self.loadExecute = true
                    }
                    self.retailersTableView.reloadData()
                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                    self.retailersTableView.reloadData()
                }
            }
            else {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }
    
    
    
    func callApiMethodToUpdateRetailerSetting(objData:ZNRetailersInfo) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KnotificationSetting] = objData.retailerNotificationStatus
        paramDict[KStore_Id] = objData.retailerID
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: Kretailer_notificationStatus) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    self.retailersTableView.reloadData()
                }
                else {
                    self.retailersTableView.reloadData()
                }
            }
            else {
               _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }

    
    
    
    
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
