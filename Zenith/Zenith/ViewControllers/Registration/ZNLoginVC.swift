//
//  ZNLoginVC.swift
//  Zenith
//
//  Created by Mobiloitte on 29/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ZNLoginVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,ESTBeaconManagerDelegate {
    
    var loginObj = ZNUserInfo()
    
    @IBOutlet weak var loginTableview: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: UIButton!
    @IBOutlet weak var leadingConstraintView: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintView: NSLayoutConstraint!
    @IBOutlet weak var facebookloginBtn: UIButton!
    
    weak var actionToEnable : UIAlertAction?
    

    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initialMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        forgotPasswordBtn.titleLabel?.textColor = UIColor.white
        forgotPasswordBtn.underlineButton(text: "Forgot Password?")
        
        facebookloginBtn.addCharactersSpacing(spacing: 2, text: "FACEBOOK")
        facebookloginBtn.titleLabel?.textColor = UIColor.white
        
        if UserDefaults.standard.bool(forKey: KisRemember){
            if let email = UserDefaults.standard.value(forKey: DEmail) as? String {
                loginObj.email = email
            }
            //loginObj.password = ""
            rememberMeBtn.isSelected = true
        }
        else{
            loginObj.email = ""
            loginObj.password = ""
            rememberMeBtn.isSelected = false
        }
        loginTableview.reloadData()
    }
    

    //MARK: - Helper Method
    func initialMethod(){
        self.navigationController?.isNavigationBarHidden = true
        loginTableview.tableHeaderView = headerView
        loginTableview.tableFooterView = footerView
        
        //register cell
        self.loginTableview.register(UINib(nibName: "ZNLoginTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNLoginTableViewCell")
        
        //Setting View Constraints
        if UIScreen.main.bounds.width == 320 {
            leadingConstraintView.constant = 23
            trailingConstraintView.constant = 23
        }
        
        if UserDefaults.standard.bool(forKey: KisLoggedIn) && UserDefaults.standard.bool(forKey: KisRemember) {
            self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)
        }
    }
    
    //MARK: - UITextFieldDelegates Methods.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        switch textField.tag {
        case 100:
            
            if str.length >= 64 || string == " "{
                return false
            }
        case 101:
            if str.length >= 16 || string == " " {
                return false
            }
            break
        default:
            break
        }
        return true
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            loginObj.email = textField.text!.lowercased()
            break
            
        case 101:
            loginObj.password = textField.text!
            break
            
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    //MARK: - Validation Methods.
    func isallFieldsVerfield() -> Bool
    {
        var isAllValid = true
        if loginObj.email.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_EMAIL)
            isAllValid = false
        } else if loginObj.email.isEmail() == false {
            _ = AlertController.alert(BLANK, message: VALID_EMAIL)
            isAllValid = false
        } else if loginObj.password.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_PASSWORD)
            isAllValid = false
        } else if loginObj.password.trimWhiteSpace().length < 8  {
            _ = AlertController.alert(BLANK, message: MIN_PASSWORD)
            isAllValid = false
        }
        return isAllValid;
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ZNLoginTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZNLoginTableViewCell", for: indexPath) as! ZNLoginTableViewCell
        
        loginTableview.allowsSelection = true
        cell.selectionStyle = .none
        cell.loginTextField.delegate = self as UITextFieldDelegate
        cell.loginTextField.tag = indexPath.row + 100
        cell.loginTextField.isSecureTextEntry = false
        cell.dateBookinBtn.isHidden = true
        cell.loginTextField.backgroundColor = .white
        
        //Setting cell view constraints
        if UIScreen.main.bounds.width == 320 {
            cell.leadingConstraintOutlet.constant = 23
            cell.trailingConstraintOutlet.constant = 23
        }
        
        switch indexPath.row {
        case 0:
            cell.loginTextField.placeholder = "Email ID"
            cell.loginImageView.image = UIImage(named:"emailID_Login")
            cell.loginTextField.keyboardType = .emailAddress
            cell.loginTextField.returnKeyType = .next
            cell.loginTextField.text = loginObj.email
            break
            
        case 1:
            cell.loginTextField.placeholder = "Password"
            cell.loginImageView.image = UIImage(named:"Password_Login")
            cell.loginTextField.keyboardType = .default
            cell.loginTextField.returnKeyType = .done
            cell.loginTextField.isSecureTextEntry = true
            cell.loginTextField.text = loginObj.password
            break
            
        default:
            break
        }
        return cell
    }
    
    //MARK: - UIButton Action Method
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func forgotPassButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        let vcObj = ZNForgotPasswordVC()
        // let vcObj = ZNAddCardViewController()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        if  isallFieldsVerfield() {
            //self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)

           callApiMethodForLogin()
            
        }
    }
    
    @IBAction func loginViaFbButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        //FacebookManager.facebookManager.logoutFromFacebook()
        FacebookManager.facebookManager.getFacebookInfoWithCompletionHandler(self) { (result, token, error) in
            if token.length>0{

                let paramDict = NSMutableDictionary()
                paramDict[Kemail] = result?.validatedValue("email", expected: "" as AnyObject)
                paramDict[Kpassword] = "12345678"
                paramDict[KfirstName] = result?.validatedValue(KfirstName, expected: "" as AnyObject)
                paramDict[KLastName] = result?.validatedValue(KLastName, expected: "" as AnyObject)
                paramDict[KSocialType] = "facebook"
                paramDict[KSocialId] = result?.validatedValue(Kid, expected: "" as AnyObject)
                paramDict[Kdevice_token] = UserDefaults.standard.value(forKey: Kdevice_token)
                paramDict[Kdevice_type] = "ios"

                let imageInfo = result?.validatedValue("picture", expected: NSDictionary()) as! NSDictionary
                let imageDataInfo = imageInfo.validatedValue("data", expected: NSDictionary()) as! NSDictionary
                let url = imageDataInfo.validatedValue("url", expected: "" as AnyObject) as! String
                paramDict[KProfileImage] = url
                self.methodToAddEmail(paramDict: paramDict)
            }
        }
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        let vcObj = ZNSignUpVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    func textChanged(_ sender:UITextField) {
        
        if (sender.text?.trimWhiteSpace().length == 0) || sender.text?.isEmail() == false{
            self.actionToEnable?.isEnabled  = false
        }
        else{
            self.actionToEnable?.isEnabled  = true
        }
    }
    
    func methodToAddEmail(paramDict: NSMutableDictionary){
        
        if paramDict.validatedValue("email", expected: "" as AnyObject) as! String == ""{
            
            let alertController = UIAlertController(title: "", message: "Please enter email", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
            })
            
            let saveAction = UIAlertAction(title: "Submit", style: .default, handler: {
                alert -> Void in
                
                let firstTextField = alertController.textFields![0] as UITextField
                
                paramDict[Kemail] = firstTextField.text?.trimWhiteSpace()
                self.callApiMethodForSocialLogin(paramDict: paramDict)
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Email"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            }
            self.actionToEnable = saveAction
            saveAction.isEnabled = false
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.callApiMethodForSocialLogin(paramDict: paramDict)
        }
    }
    //MARK: - WebService Method
    
    func callApiMethodForLogin() -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[Kemail] = loginObj.email
        paramDict[Kpassword] = loginObj.password
        paramDict[Kdevice_token] = UserDefaults.standard.value(forKey: Kdevice_token)
        paramDict[Kdevice_type] = "ios"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: false, apiName: Klogin) { (result :AnyObject?, error :NSError?) in
            

            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    let userDict = response.validatedValue(KUserInfo, expected: NSDictionary())
                    UserDefaults.standard.set(userDict.validatedValue(KUser_Id, expected: "" as AnyObject), forKey: KUser_Id)
                    UserDefaults.standard.set(userDict.validatedValue(KApi_Key, expected: "" as AnyObject), forKey: KApi_Key)
                    UserDefaults.standard.set(self.rememberMeBtn.isSelected, forKey: KisRemember)
                    UserDefaults.standard.set(true, forKey: KisLoggedIn)
                    
                    if self.rememberMeBtn.isSelected == true {
                        UserDefaults.standard.set(trimWhiteSpace(self.loginObj.email), forKey: DEmail)
                        UserDefaults.standard.set(trimWhiteSpace(self.loginObj.password), forKey: DPasseord)
                    }
                    else{
                        UserDefaults.standard.set("", forKey: DEmail)
                        UserDefaults.standard.set("", forKey: DPasseord)
                    }
                    UserDefaults.standard.synchronize()
                    self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)
                }
              else if Int(response.object(forKey: KresponseCode) as! String) == 400 {
                    _ = AlertController.alert("", message:"Are you new user for login?" , controller: self, buttons: ["YES", "NO"], tapBlock: { (alertAction, index) in
                        
                        if index == 0{
                            self.callApiMethodForNewLogin()
                        }
                    })
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
    
    
    func callApiMethodForNewLogin() -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[Kemail] = loginObj.email
        paramDict[Kpassword] = loginObj.password
        paramDict[Kdevice_token] = UserDefaults.standard.value(forKey: Kdevice_token)
        paramDict[Kdevice_type] = "ios"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: false, apiName: Klogin_new) { (result :AnyObject?, error :NSError?) in
           
            if error == nil {
                
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    let userDict = response.validatedValue(KUserInfo, expected: NSDictionary())
                    
                    UserDefaults.standard.set(userDict.validatedValue(KUser_Id, expected: "" as AnyObject), forKey: KUser_Id)
                    UserDefaults.standard.set(userDict.validatedValue(KApi_Key, expected: "" as AnyObject), forKey: KApi_Key)
                    UserDefaults.standard.set(self.rememberMeBtn.isSelected, forKey: KisRemember)
                    UserDefaults.standard.set(true, forKey: KisLoggedIn)
                    
                    if self.rememberMeBtn.isSelected == true {
                        UserDefaults.standard.set(trimWhiteSpace(self.loginObj.email), forKey: DEmail)
                        UserDefaults.standard.set(trimWhiteSpace(self.loginObj.password), forKey: DPasseord)
                    }
                    else{
                        UserDefaults.standard.set("", forKey: DEmail)
                        UserDefaults.standard.set("", forKey: DPasseord)
                    }
                    UserDefaults.standard.synchronize()
                    self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)
                }
                else {
                     _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as AnyObject) as! String)
                }
            }
            else {
                 _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }
    
   
    func callApiMethodForSocialLogin(paramDict:NSMutableDictionary) -> Void {
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: false, apiName: KSocialLogin) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    
                    let userDict = response.validatedValue(KUserInfo, expected: NSDictionary())
                    UserDefaults.standard.set(userDict.validatedValue(KUser_Id, expected: "" as AnyObject), forKey: KUser_Id)
                    UserDefaults.standard.set(userDict.validatedValue(KApi_Key, expected: "" as AnyObject), forKey: KApi_Key)
                    UserDefaults.standard.set(true, forKey: KisLoggedIn)
                    UserDefaults.standard.set(true, forKey: KisRemember)
                    UserDefaults.standard.synchronize()
                    self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)
                }
                else {
                    _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as AnyObject) as! String)
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
