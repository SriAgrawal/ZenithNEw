//
//  ZNTodayOffersVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNTodayOffersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todaysOfferArray = [ZNProductInfo]()
    @IBOutlet var todayOffersTableView: UITableView!
    @IBOutlet var emptyTableLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    var pagination = ZNPagination()
    var loadExecute = Bool()
    var pageNumber = NSInteger()
    
    //MARK: - ViewLifeCycleMethods
    override func viewDidLoad() {
        self.emptyTableLabel.isHidden = true
        super.viewDidLoad()
        pagination.current_page = "1"
        self.addRefreshController()
        self.callApiMethodToGetOfferList(pageNumber:pagination.current_page)
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.todayOffersTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.isNavigationBarHidden = true
        self.todayOffersTableView.register(UINib(nibName: "ZNTodayOffersTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNTodayOffersTableViewCell")
        self.todayOffersTableView.register(UINib(nibName: "ZNTodayOfferHeaderCell",bundle:nil), forCellReuseIdentifier: "ZNTodayOfferHeaderCell")
        
    }
    
    //MARK: - Refresh Controller
    func addRefreshController(){
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.todayOffersTableView.refreshControl = refreshControl
        } else {
            self.todayOffersTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControll:)), for: .valueChanged)
    }
    
    //Refresh Controller Handller
    func handleRefresh(refreshControll : UIRefreshControl){
        loadExecute = true
        self.refreshControl.endRefreshing()
        pagination.current_page = "1"
        self.callApiMethodToGetOfferList(pageNumber:pagination.current_page)
    }
    
    
    //MARK: - UITableView DataSource Method
    public func numberOfSections(in tableView: UITableView) -> Int {
        return todaysOfferArray.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         let sectionObj = todaysOfferArray[section]
        return sectionObj.productArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "ZNTodayOfferHeaderCell") as? ZNTodayOfferHeaderCell
        let obj = todaysOfferArray[section]
        headerView?.retailersName.text = obj.retailersName
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZNTodayOffersTableViewCell") as? ZNTodayOffersTableViewCell
        cell?.selectionStyle = .none

        if cell == nil {
            cell = ZNTodayOffersTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNTodayOffersTableViewCell")
        }
        let sectionObj = todaysOfferArray[indexPath.section]
        let rowObj = sectionObj.productArray[indexPath.row]
        cell?.offerProductLabel?.text = rowObj.productName
        cell?.storeNameLabel.text = rowObj.storeName
        cell?.offerPriceLabel.text = rowObj.productEndDate
        cell?.storeAddressLabel.text = rowObj.storeAddress
        cell?.todayOfferImageView.sd_setImage(with: URL(string: rowObj.productImage), placeholderImage:UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
        return cell!
    }
    
    //MARK: - UITableView Delegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 113
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionObj = todaysOfferArray[indexPath.section]
        let rowObj = sectionObj.productArray[indexPath.row]
        let vcObj = ZNProductDetailVC()
        vcObj.productObj = rowObj
        self.navigationController?.pushViewController(vcObj, animated: true)
    }

    //Mark: - UIButton Action Method
    @IBAction func onMenuButtonClick(_ sender: UIButton) {
        self.toggleSlider()
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
                self.callApiMethodToGetOfferList(pageNumber:myString)
                
            }
        }
    }
    
    //MARK: - WebApi Method
    
    func callApiMethodToGetOfferList(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KLatitude] = "\(kAppDelegate.currentLatitude)"
        paramDict[KLongitude] = "\(kAppDelegate.currentLongitude)"
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KTodayOfferList) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.todaysOfferArray.removeAll()
                    }
                    if let dict = response.object(forKey: "offer_list") as? NSArray {
                        if(dict.count == 0){
                            self.emptyTableLabel.isHidden = false
                        }
                        else{
                           self.todaysOfferArray = ZNProductInfo .getTodaysOffers(responseDic:dict as! Array<Dictionary<String, Any>>)
                        }
                    }
                    self.todayOffersTableView.reloadData()
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
