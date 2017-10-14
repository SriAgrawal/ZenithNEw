

//
//  ZNSideMenuVC.swift
//  Zenith
//
//  Created by Anjali on 01/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
enum LeftMenu {
    case Home
    case Offers
    case Settings
    case TodayOffers
    case MyRewards
    case Coupons
    case Logout
}

let RefreshTheScreenAfterUpdatingUserData = "RefreshTheScreenAfterUpdatingUserData"

class ZNSideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userProfileImage: UIButton!
    
    @IBOutlet var userNameLabel: UILabel!

    var menuNameArray = ["Home", "Offers","Today's Offers","My Rewards","My Coupons","Settings","Logout"]
    
    //Mark:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Helper Method
    func customInit()
    {
        self.tableView.register(UINib(nibName: "ZNSideTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNSideTableViewCell")
        let view = UIView()
        tableView.tableFooterView = view
        tableView.delegate = self
        tableView.dataSource =  self
        
        // Setting of border of the image and make it rounded
        NotificationCenter.default.addObserver(self, selector:  #selector(ZNSideMenuVC.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: RefreshTheScreenAfterUpdatingUserData), object: nil)
         self.callApiMethodToGetProfile();
    }
    
    func methodOfReceivedNotification(notification : NSNotification){
        
        self.callApiMethodToGetProfile()
    }
    
    //Mark:- TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ZNSideTableViewCell", for: indexPath) as! ZNSideTableViewCell
        
        cell.menuListLabel.text = menuNameArray [indexPath.row]
        cell.notificationCountLabel.isHidden = true
        switch indexPath.row {
        case 0:
            cell.menuImageView.image = UIImage(named: "home_Menu")
            
            break
        case 1:
            cell.menuImageView.image = UIImage(named: "offers_Icon")
            
            break
        case 2:
            cell.menuImageView.image = UIImage(named: "todaysofers")
            
            
            break
        case 3:
            cell.menuImageView.image = UIImage(named: "myRewards_Menu")
            cell.notificationCountLabel.isHidden = true
            cell.notificationCountLabel.layer.borderWidth = 1
            cell.notificationCountLabel.layer.cornerRadius = cell.layer.frame.size.width/2
            
            break
        case 4:
            cell.menuImageView.image = UIImage(named: "myCoupons")
            break
        case 5:
            cell.menuImageView.image = UIImage(named: "retailersSetting")
            
            break
        case 6:
            cell.menuImageView.image = UIImage(named: "logout")
            
            break
        default:
            break
        }
        
        return cell
    }
    
    
    
    //Mark:- TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sideMenuController = kAppDelegate.sideMenuController
        
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            
            return
        }
        
        centeralNavController.popToRootViewController(animated: false)
        
        switch indexPath.row {
        case 0:
            let vcObj = ZNHomeVC()
            centeralNavController.setViewControllers([vcObj], animated: false)
            break
        case 1:
            let vcObj = ZNOffersLoyalityEarnedVC()
            vcObj.isFrom = true
            centeralNavController.setViewControllers([vcObj], animated: false)
            break
        case 2:
            let vcObj = ZNTodayOffersVC()
            centeralNavController.setViewControllers([vcObj], animated: false)
            break
        case 3:
            let vcObj = ZNMyPointsVC()
            centeralNavController.setViewControllers([vcObj], animated: false)
            break
        case 4:
            let vcObj = ZNMyCouponsVC()
            centeralNavController.setViewControllers([vcObj], animated: false)
            
            break
        case 5:
            let vcObj = ZNSettingVC()
            centeralNavController.setViewControllers([vcObj], animated: false)
            break
        case 6:
            
            DispatchQueue.main.async {
                _ = AlertController.alert("", message: "Are you sure you want to logout?", controller: self, buttons: ["Yes", "No"], tapBlock: { (alertAction, index) in
                    if index == 0 {
                        self.callApiMethodForLogout()
                    }
                })
            }
            return
        default:
            break
        }
        
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    //Mark:- UIButton Action Method
    
    @IBAction func userProfileButton(_ sender: UIButton) {
        
        let sideMenuController = kAppDelegate.sideMenuController
        
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            
            return
        }
        
        centeralNavController.popToRootViewController(animated: false)
        
        let vcObj = ZNProfileVC()
        centeralNavController.setViewControllers([vcObj], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
        }
    }
    
    //MARK: - WebService Method
    
    func callApiMethodToGetProfile() -> Void {
        
        let userId = UserDefaults.standard.value(forKey: KUser_Id)! as! String
        let apiName = KGetUserProfile + userId
        ServiceHelper.callAPIWithParameters(NSMutableDictionary(), method:  .get, isToken: true, apiName: apiName) { (result :AnyObject?, error :NSError?) in
            
            
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    if let dict = response.object(forKey: "data") as? Dictionary<String, AnyObject> {
                        self.userNameLabel.text = (dict.validatedValue(KfirstName, expected: "" as AnyObject) as? String)! + " " + (dict.validatedValue(KLastName, expected: "" as AnyObject) as! String)
                        let imageURL = dict.validatedValue(KProfileImage, expected: "" as AnyObject) as! String
                        self.userProfileImage.sd_setImage(with: URL(string:imageURL), for: UIControlState.normal, placeholderImage: UIImage(named:"userPlaceholder"), options: .refreshCached)
                        
                        
                        
                       // let imageURL = self.znProfileInfo.profileImageBase64
                        
//                        let url = URL(string:imageURL)
//                        let data = try? Data(contentsOf: url!)
//                        
//                        if data != nil {
//                            self.userProfileImage .setImage((UIImage(data: data!)), for: .normal)
//                        }

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
    
    func callApiMethodForLogout() -> Void {
        
        ServiceHelper.callAPIWithParameters(NSMutableDictionary(), method:  .get, isToken: true, apiName: "logout") { (result :AnyObject?, error :NSError?) in
            
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    self.navigationController?.popViewController(animated: true)
                    kAppDelegate.logout()
                }
                else {
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }

    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
