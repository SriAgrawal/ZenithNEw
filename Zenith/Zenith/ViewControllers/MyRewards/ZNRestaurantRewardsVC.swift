//
//  ZNRestaurantRewardsVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 13/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRestaurantRewardsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{


    
    var storeObj = ZNStoreInfo()
    var rewardsArray = [ZNRetailersInfo]()
    var couponArray = [ZNProductInfo]()
    var rewardNumArray = [String]()

    @IBOutlet var restaurantContainerView: UIView!
    @IBOutlet var restaurantTableView: UITableView!
    @IBOutlet var restaurantStamp: UIButton!
    @IBOutlet var restaurantCoupons: UIButton!
    @IBOutlet var restaurantPoint: UIButton!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var emptyLabel: UILabel!
    
    
    private let refreshControl = UIRefreshControl()
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var pageNumber = NSInteger()
    var rewardType = String()
    var storeId = String()
    var addressId = String()
    var storeImage = String()

    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pagination.current_page = "1"
        self.addRefreshController()
        rewardType = "1"
        self.callApiMethodToGetOfferList(pageNumber:pagination.current_page, rewardType: rewardType)
        customInit();
    }
    
    func customInit()   {
        self.restaurantTableView.tableFooterView = UIView(frame: CGRect.zero)
        restaurantImageView.sd_setImage(with: URL(string: self.storeImage), placeholderImage: UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
        //Setting Shadow of the View
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset =  CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 5
        
        //Set exclusive touch
        restaurantPoint.isExclusiveTouch = true
        restaurantCoupons.isExclusiveTouch = true
        restaurantStamp.isExclusiveTouch = true
        
        self.restaurantTableView.register(UINib(nibName: "ZNStampsTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNStampsTableViewCell")
         self.restaurantTableView.register(UINib(nibName: "ZNMyCouponsTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNMyCouponsTableViewCell")
        
        self.restaurantTableView.estimatedRowHeight = 110
        self.restaurantTableView.rowHeight = UITableViewAutomaticDimension
   
    }
    
    //MARK: - Refresh Controller
    func addRefreshController(){
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.restaurantTableView.refreshControl = refreshControl
        } else {
            self.restaurantTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControll:)), for: .valueChanged)
    }
    
    //Refresh Controller Handller
    func handleRefresh(refreshControll : UIRefreshControl){
        loadExecute = true
        self.refreshControl.endRefreshing()
        pagination.current_page = "1"
        if rewardType == "3" {
             self.callApiMethodToCouponList(pageNumber:pagination.current_page)
        }
        else if rewardType == "2"{
            
        self.callApiMethodToGetStampList(pageNumber:pagination.current_page, rewardType: rewardType)
        }
        else{
            self.callApiMethodToGetOfferList(pageNumber:pagination.current_page, rewardType: rewardType)
        }
    }
    
    //MARK: - TableViewDataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if UIScreen.main.bounds.width == 320 {
            self.restaurantPoint.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.restaurantStamp.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.restaurantCoupons.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
        }
        
        if rewardType == "3" {
         
            var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNMyCouponsTableViewCell", for: indexPath) as? ZNMyCouponsTableViewCell
            
            if cell1 == nil {
                cell1 = ZNMyCouponsTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNMyCouponsTableViewCell")
            }
            if UIScreen.main.bounds.width == 320 {
                cell1?.imagetrailingConstraint.constant = 13
            }
            
            cell1?.selectionStyle = .none
            let couponInfo = couponArray[indexPath.row]
            cell1?.productPrice?.text =  couponInfo.couponCode
            cell1?.productBrand?.text =  couponInfo.productName
            cell1?.couponValidDate?.text =  couponInfo.productEndDate
            cell1?.myCouponImageView.sd_setImage(with: URL(string: couponInfo.couponImage ), placeholderImage: UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
            return cell1!
            
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "ZNStampsTableViewCell", for: indexPath) as? ZNStampsTableViewCell
            
            restaurantTableView.allowsSelection = true
            
            if cell == nil {
                cell = ZNStampsTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStampsTableViewCell")
            }
            cell?.selectionStyle = .none
            let obj = rewardsArray[indexPath.row]

            if rewardType == "1" {
                cell?.itemNameLabel.text = obj.retailerName
                cell?.itemImageView.sd_setImage(with: URL(string:obj.retailerImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
                cell?.stampPointLabel.text = obj.retailerPoints
                cell?.stampTitleLabel.text = "Ponit"
            }
            else{
                cell?.itemNameLabel.text = obj.retailerName
                cell?.itemImageView.sd_setImage(with: URL(string:obj.retailerImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
                cell?.stampPointLabel.text = obj.stamp
                cell?.stampTitleLabel.text = "Stamp"
            }
            return cell!
        }
    }
    
    //MARK: - TableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if rewardType == "3" {
            let couponObj = couponArray[indexPath.row]
            let vcObj = ZNCouponsDetailVC()
            vcObj.couponInfo = couponObj
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    //Mark: - Scroll View Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset <= 10.0) {
            if (pagination.current_page  < pagination.total_page && loadExecute){
                loadExecute = false
                let stringNumber = pagination.current_page
                let numberFromString = Int(stringNumber)!+1
                let x : Int = numberFromString
                let myString = String(x)
                if rewardType == "3" {
                    self.callApiMethodToCouponList(pageNumber: pagination.current_page)
                }
                else if rewardType == "2"{
                self.callApiMethodToGetStampList(pageNumber:myString, rewardType: rewardType)
                }
                else{
                self.callApiMethodToGetOfferList(pageNumber:myString, rewardType: rewardType)
                }
            }
        }
    }
    
    //Mark: - UIButton Action Mathods
    @IBAction func pointButtonAction(_ sender: UIButton) {
        self.restaurantPoint.setTitleColor(.white, for: .normal)
        self.restaurantPoint.setImage(UIImage(named: "point_s.png"), for: .normal)
        self.restaurantPoint.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        self.restaurantCoupons.setTitleColor(.darkGray , for: .normal )
        self.restaurantCoupons.setImage(UIImage(named: "coupan"), for: .normal)
        self.restaurantCoupons.backgroundColor = UIColor .white
        self.restaurantStamp.setTitleColor(.darkGray , for: .normal )
        self.restaurantStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.restaurantStamp.backgroundColor = UIColor .white
        rewardType = "1"
        self.callApiMethodToGetOfferList(pageNumber:pagination.current_page, rewardType:rewardType)
    }
    
    @IBAction func couponsButtonAction(_ sender: UIButton) {
        self.restaurantPoint.setTitleColor(.darkGray, for: .normal)
        self.restaurantPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.restaurantPoint.backgroundColor = UIColor.white
        
        self.restaurantCoupons.setTitleColor(.white , for: .normal )
        self.restaurantCoupons.setImage(UIImage(named: "coupan_s.png"), for: .normal)
        self.restaurantCoupons.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        self.restaurantStamp.setTitleColor(.darkGray , for: .normal )
        self.restaurantStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.restaurantStamp.backgroundColor = UIColor .white
        rewardType = "3"
        self.callApiMethodToCouponList(pageNumber: pagination.current_page)
    }
    @IBAction func stampButtonAction(_ sender: UIButton) {
        self.restaurantPoint.setTitleColor(.darkGray, for: .normal)
        self.restaurantPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.restaurantPoint.backgroundColor = UIColor.white
        
        self.restaurantCoupons.setTitleColor(.darkGray , for: .normal )
        self.restaurantCoupons.setImage(UIImage(named: "coupan"), for: .normal)
        self.restaurantCoupons.backgroundColor = UIColor .white
        
        self.restaurantStamp.setTitleColor(.white , for: .normal )
        self.restaurantStamp.setImage(UIImage(named: "stamp_s.png"), for: .normal)
        self.restaurantStamp.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        rewardType = "2"
        self.callApiMethodToGetStampList(pageNumber:pagination.current_page, rewardType:rewardType)
    }
    
    @IBAction func backButtonaction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - WebApi Method
    
    func callApiMethodToGetOfferList(pageNumber : String, rewardType: String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = self.storeId
        paramDict[KAddress_Id] = self.addressId
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: (rewardType == "1" ? KMyStore_Point : KMyStore_Stamp)) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.rewardsArray.removeAll()
                    }
                    if let dict = response.object(forKey: "category_list") as? NSArray{
                    if(dict.count == 0){
                        self.rewardsArray.removeAll()
                        if rewardType == "1"
                        {
                            self.emptyLabel.isHidden = false
                           self.emptyLabel.text = "No Points available."
                        }
                        else{
                            self.emptyLabel.isHidden = false
                             self.emptyLabel.text = "No Stamps available."
                        }
                    }
                    else{
                        self.emptyLabel.isHidden = true
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            
                            self.rewardsArray.append(ZNRetailersInfo .getMypoints(responseDict:rowItem as Dictionary<String, AnyObject>))
                        }
                    }
                }
                    self.restaurantTableView.reloadData()
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
    
    func callApiMethodToGetStampList(pageNumber : String, rewardType: String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = self.storeId
        paramDict[KAddress_Id] = self.addressId
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName:KMyStore_Stamp) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.rewardsArray.removeAll()
                    }
                    if let dict = response.object(forKey: "stamps_list") as? NSArray{
                        if(dict.count == 0){
                            self.rewardsArray.removeAll()
                                self.emptyLabel.isHidden = false
                                self.emptyLabel.text = "No Stamps available."
                        }
                        else{
                            self.emptyLabel.isHidden = true
                            for rowItem in dict as! Array<Dictionary<String,Any>>{
                                self.rewardsArray.append(ZNRetailersInfo .getMypoints(responseDict:rowItem as Dictionary<String, AnyObject>))
                            }
                        }
                    }
                    self.restaurantTableView.reloadData()
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
    
    
    func callApiMethodToCouponList(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KStore_Id] = self.storeId
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "store_coupon") { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.couponArray.removeAll()
                    }
                    if let dict = response.object(forKey: "coupon_list") as? NSArray {
                        
                        if(dict.count == 0){
                            self.couponArray.removeAll()
                            self.emptyLabel.isHidden = false
                            self.emptyLabel.text = "No Coupons available."
                        }
                        else{
                            self.emptyLabel.isHidden = true
                            for rowItem in dict as! Array<Dictionary<String,Any>>{
                                self.couponArray.append(ZNProductInfo .getOffersList(responseDic:rowItem as Dictionary<String, AnyObject>))
                            }
                        }
                    }
                        self.restaurantTableView.reloadData()
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

    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
