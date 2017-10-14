//
//  ZNMyCouponsVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNMyCouponsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var couponArray = [ZNProductInfo]()
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var pageNumber = NSInteger()
   
    
     @IBOutlet weak var myCouponsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyLabel.isHidden = true
        pagination.current_page = "1"
        self.addRefreshController()
        self.callApiMethodToCouponList(pageNumber: "1")
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.myCouponsTableView.register(UINib(nibName: "ZNMyCouponsTableViewCell", bundle: nil),forCellReuseIdentifier : "ZNMyCouponsTableViewCell")
        
    }
    
    //MARK: - Refresh Controller
    func addRefreshController(){
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.myCouponsTableView.refreshControl = refreshControl
        } else {
            self.myCouponsTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControll:)), for: .valueChanged)
    }
    
    //Refresh Controller Handller
    func handleRefresh(refreshControll : UIRefreshControl){
        loadExecute = true
        self.refreshControl.endRefreshing()
        pagination.current_page = "1"
        self.callApiMethodToCouponList(pageNumber:pagination.current_page)
    }
    
    //MARK: - UITableView DataSource and Delegate Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return couponArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNMyCouponsTableViewCell") as? ZNMyCouponsTableViewCell
        
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 114.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let couponObj = couponArray[indexPath.row]
        let vcObj = ZNCouponsDetailVC()
        vcObj.couponInfo = couponObj
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    //MARK: - UIButton Action Method
    @IBAction func menuBtnActin(_ sender: UIButton) {
        self.toggleSlider()
    }
    
    //MARK: - WebApi Method
    func callApiMethodToCouponList(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "my_coupan") { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.couponArray.removeAll()
                    }
                    if let dict = response.object(forKey: "coupon_list") as? NSArray {
                        
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            self.couponArray.append(ZNProductInfo .getStoreOfferDetail(responseDict:rowItem as Dictionary<String, AnyObject>))
                        }
                    }
                    if(self.couponArray.count == 0){
                         self.emptyLabel.isHidden = false
                    }
                    else{
                        self.myCouponsTableView.reloadData()
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
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
