//
//  ZNSettingVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pushStatus = NSString()
    
    
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        self.settingTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Register cell
        self.settingTableView.register(UINib(nibName:"ZNSetNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNSetNotificationTableViewCell")
        self.settingTableView.register(UINib(nibName:"ZNSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNSettingTableViewCell")
        
        self.callApiMethodToGetPushCheck()
        
        //Set UITableView Scrolling
        if UIScreen.main.bounds.height >= 667 {
            settingTableView.isScrollEnabled = false
        } else {
            settingTableView.isScrollEnabled = true
        }
        
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = tableView.dequeueReusableCell(withIdentifier:"ZNSetNotificationTableViewCell") as? ZNSetNotificationTableViewCell
        var cell2 = tableView.dequeueReusableCell(withIdentifier:"ZNSettingTableViewCell") as? ZNSettingTableViewCell
        
        settingTableView.allowsSelection = true
        
        if cell1 == nil {
            cell1 = ZNSetNotificationTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNSetNotificationTableViewCell")
        }
        if cell2 == nil {
            cell2 = ZNSettingTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNSettingTableViewCell")
        }
        
        cell1?.selectionStyle = .none
        cell2?.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            if self.pushStatus .isEqual(to:"1") {
                cell1?.notificationSwitch .setOn(true, animated: true)
            }else{
                cell1?.notificationSwitch .setOn(false, animated: true)

            }
            cell1?.notificationSwitch.addTarget(self, action: #selector(swicthChanged), for: .valueChanged)
            return cell1!
            
        case 1:
            cell2?.contentLabel.text  = "Change Password"
            cell2?.settingImageView.image = UIImage(named: "changePassword")
            break
            
        case 2:
            cell2?.contentLabel.text  = "Terms & Conditions"
            cell2?.settingImageView.image = UIImage(named: "t&C")
            break
            
        case 3:
            cell2?.contentLabel.text  = "About Us"
            cell2?.settingImageView.image = UIImage(named: "aboutUs")
            break
            
        case 4:
            cell2?.contentLabel.text  = "Contact Us"
            cell2?.settingImageView.image = UIImage(named: "call_Signup")
            break
            
        case 5:
            cell2?.contentLabel.text  = "Retailers Settings"
            cell2?.settingImageView.image = UIImage(named: "retailersSetting")
            break
            
        case 6:
            cell2?.contentLabel.text  = "Loyality Gain Info"
            cell2?.settingImageView.image = UIImage(named: "loyaltyGain")
            break
            
        default:
            break
        }
        return cell2!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let vcObj = ZNChangePassswordVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 2:
            let vcObj = ZNTCViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 3:
            let vcObj = ZNAboutUsVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 4:
            let vcObj = ZNContactUsVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 5:
            let vcObj = ZNRetailersSettingVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 6:
            let vcObj = ZNLoyalityGainInfoVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        default:
            break
        }
    }
    
    //MARK: - UISwitch Changed action method
    func swicthChanged(mySwitch: UISwitch) {
        
        _ = AlertController.alert("Are you sure!", message: (mySwitch.isOn == true) ? "You want to switch ON push notification for Zenith" : "You want to switch OFF push notification for Zenith", controller: self, buttons: ["YES", "NO"], tapBlock: { (alertAction, index) in
            
            if mySwitch.isOn == true {
                if index == 0{
                    self.pushStatus = "1"
                    self.callApiMethodToPushCheck()
                }
            }else{
                if index == 0{
                    self.pushStatus = "0"

                    self.callApiMethodToPushCheck()
                }
            }
            self.settingTableView.reloadData()
        })
    }
    
    //MARK: - WebService Method
    
    
    func callApiMethodToGetPushCheck() -> Void {
        
        ServiceHelper.callAPIWithParameters(NSMutableDictionary(), method:  .get, isToken: true, apiName: "user_pushsetting") { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    if let dict = response.object(forKey: "data") as? Dictionary<String, AnyObject> {
                        
                        self.pushStatus = dict.validatedValue(Kpush_setting, expected: String() as AnyObject) as! NSString
                        
                    }
                    self.settingTableView.reloadData()
                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                    self.settingTableView.reloadData()
                }
            }
            else {
                _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }

    
    
    func callApiMethodToPushCheck() -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[Kpush_setting] = self.pushStatus
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: Kpush_setting) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    if let dict = response.object(forKey: "data") as? Dictionary<String, AnyObject> {
//                       UserDefaults.standard.set(dict.validatedValue(Kpush_setting, expected: true as Bool as AnyObject), forKey: "swtichOn")
                        
                        self.pushStatus = dict.validatedValue(Kpush_setting, expected: String() as AnyObject) as! NSString

                    }
                    self.settingTableView.reloadData()
                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                    self.settingTableView.reloadData()
                }
            }
            else {
                _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - UIButton Action Methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.toggleSlider()
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
