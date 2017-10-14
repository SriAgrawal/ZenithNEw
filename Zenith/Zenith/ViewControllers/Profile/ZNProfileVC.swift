//
//  ZNProfileVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProfileVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var profileCredentialArray = [String]()
    var znProfileInfo = ZNUserInfo()
    @IBOutlet var editButton: UIButton!
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewLifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        // For registereing nib
        self.profileTableView.register(UINib(nibName: "ZNProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNProfileTableViewCell")
        profileCredentialArray = ["First Name","Last Name","Email ID","Mobile Number","DOB"]
        znProfileInfo.firstName="Alex"
        znProfileInfo.lastName="Martin"
        znProfileInfo.email="alex.martin@gmail.com"
        znProfileInfo.mobileNumber="8585858441"
        znProfileInfo.dob="26/May/2017"
        viewHeightConstraint.constant = (window_width == 320) ? 330 : 370
        self.callApiMethodToGetProfile()
    }
    
    // MARK: - Table View Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZNProfileTableViewCell")as? ZNProfileTableViewCell
        cell?.profileLabel.tag = indexPath.row + 100
        cell?.profileLabel.isUserInteractionEnabled = false
        if cell == nil{
            cell = ZNProfileTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNProfileTableViewCell")
        }
        
        switch indexPath.row {
        case 0:
            cell?.profileNameLabel.text = profileCredentialArray[indexPath.row]
            cell?.profileLabel.text=znProfileInfo.firstName
            cell?.profileImageView.image = UIImage(named: "firstname_Signup.png")
            break
        case 1:
            cell?.profileNameLabel.text = profileCredentialArray[indexPath.row]
            cell?.profileLabel.text = znProfileInfo.lastName
            cell?.profileImageView.image = UIImage(named: "lastname_Signup.png")
            break
        case 2:
            cell?.profileNameLabel.text = profileCredentialArray[indexPath.row]
            cell?.profileLabel.text = znProfileInfo.email
            cell?.profileImageView.image = UIImage(named: "email_Signup.png")
            break
        case 3:
            cell?.profileNameLabel.text = profileCredentialArray[indexPath.row]
            cell?.profileLabel.text=znProfileInfo.mobileNumber
            cell?.profileImageView.image = UIImage(named: "call_Signup.png")
            break
        case 4:
            cell?.profileNameLabel.text = profileCredentialArray[indexPath.row]
            cell?.profileLabel.text=znProfileInfo.dob
            cell?.profileImageView.image = UIImage(named: "DOB_Signup.png")
            break
        default:
            break
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58.0
    }
    
    // MARK: - UIButton Action Method
    @IBAction func menuButtonClick(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RefreshTheScreenAfterUpdatingUserData), object: nil)
        self.toggleSlider()
    }
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        let vcObj = ZNEditProfileVC()
        vcObj.zNEditInfo = self.znProfileInfo;
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
//    //MARK: - WebService Method
    
    func callApiMethodToGetProfile() -> Void {
        
        let userId = UserDefaults.standard.value(forKey: KUser_Id)! as! String
        let apiName = KGetUserProfile + userId
        ServiceHelper.callAPIWithParameters(NSMutableDictionary(), method:  .get, isToken: true, apiName: apiName) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    if let dict = response.object(forKey: "data") as? Dictionary<String, AnyObject> {
                        self.znProfileInfo = ZNUserInfo.getDataOfProfile(userInfo: dict)
                        
                    }
                    
                    
                    let imageURL = self.znProfileInfo.profileImageBase64
                    self.profileImageView.sd_setImage(with: URL(string:imageURL), placeholderImage: UIImage(named:"userPlaceholder"), options: .refreshCached)
//                    let imageURL = self.znProfileInfo.profileImageBase64
//                    
//                    let url = URL(string:imageURL)
//                    let data = try? Data(contentsOf: url!)
//                    
//                    if data != nil {
//                        self.profileImageView.image = (UIImage(data: data!))
//                    }
                    self.profileTableView.reloadData()
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
