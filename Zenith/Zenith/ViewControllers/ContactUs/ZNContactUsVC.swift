//
//  ZNContactUsVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNContactUsVC: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    
    var zenithInfo = ZNUserInfo()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var contactUsTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK: - View LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.contactUsTableView.tableHeaderView = headerView
        
        //Setting Text view border, radius , text color
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 198/255.0, alpha: 1.0).cgColor
        self.descriptionTextView.text  =  "Description"
        self.descriptionTextView.delegate  =  self
        self.descriptionTextView.layer.cornerRadius = 9
        descriptionTextView.textContainerInset = UIEdgeInsetsMake(15, 5, 5, 0)
        self.descriptionTextView.textColor = UIColor.darkText
        
        //Setting view constraint
        if UIScreen.main.bounds.width == 320 {
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            topConstraint.constant = 80
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ZNContactUsVC.dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.nameTextField.attributedPlaceholder = NSAttributedString(string:"Name", attributes: [NSForegroundColorAttributeName : UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Email ID", attributes: [NSForegroundColorAttributeName : UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)])
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UITextViewDelegate Methods
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if descriptionTextView.text == "Description" {
            descriptionTextView.text = nil
        }
        descriptionTextView.textColor=UIColor.black;
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView)
        
    {
        if (descriptionTextView.text.length == 0) {
            descriptionTextView.textColor=UIColor.lightGray;
            descriptionTextView.text="Description"
            descriptionTextView .resignFirstResponder();
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.length == 0 {
            descriptionTextView.text = "Description"
        }
        zenithInfo.desc = descriptionTextView.text
    }

    //MARK: - UITextfieldsDelegates Methods.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 200:
            if string.length == 0{
                return true
            }
            if string.isValidName() == true
            {
                if (textField.text?.length)! >= 30 {
                    return false
                }
                return true
            } else {
                return false
            }
            
        case 201:
            if str.length > 64 {
                return false
            }else {
                return true
            }
            
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 200:
            zenithInfo.name = textField.text!
            break
        case 201:
            zenithInfo.email = textField.text!
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
    
    //MARK : - Validation Methods
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        if zenithInfo.name.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_NAME)
            isVerfied = false
        } else  if zenithInfo.name.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_NAME)
            isVerfied = false
        } else if zenithInfo.name.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_NAME)
            isVerfied = false
        } else if zenithInfo.email.trimWhiteSpace().length == 0 {
            presentAlert("", msgStr: BLANK_EMAIL, controller: self)
            isVerfied  = false
        } else if zenithInfo.email.isEmail() == false  {
            presentAlert("", msgStr: VALID_EMAIL, controller: self)
            isVerfied  = false
        } else if zenithInfo.desc.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_DESC)
        }
        return isVerfied
    }
    
    //MARK : - UIButton Action Method
    @IBAction func submitButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if  isallFieldsVerfield() {
            callApiMethodForContactUs()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
 
    //MARK :- Call API for Contact Us
    func callApiMethodForContactUs() -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KName] = zenithInfo.name
        paramDict[Kemail] = zenithInfo.email
        paramDict[KDescription] = zenithInfo.desc

        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KContactUs) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                 _ =    AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String, acceptMessage: "OK", acceptBlock: {
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
