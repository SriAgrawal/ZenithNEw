//
//  ZNChangePassswordVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNChangePassswordVC: UIViewController,UITextFieldDelegate {
    
    var zenithInfo = ZNUserInfo()
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPassImageView: UIImageView!
    @IBOutlet weak var newPassImageView: UIImageView!
    @IBOutlet weak var conPassImageView: UIImageView!
    @IBOutlet weak var leadingConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOutlet: NSLayoutConstraint!
    
    //MARK: - UIViewLifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        //Setting text field background color
        oldPasswordTextField.backgroundColor = UIColor(red: (242/255.0), green: (242/255.0), blue: (242/255.0), alpha: 1.0)
        newPasswordTextField.backgroundColor = UIColor(red: (242/255.0), green: (242/255.0), blue: (242/255.0), alpha: 1.0)
        confirmPasswordTextField.backgroundColor = UIColor(red: (242/255.0), green: (242/255.0), blue: (242/255.0), alpha: 1.0)
        
        //Setting View Constraint
        if UIScreen.main.bounds.width == 320 {
            leadingConstraintOutlet.constant = 0
            trailingConstraintOutlet.constant = 0
            topConstraintOutlet.constant = 124
        }
        
        //setting imageview radius
        oldPassImageView.layer.cornerRadius = oldPassImageView.frame.size.height/2;
        oldPassImageView.clipsToBounds = true
        newPassImageView.layer.cornerRadius = newPassImageView.frame.size.height/2;
        newPassImageView.clipsToBounds = true
        conPassImageView.layer.cornerRadius = conPassImageView.frame.size.height/2;
        conPassImageView.clipsToBounds = true
        
        //Move view up
        if UIScreen.main.bounds.width == 320 {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 50
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 50
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }
    
    //MARK: - UITextfieldsDelegates Methods.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        self.oldPasswordTextField.isSecureTextEntry = true
        switch textField.tag {
        case 100:
            if str.length > 16 {
                return false
            }
            break
        case 101:
            if str.length > 16 {
                return false
            }
            break
        case 102:
            if str.length > 16 {
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
            zenithInfo.oldPassword = textField.text!
            break
        case 101:
            zenithInfo.newPassword = textField.text!
            break
        case 102:
            zenithInfo.confirmPassword = textField.text!
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
    
    //MARK: - Validation Method
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        
        if zenithInfo.oldPassword.trimWhiteSpace().length == 0 {
            presentAlert("", msgStr:BLANK_OLD_PASS, controller: self)
            isVerfied  = false
        } else if zenithInfo.oldPassword.length < 8  {
            presentAlert("", msgStr: MIN_PASSWORD, controller: self)
            isVerfied  = false
        } else if zenithInfo.newPassword.trimWhiteSpace().length == 0 {
            presentAlert("", msgStr: BLANK_NEW_PASS, controller: self)
            isVerfied  = false
        } else if zenithInfo.newPassword.length < 8  {
            presentAlert("", msgStr: MIN_NEW_PASSWORD, controller: self)
            isVerfied  = false
        } else if zenithInfo.confirmPassword.trimWhiteSpace().length == 0 {
            presentAlert("", msgStr: BLANK_CONFIRM_PASS, controller: self)
            isVerfied  = false
        } else if zenithInfo.confirmPassword.length < 8  {
            presentAlert("", msgStr: MIN_CONFIRM_PASS, controller: self)
            isVerfied  = false
        }
        else if (zenithInfo.newPassword == zenithInfo.confirmPassword) == false {
            presentAlert("", msgStr: MATCH_PASSWORD, controller: self)
            isVerfied  = false
        }
        return isVerfied
    }
    
    //MARK: -UIButton Action Method
    @IBAction func saveButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if  isallFieldsVerfield() {
           // self.navigationController!.popViewController(animated: true)
                    self.callApiMethodToChangePassword()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
        //MARK: - WebService Method
    
        func callApiMethodToChangePassword() -> Void {
    
            let paramDict = NSMutableDictionary()
    
            paramDict[Koldpassword] = zenithInfo.oldPassword
            paramDict[Kconfirm_password] = zenithInfo.newPassword
    
            ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "change_password") { (result :AnyObject?, error :NSError?) in
    
                if error == nil {
                    let response = result as! NSDictionary
                    if Int(response.object(forKey: KresponseCode) as! String) == 200 {
    
                        _ = AlertController.alert("Success!", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                            self.navigationController?.popViewController(animated: true)
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
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
