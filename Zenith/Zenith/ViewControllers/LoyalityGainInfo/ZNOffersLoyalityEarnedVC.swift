//
//  ZNOffersLoyalityEarnedVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNOffersLoyalityEarnedVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var offerInfo = ZNProductInfo()
    var isFrom : Bool?
    
    private var offersEarn : String = ""
    private var offersName : String = ""
    private var offersPrice : String = ""
    private var offersDiscount : String = ""
    private var offersImage: String = ""
    var storeId = String()
    @IBOutlet weak var offerUpperConstraint: NSLayoutConstraint!
    @IBOutlet weak var loyalPointView: UIView!
    var offersLoyaltyArray = [Any]()
    
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var earnedPointLabel: UILabel!
    @IBOutlet var offersTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    private let refreshControl = UIRefreshControl()
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var pageNumber = NSInteger()
    
    //MARK: - ViewLifeCycleMethod
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyLabel.isHidden = true
        pagination.current_page = "1"
        self.addRefreshController()
        self.customInit()
        
    }
    
    func customInit()
    {
        self.offersTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.offersTableView.register(UINib(nibName: "ZNOffersTableViewCell", bundle: nil),forCellReuseIdentifier: "ZNOffersTableViewCell")
        if isFrom == true {
            self.offerUpperConstraint.constant = 80
            self.loyalPointView.isHidden = true
            backBtn.setImage(UIImage(named: "menu"), for: .normal)
            self.callApiMethodToGetOfferList(pageNumber:pagination.current_page)
        }
        else {
            self.offerUpperConstraint.constant = 250
            self.loyalPointView.isHidden = false
            backBtn.setImage(UIImage(named: "backIcon"), for: .normal)
            self.callApiMethodToGetOfferListForStore(pageNumber:pagination.current_page)
        }
    }
    //MARK: - Refresh Controller
    func addRefreshController(){
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.offersTableView.refreshControl = refreshControl
        } else {
            self.offersTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControll:)), for: .valueChanged)
    }
    
    //Refresh Controller Handller
    func handleRefresh(refreshControll : UIRefreshControl){
        loadExecute = true
        self.refreshControl.endRefreshing()
        pagination.current_page = "1"
        if isFrom! {
            self.callApiMethodToGetOfferList(pageNumber:pagination.current_page)
        }
        else{
            self.callApiMethodToGetOfferListForStore(pageNumber:pagination.current_page)
        }
    }
    
    //MARK: - TableViewDataSource method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return offersLoyaltyArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNOffersTableViewCell", for: indexPath) as! ZNOffersTableViewCell

        let obj = offersLoyaltyArray[indexPath.row] as! ZNProductInfo
        cell.pointNameLabel.text = obj.productName
        cell.pointPriceLabel.text = obj.productEndDate
        cell.storeNameLabel.text = obj.storeName
        cell.storeAddressLabel.text = obj.storeAddress
        cell.pointImageView.sd_setImage(with: URL(string: obj.productImage), placeholderImage: UIImage(named: "icon_image_placeholder"), options: .highPriority)
        return cell
    }
    
    //MARK: - TableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110;
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let rowObj = offersLoyaltyArray[indexPath.row] as! ZNProductInfo
        let vcObj = ZNProductDetailVC()
        vcObj.productObj = rowObj
        self.navigationController?.pushViewController(vcObj, animated: true)

    }
    
       //MARK: -  UIButton Methods
    @IBAction func menuButtonAction(_ sender: Any) {
        if isFrom == true {
            self.toggleSlider()
        }
        else {
         self.navigationController?.popViewController(animated: true)
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
                if isFrom! {
                    self.callApiMethodToGetOfferList(pageNumber:myString)
                }
                else{
                    self.callApiMethodToGetOfferListForStore(pageNumber:myString)
                }
                
            }
        }
    }
    
    
    //MARK: - WebApi Method
    
    func callApiMethodToGetOfferList(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KLatitude] = "\(kAppDelegate.currentLatitude)"
        paramDict[KLongitude] = "\(kAppDelegate.currentLongitude)"
        paramDict[KLocation] = ""
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "6"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KOfferList) { (result :AnyObject?, error :NSError?) in
            

            if error == nil {
                    let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.offersLoyaltyArray.removeAll()
                    }
                    if let dict = response.object(forKey: "offer_list") as? NSArray {
                        
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            self.offersLoyaltyArray.append(ZNProductInfo .getOffersList(responseDic:rowItem as Dictionary<String, AnyObject>))
                        }
                    }
                    if(self.offersLoyaltyArray.count == 0){
                       self.emptyLabel.isHidden = false
                    }
                    else{
                        self.earnedPointLabel.text = response.object(forKey: "total_points") as? String
                         self.offersTableView.reloadData()
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
    
    func callApiMethodToGetOfferListForStore(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = self.storeId
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "6"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KsingleOffer) { (result :AnyObject?, error :NSError?) in
        
            if error == nil {
                
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.offersLoyaltyArray.removeAll()
                    }
                    if let dict = response.object(forKey: "offer_list") as? NSArray {
                        
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            self.offersLoyaltyArray.append(ZNProductInfo .getOffersList(responseDic:rowItem as Dictionary<String, AnyObject>))
                        }
                    }
                    if(self.offersLoyaltyArray.count == 0){
                        self.emptyLabel.isHidden = false
                    }
                    else{
                        self.earnedPointLabel.text = response.object(forKey: "total_points") as? String
                        self.offersTableView.reloadData()
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
