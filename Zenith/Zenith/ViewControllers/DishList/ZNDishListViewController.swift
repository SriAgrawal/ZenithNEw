
//
//  ZNDishListViewController.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNDishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var earnPointlabel: UILabel!
    
    var menuImageArray = Array<String>()
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var dataSourceArray = [Any]()
    var menuOrderArray = [Any]()


    var storeId :String = ""
    var currencySymbol :String = ""
    var taxPrice :Float = 0
    
    
    //MRK: - ViewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    //MARK: - helperMethod
    func initialMethod()
    {
         self.menuTableView.register(UINib(nibName: "ZNSettingTableViewCell", bundle: nil),forCellReuseIdentifier: "ZNSettingTableViewCell" )
//        menuArray = ["Starters","Main Course","Dessert","Drinks","Snacks"]
         menuImageArray = ["starter","MainCourse","dessert","drinks","snacks"]
        self.menuTableView.tableFooterView = self.footerView
        pagination.current_page = "1"

         self.callApiMethodToGetCategory(withStoreId: self.storeId as NSString, pageNumber:pagination.current_page )
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var menuCell = tableView.dequeueReusableCell(withIdentifier: "ZNSettingTableViewCell") as? ZNSettingTableViewCell
        
        if menuCell == nil {
            menuCell = ZNSettingTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNSettingTableViewCell")
        }
        
        let dataDict:ZNCategoryInfo = (self.dataSourceArray[indexPath.row]as! ZNCategoryInfo)
        menuCell?.contentLabel.text = dataDict.name
        if dataDict.type == "starters" {
            menuCell?.settingImageView.image =  UIImage (named: "starter")

        }else if dataDict.type == "main_course"{
            menuCell?.settingImageView.image =  UIImage (named: "MainCourse")

            
        }else if dataDict.type == "dessert"{
            menuCell?.settingImageView.image =  UIImage (named: "dessert")

        }
        else if dataDict.type == "drinks"{
            menuCell?.settingImageView.image =  UIImage (named: "drinks")

        }else if dataDict.type == "snacks"{
            menuCell?.settingImageView.image =  UIImage (named: "snacks")

        } else{
            menuCell?.settingImageView.image =  UIImage (named: "snacks")

        }
        
        
        menuTableView.allowsSelection = true
        menuCell?.selectionStyle = .none

        return menuCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataDict:ZNCategoryInfo = (self.dataSourceArray[indexPath.row]as! ZNCategoryInfo)

        let vcObj = ZNDishItemListViewController()
        vcObj.navString = dataDict.name as NSString
        vcObj.currencySymbol = self.currencySymbol
        vcObj.earnPoints = self.earnPointlabel.text! as NSString
        vcObj.dataSourceArray = dataDict.dishArray as! NSMutableArray
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    

    //MARK: - UIButtonAction
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.menuOrderArray .removeAll();
        
        

        for rowItem in self.dataSourceArray as! Array<ZNCategoryInfo>{
            
            var objOder = ZNCategoryInfo()
            var categoryTotal = Float()
            var menuName = Array<String>()

            for orderDat in rowItem.dishArray as! Array<ZNDishInfo>{
                
                
                if orderDat.isSelected {
                    var objDishOder = ZNDishInfo()
                    var menuArray = Array<String>()

                    objDishOder.dishID = orderDat.dishID;
                    objDishOder.dishTotalCount = orderDat.dishTotalCount
                    objDishOder.dishCount = orderDat.dishCount;
                    objDishOder.dishPrice = orderDat.dishPrice
                    objDishOder.currencySymbol = self.currencySymbol
                    objDishOder.dishImage = orderDat.dishImage;
                    objDishOder.dishDescription = orderDat.dishDescription
                    objDishOder.specialIngrediant = orderDat.specialIngrediant
                    objDishOder.dishName = orderDat.dishName
                    objOder.dishArray .append(objDishOder)
                    
                    var str = String()
                    
                    str = String (format: "%@ %@", String(objDishOder.dishCount),objDishOder.dishName)
                    
                    
                    menuName.append(str)
                    categoryTotal += objDishOder.dishTotalCount
                }
            }
            
            if objOder.dishArray.count > 0 {
                objOder.name = rowItem.name;
                objOder.categoryID = rowItem.categoryID
                objOder.totalPrice = categoryTotal
                objOder.currencySymbol = self.currencySymbol
                objOder.type = rowItem.type
                objOder.totalDish = menuName.joined(separator: ", ")
                self.menuOrderArray .append(objOder)

            }
            
        }
        if menuOrderArray.count == 0 {
            _ = AlertController.alert("", message: "Please select any one item for order.")
        }
        else{
            let vcObj = ZNOrderListVC()
            vcObj.currencySymbol = self.currencySymbol
            vcObj.taxPrice =  self.taxPrice
            vcObj.dataSourceArray = self.menuOrderArray as! NSMutableArray;
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    //MARK: - UIScrollView Delegate

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
                self.callApiMethodToGetCategory(withStoreId:storeId as NSString, pageNumber:myString)
                
            }
        }
    }

    
    
    
    func callApiMethodToGetCategory(withStoreId:NSString, pageNumber:String) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KStore_Id] = withStoreId
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "10"

        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KCategoryMenuList) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.earnPointlabel.text = (response.validatedValue("total_points", expected: "" as AnyObject) as! String)
                  self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    
                      self.dataSourceArray.removeAll()
                    
                    self.currencySymbol = response.validatedValue("currency_symbol", expected: "" as AnyObject) as! String
                   
                    self.taxPrice = response.validatedValue("tax", expected: 0 as AnyObject) as! Float
                
                    
                    if let dictNew = response.object(forKey: "product_list") as? NSArray {
                        
                        for rowItem in dictNew as! Array<Dictionary<String,Any>>{
                            
                            self.dataSourceArray += [ZNCategoryInfo .parsePageCategoryData(dict: rowItem as Dictionary<String, AnyObject>)]

                            
                        }
                    }
                    if (self.dataSourceArray.count == 0) {
                        _ = AlertController.alert("", message:"There is no menu list.")
                    }
                    else{
                        self.menuTableView.reloadData()
                    }
                }
                else {
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: - Memory Management

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
