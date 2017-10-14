//
//  ZNRestaurantDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import  Social
import MessageUI

class ZNRestaurantDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restaurantInfo = ZNStoreInfo()
    var storeId = NSString()
    var fromNotification = Bool()
    var addressId = String()
    var revardsArray = [String]()
    var rewardNumArray = [String]()

    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var restaurantDetailTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var spaOffer: UIButton!

    @IBOutlet weak var bookAppointmentBtn: UIButton!
    @IBOutlet weak var OfferStoreBtn: UIButton!
    @IBOutlet weak var bookTableBtn: UIButton!
    @IBOutlet weak var takeAwayOrderBtn: UIButton!
    @IBOutlet weak var offerResturantBtn: UIButton!
    
    @IBOutlet weak var twoBtnView: UIView!
    @IBOutlet weak var threeBtnView: UIView!
    @IBOutlet weak var fourBtnView: UIView!
    
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        restaurantDetailTableView.tableHeaderView = headerView
        self.restaurantDetailTableView.tableFooterView = UIView(frame: CGRect.zero)

        //Set exclusive touch
         callBtn.isExclusiveTouch = true
        mapBtn.isExclusiveTouch = true
         shareBtn.isExclusiveTouch = true
        
        self.twoBtnView.isHidden = true
        self.threeBtnView.isHidden = true
        self.fourBtnView.isHidden = true
        self.OfferStoreBtn.isHidden = true
        
        //register cell
//        self.restaurantDetailTableView.register(UINib(nibName: "ZNStoreDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
    self.restaurantDetailTableView.register(UINib(nibName:"ZNStoreUserInfoTableCell", bundle: nil), forCellReuseIdentifier: "ZNStoreUserInfoTableCell")
          self.restaurantDetailTableView.register(UINib(nibName: "ZNProductDetailDescTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNProductDetailDescTableViewCell")
        self.restaurantDetailTableView.register(UINib(nibName:"ZNJoinUsTableCell", bundle: nil), forCellReuseIdentifier: "ZNJoinUsTableCell")
        
        rewardNumArray = ["1.", "2.", "3."]
        
        self.restaurantDetailTableView.estimatedRowHeight = 100
        self.restaurantDetailTableView.rowHeight = UITableViewAutomaticDimension
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.refreshScreenWithObject), name: "refreshScreenForTheItem", object: userInfo)
        
        callApiMethodToGetStoreDetails(storeID: storeId)
    }
    
    func refreshScreen(withObject userInfo: Notification) {
        
//        let objecInfo: [AnyHashable: Any]? = userInfo.object as? [AnyHashable : Any]
//        storeId = "\(objecInfo?.object(forKeyNotNull: "store_id", expectedObj: ""))"
//        addressId = "\(objecInfo?.object(forKeyNotNull: "address_id", expectedObj: ""))"
//         callApiMethodToGetStoreDetails(storeID: storeId)
    }

    
    
    
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 0:
            return 40
        case 1:
            return 85
        case 2:
            return self.restaurantDetailTableView.rowHeight
        default:
            return self.restaurantDetailTableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        restaurantDetailTableView.allowsSelection = true
        switch indexPath.section {
        case 0:
            var upperCell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreUserInfoTableCell") as? ZNStoreUserInfoTableCell
            
            
            if upperCell == nil {
                upperCell = ZNStoreUserInfoTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreUserInfoTableCell")
            }
            upperCell?.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                upperCell?.storeUserTitleLbl.text = "Email"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeEmail
                break
            case 1:
                upperCell?.storeUserTitleLbl.text = "Address"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeAddress
                break
            case 2:
                upperCell?.storeUserTitleLbl.text = "Website"
                upperCell?.storeUserInfoLbl.text = restaurantInfo.storeWebsite
                break
            default: break
            }
          
            return upperCell!
        case 1:
            var joinCell = tableView.dequeueReusableCell(withIdentifier:"ZNJoinUsTableCell") as? ZNJoinUsTableCell
            joinCell?.selectionStyle = .none
            if joinCell == nil {
                joinCell = ZNJoinUsTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNJoinUsTableCell")
            }
            
            joinCell?.joinBtn.addTarget(self,action:#selector(joinBtnAction),
                                        for:.touchUpInside)
            
            joinCell?.checkInBtn.addTarget(self, action:#selector(checkInAction), for: .touchUpInside)
            if #available(iOS 10.0, *) {
                joinCell?.fbBtn.addTarget(self,action:#selector(faceBookUrl(_:)),
                                          for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                joinCell?.twitterBtn.addTarget(self,action:#selector(twitterUrl(_:)),
                                               for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                joinCell?.instagramBtn.addTarget(self,action:#selector(instagramUrl(_:)),
                                                 for:.touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            return joinCell!
            
        case 2:
//            var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
            
              var cell = tableView.dequeueReusableCell(withIdentifier: "ZNProductDetailDescTableViewCell")as? ZNProductDetailDescTableViewCell
            if cell == nil {
//                cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
                
                cell = ZNProductDetailDescTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNProductDetailDescTableViewCell")
            }
            
            // cell?.rewardLabel.setLineHeight(lineHeight: 25)
//            cell?.selectionStyle = .none
//            cell?.storeAddressLabel.text = "On a purchasing of $500 you will get a 50 points."
//            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Valid until 08/09/2017")
//            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 0, green: 183/255, blue: 251/255, alpha: 1.0), range: NSMakeRange(11, (attrString.length-11)))
//            
//            cell?.storeDistanceLabel.attributedText = attrString
              cell?.productTitleLbl.text = "Rewards"
              cell?.productDescriptionLabel.attributedText = restaurantInfo.storeDescription
            return cell!
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
            return cell!
        }
    }
    
    //MARK: - UIButton Action Method
    
    func checkInAction() {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("\(restaurantInfo.storeName) offer you \(restaurantInfo.storePoint)")
            let shareImageView = UIImageView()
            shareImageView.sd_setImage(with: URL(string: restaurantInfo.storeImage), placeholderImage:UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
            facebookSheet.add(shareImageView.image)
            
            facebookSheet.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.cancelled:
                    print("Cancelled")
                    break
                case SLComposeViewControllerResult.done:
                    self.callApiMethodToCheckInForFacebook()
                    break
                }
            }
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func myRewardsButtonAction(_ sender: Any) {
        let vcObj = ZNRestaurantRewardsVC()
        vcObj.storeId = self.restaurantInfo.storeId
        vcObj.addressId = self.addressId
        vcObj.storeImage = self.restaurantInfo.storeImage
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    func joinBtnAction() {
        
        if (restaurantInfo.storeJoin == "1"){
            _ = AlertController.alert("", message: "Store already joined.")
        }
        else{
            callApiMethodToJoinStore(storeID: self.storeId)
        }
    }
    
    @IBAction func orderTakeAwayButtonAction(_ sender: UIButton) {
        let vcObj = ZNDishListViewController()
        vcObj.storeId = self.restaurantInfo.storeId
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func bookTableButtonAction(_ sender: UIButton) {
        let vcObj = ZNBookATableVC()
        vcObj.storeId = self.storeId as NSString
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func offerBtnAction(_ sender: UIButton) {
        let vcObj = ZNOffersLoyalityEarnedVC()
        vcObj.storeId = storeId as String
        vcObj.isFrom = false
        self.navigationController?.pushViewController(vcObj, animated: true)
        
    }
    @IBAction func bookAppointmentAction(_ sender: Any) {
        if self.bookAppointmentBtn.titleLabel?.text == "Order Take Away" {
            let vcObj = ZNDishListViewController()
            vcObj.storeId = self.restaurantInfo.storeId
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
        else{
            let vcObj = ZNBookAppointmentVC()
            vcObj.storeId = self.storeId
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
  
    @IBAction func callButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor.white
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)

        if restaurantInfo.storeContactNo.length == 0 {
            
            _ = AlertController.alert("Alert!", message: "There is no contact number of this store.")
        }
        else{
        
            if let phoneCallURL = URL(string: "tel://\(restaurantInfo.storeContactNo)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    print("call failed")
                }
            }
        }
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor.white
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        let vcObj = ZNRouteMapVC()
        vcObj.navtitle = self.navTitleLabel.text! as NSString
        vcObj.destinationLat = restaurantInfo.storeLat as NSString;
        vcObj.destinationLong = restaurantInfo.storeLong as NSString;
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor.white

        let vcObj = ZNCustomSharePopUpViewController()
        let productObj = ZNProductInfo()
        productObj.storeId = restaurantInfo.storeId
        productObj.addressId = self.addressId
        productObj.storeName = restaurantInfo.storeName
        productObj.storeCoverImage = restaurantInfo.storeImage
        vcObj.productObj = productObj
        let navController = UINavigationController.init(rootViewController: vcObj)
        navController.modalPresentationStyle = .overCurrentContext
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true, completion: nil)
        
    }


    @available(iOS 10.0, *)
    func faceBookUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeFacebook.length != 0) {
        UIApplication.shared.open(URL (string: restaurantInfo.storeFacebook)! , options: [:], completionHandler: nil)
        }
    
    }
    @available(iOS 10.0, *)
    func twitterUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeTwitter.length != 0) {
           UIApplication.shared.open(URL (string: restaurantInfo.storeTwitter)! , options: [:], completionHandler: nil)
        }
    }
    @available(iOS 10.0, *)
    func instagramUrl(_ sender: UIButton) -> Void {
        if (restaurantInfo.storeInstagram.length != 0) {
               UIApplication.shared.open(URL (string: restaurantInfo.storeInstagram)! , options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - WebService Method
    
    
    
    func callApiMethodToCheckInForFacebook() {
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = self.storeId
        paramDict["address_id"] = addressId
        paramDict["social_type"] = "facebook_checkin"
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "social_sign_point_detail") { (result :AnyObject?, error :NSError?) in
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    // text to share
                    let storeDic =  response.object(forKey: "social_detail" ) as! NSDictionary
                    let text = storeDic["message"] as! String
                    if text.length == 0{
                        _ = AlertController.alert("Sorry!", message:"No check in points are available on this store." , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                            
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                    else{
                        _ = AlertController.alert("", message:text , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                            
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                    
                }
                else {
                }
            }
            else {
            }
        }
    }

    
    func callApiMethodToGetStoreDetails(storeID: NSString!) {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeID
        paramDict[KAddress_Id] = addressId
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KStoreDetail) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                   self.restaurantInfo = self.parseStoreDataWithList(storeDic: response.object(forKey: KStoreDetail ) as! NSDictionary) as ZNStoreInfo
                    if (self.fromNotification){
                        _ = AlertController.alert("", message:"Are you want to check in store for the offers?", controller: self , buttons: ["YES", "NO"], tapBlock: { (UIAlertAction, index) in
                            if index == 0 {
                                self.callApiMethodToCheckIn(checkIn: true)
                                }
                        })
                    
                    }
                    self.callSetUpIntitalView()
                    self.restaurantDetailTableView.reloadData()
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
    
    
    func callApiMethodToCheckIn(checkIn: Bool) {
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = self.storeId
        paramDict["store_address_id"] = addressId
        paramDict["check_in_check_out_status"] = checkIn
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "check_in_check_out") { (result :AnyObject?, error :NSError?) in
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
                else {
                   // _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
               // _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }

    
    func callApiMethodToJoinStore(storeID: NSString!) {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeID
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KJoinStore) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.restaurantInfo.storeJoin = response.object(forKey: KStore_Join) as! String
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
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
    
    func parseStoreDataWithList(storeDic:NSDictionary) -> ZNStoreInfo{
            let storeObject = ZNStoreInfo()
            storeObject.storeName = storeDic.validatedValue(KStore_Name, expected: "" as AnyObject) as! String
            storeObject.storeId = storeDic.validatedValue(KStore_Id, expected: "" as AnyObject) as! String
            storeObject.storeImage = storeDic.validatedValue(KCover_Image, expected: "" as AnyObject) as! String
            storeObject.storeEmail = storeDic.validatedValue(Kemail, expected: "" as AnyObject) as! String
            storeObject.storeContactNo = storeDic.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
         storeObject.storeAddress = "\(storeDic.validatedValue(KAddress, expected: "" as AnyObject)), \(storeDic.validatedValue(KCity, expected: "" as AnyObject)), \(storeDic.validatedValue(Kcountry, expected: "" as AnyObject))"
         storeObject.book_appointment = storeDic.validatedValue(KBook_Appointment, expected: "" as AnyObject) as! String
            storeObject.book_table = storeDic.validatedValue(KBook_Table, expected: "" as AnyObject) as! String
            storeObject.order_take_away = storeDic.validatedValue(KOrder_Take_Away, expected: "" as AnyObject) as! String
            storeObject.storeLat = storeDic.validatedValue(KLatitude, expected: "" as AnyObject) as! String
            storeObject.storeLong = storeDic.validatedValue("langitude", expected: "" as AnyObject) as! String
            storeObject.storeRewards = storeDic.validatedValue(KReward, expected: "" as AnyObject) as! String
            storeObject.storeJoin = storeDic.validatedValue(KStore_Join, expected: "" as AnyObject) as! String
          storeObject.storeWebsite = storeDic.validatedValue(KWebsite, expected: "" as AnyObject) as! String
          storeObject.storeFacebook = storeDic.validatedValue(KFacebook_Link, expected: "" as AnyObject) as! String
          storeObject.storeTwitter = storeDic.validatedValue(KTwitter, expected: "" as AnyObject) as! String
          storeObject.storeInstagram = storeDic.validatedValue(KInstagram, expected: "" as AnyObject) as! String
        
        storeObject.storeDescription = stringFromHtml(string: storeDic.validatedValue(KReward, expected: "" as AnyObject) as! String)!
        return storeObject
    }
    
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    
    
    
    func callSetUpIntitalView() {
        
         restaurantImageView.sd_setImage(with: URL(string: restaurantInfo.storeImage), placeholderImage: UIImage(named: "crownPlaza"), options: SDWebImageOptions.refreshCached)
        navTitleLabel.text = restaurantInfo.storeName
        
        if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "0") {
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = false
   
        }
        else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment Book an Appointment
            self.twoBtnView.isHidden = false
            self.bookAppointmentBtn.setTitle("Order Take Away", for: .normal)
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }
        else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = false
            self.bookAppointmentBtn .setTitle("Book an Appointment", for: .normal)
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "0" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = false
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "0" && restaurantInfo.order_take_away == "1" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }else if (restaurantInfo.book_table == "1" && restaurantInfo.book_appointment == "1" && restaurantInfo.order_take_away == "0" )
        {
            //Appointment
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = false
            self.fourBtnView.isHidden = true
            self.OfferStoreBtn.isHidden = true
            
        }
        else{
            self.twoBtnView.isHidden = true
            self.threeBtnView.isHidden = true
            self.fourBtnView.isHidden = false
            self.OfferStoreBtn.isHidden = false
        }
    }
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

