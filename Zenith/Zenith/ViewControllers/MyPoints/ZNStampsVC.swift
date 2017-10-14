//
//  ZNStampsVC.swift
//  Zenith
//
//  Created by Anjali on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNStampsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var emptyTableLabel: UILabel!
    @IBOutlet var tableViewStamps: UITableView!
    @IBOutlet var footerView: UIView!
    
    
    var dataSourceArray = [Any]()
    
    var pagNo : String = "1"
    var pageSize : String = "10"
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var totalPoints : String = ""

    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.emptyTableLabel.isHidden = true
        pagination.current_page = "1"
        callApiMethodToGetStamp(pageNumber: pagination.current_page)
        
        
    }
    
    
    
    //MARK:- Helper Method
    func customInit()  {
        
        self.tableViewStamps.tableFooterView = self.footerView
        self.tableViewStamps.register(UINib(nibName: "ZNStampsTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNStampsTableViewCell")
    }
    
       //MARK: - Tableview Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNStampsTableViewCell") as! ZNStampsTableViewCell
        
        
        let dataDict:ZNRetailersInfo = (self.dataSourceArray[indexPath.row]as! ZNRetailersInfo)
        cell.itemNameLabel.text = dataDict.retailerName
        //cell1?.retailersImageView.image=UIImage(named: dataDict.value(forKey: retailerImage)as! String)
        cell.itemImageView.sd_setImage(with: URL(string:dataDict.retailerImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
        cell.stampPointLabel.text = dataDict.stamp
      return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //TODO
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
                var myString = String(x)
                self.callApiMethodToGetStamp(pageNumber:myString)
                
            }
        }
    }
    
    
    func callApiMethodToGetStamp(pageNumber:String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "10"
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KMyStamp) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    
                    self.totalPoints  = response.validatedValue("total_points", expected: "" as AnyObject) as! String
                    
                    if self.pagination.current_page == "1" {
                        self.dataSourceArray.removeAll()
                    }
                    
                    
                    if let dict = response.object(forKey: "stamps_list") as? NSArray {
                        
                        if(dict.count == 0){
                            self.emptyTableLabel.isHidden = false
                        }
                        else{
                            self.emptyTableLabel.isHidden = true
                            for rowItem in dict as! Array<Dictionary<String,Any>>{
                                
                                self.dataSourceArray += [ZNRetailersInfo .getStamp(responseDict:rowItem as Dictionary<String, AnyObject>)]
                            }
                        }
                        self.loadExecute = true
                    }
                    self.tableViewStamps.reloadData()
                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                    self.tableViewStamps.reloadData()
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
