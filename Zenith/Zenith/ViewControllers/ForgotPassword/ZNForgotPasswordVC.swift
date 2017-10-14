//
//  ZNForgotPasswordVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNForgotPasswordVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: BTCustomTextfield!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    var zenithInfo = ZNUserInfo()
    
    //MARK: - UIViewLifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.placeholder = "Email ID"
    }
    
    //MARK: - Helper Methods
    func initialMethod()  {
        self.navigationController?.isNavigationBarHidden = true
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.clipsToBounds = true
        contentLabel.setLineHeight(lineHeight: 5)
        
        if UIScreen.main.bounds.width == 320 {
            topConstraint.constant = 80
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextfieldsDelegates Methods.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        if str.length > 64 || string == " "{
            return false
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    zenithInfo.email = textField.text!.lowercased()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            view.endEditing(true)
        }
        return true
    }
    
    //MARK : - Validation Methods
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        if zenithInfo.email.trimWhiteSpace().length == 0 {
            presentAlert("", msgStr: BLANK_EMAIL, controller: self)
            isVerfied  = false
        }else if zenithInfo.email.isEmail() == false  {
            presentAlert("", msgStr: VALID_EMAIL, controller: self)
            isVerfied  = false
        }
        return isVerfied
    }
    
    //MARK: -UIButton Action Method
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if  isallFieldsVerfield() {
            self.callApiMethodForForgotPassword()
        }
    }
    
    //MARK: - WebService Method
    
    func callApiMethodForForgotPassword() -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[Kemail] = trimWhiteSpace(emailTextField.text!)
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: false, apiName: KForgotPassword) { (result :AnyObject?, error :NSError?) in
           
            
            if error == nil {
                 let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                   _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                    self.navigationController?.popViewController(animated: true)
                    })

                }
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
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
