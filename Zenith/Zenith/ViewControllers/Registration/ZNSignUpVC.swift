//
//  ZNSignUpVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSignUpVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var signupCredentialArray       = [String]()
    var imagePicker   =  UIImagePickerController()
    var zNSignUpInfo                    = ZNUserInfo()
    
    @IBOutlet var tickButton: UIButton!
    @IBOutlet var signUpImage: UIButton!
    @IBOutlet var signUpTableView       : UITableView!
    var flag = Bool()
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMethod()
    }
    
    // MARK: - Helper methods
    func initMethod() {
        flag = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.signUpImage.layer.cornerRadius = 55
        self.signUpImage.clipsToBounds = true
        signUpTableView.tableHeaderView = UIView.init(frame: CGRect.init(origin: signUpTableView.bounds.origin, size: CGSize.init(width: signUpTableView.bounds.size.width, height: 40)))
        signupCredentialArray = ["First Name","Last Name","Email","Password","Confirm Password","Mobile Number (Optional)","DOB (Optional)"]
        
        // For registereing nib
        self.signUpTableView.register(UINib(nibName: "ZNSignUpTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNSignUpTableViewCell")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - table view delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signupCredentialArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ZNSignUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZNSignUpTableViewCell", for: indexPath) as! ZNSignUpTableViewCell
        cell.signUpTextField.delegate = self
        cell.signUpTextField.tag = indexPath.row + 100
        cell.dobButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        cell.dobButton.isHidden = true
        cell.signUpTextField.autocapitalizationType = .none
        cell.signUpTextField.returnKeyType = .next
        cell.signUpTextField.isSecureTextEntry = false
        cell.signUpImageView.backgroundColor = UIColor.white
        cell.signUpLabel.isHidden = false
        
        switch indexPath.row {
        case 0:
            cell.signUpTextField.keyboardType = .default
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.autocapitalizationType = .words
            cell.signUpTextField.text=zNSignUpInfo.firstName
            cell.signUpImageView.image = UIImage(named: "firstname_Signup.png")
            break
        case 1:
            cell.signUpTextField.keyboardType = .default
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.autocapitalizationType = .words
            cell.signUpTextField.text=zNSignUpInfo.lastName
            cell.signUpImageView.image = UIImage(named: "lastname_Signup.png")
            break
            
        case 2:
            cell.signUpTextField.keyboardType = .emailAddress
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.text=zNSignUpInfo.email
            cell.signUpImageView.image = UIImage(named: "email_Signup.png")
            break
            
        case 3:
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.isSecureTextEntry = true
            cell.signUpTextField.text=zNSignUpInfo.password
            cell.signUpImageView.image = UIImage(named: "password_Signup.png")
            break
            
        case 4:
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.isSecureTextEntry = true
            cell.signUpTextField.text = zNSignUpInfo.confirmPassword
            cell.signUpImageView.image = UIImage(named: "confirm_pass_Signup.png")
            break
            
        case 5:
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 3001
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell.signUpTextField.inputAccessoryView = toolbar
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.keyboardType = .numberPad
            cell.signUpTextField.text=zNSignUpInfo.mobileNumber
            cell.signUpImageView.image = UIImage(named: "call_Signup.png")
            break
            
        case 6:
            cell.signUpTextField.placeholder = signupCredentialArray[indexPath.row]
            cell.signUpTextField.autocapitalizationType = .words
            cell.signUpTextField.text=zNSignUpInfo.dob
            cell.dobButton.isHidden = false
            cell.signUpImageView.image = UIImage(named: "DOB_Signup.png")
            cell.signUpLabel.isHidden = true
        default:
            break
        }
        cell.signUpTextField.attributedPlaceholder = NSAttributedString(string:cell.signUpTextField.placeholder != nil ? cell.signUpTextField.placeholder! : "", attributes: [NSForegroundColorAttributeName : UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)])
        if indexPath.row == 5 {
            let stringAttributed = NSMutableAttributedString.init(string: "Mobile Number (Optional)")
            
            let font = UIFont(name: "ITCKabelStd-Book", size: 12.0)
            
            stringAttributed.addAttribute(NSFontAttributeName, value:font!, range: NSRange.init(location: 14, length: 10))
            
            stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0), range: NSRange.init(location: 0, length: "Mobile Number (Optional)".length))
            cell.signUpTextField.attributedPlaceholder = stringAttributed
            
        }
            
        else if indexPath.row == 6{
            
            let stringAttributed = NSMutableAttributedString.init(string: "DOB (Optional)")
            
            let font = UIFont(name: "ITCKabelStd-Book", size: 12.0)
            
            stringAttributed.addAttribute(NSFontAttributeName, value:font!, range: NSRange.init(location: 4, length: 10))
            stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0), range: NSRange.init(location: 0, length: "DOB (Optional)".length))
            cell.signUpTextField.attributedPlaceholder = stringAttributed
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 54.0
    }
    
    //Mark :- UiText Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 100, 101:
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
        case 102:
            if  (textField.text?.length)! >= 64 || string == " "{
                return false
            }
        case 103, 104:
            print(range.length)
            if  ((textField.text?.length)! >= 16 && range.length == 0) || string == " " {
                return false
            }
        case 105:
            
            if (str.length == 1) &&  (str == "0") {
                return false
            }
            if  (textField.text?.length)! >= 15 && range.length == 0 {
                return false
            }
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            self.signUpTableView .viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view .layoutIfNeeded()
        switch textField.tag {
        case 100:
            zNSignUpInfo.firstName = textField.text!
            break
        case 101:
            zNSignUpInfo.lastName = textField.text!
            break
        case 102:
            zNSignUpInfo.email = textField.text!.lowercased()
            break
        case 103:
            zNSignUpInfo.password = textField.text!
            break
        case 104:
            zNSignUpInfo.confirmPassword = textField.text!
            break
        case 105:
            zNSignUpInfo.mobileNumber = textField.text!
            break
            
        default:
            break
            
        }
    }
    
    // MARK: - TextField Validations
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        
        if zNSignUpInfo.firstName.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_FIRSTNAME)
            isVerfied = false
        } else  if zNSignUpInfo.firstName.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_FIRSTNAME)
            isVerfied = false
        } else if zNSignUpInfo.firstName.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_FIRSTNAME)
            isVerfied = false
        } else if zNSignUpInfo.lastName.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_LASTNAME)
            isVerfied = false
        } else  if zNSignUpInfo.lastName.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_LASTNAME)
            isVerfied = false
        } else if zNSignUpInfo.lastName.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_LASTNAME)
            isVerfied = false
        } else if zNSignUpInfo.email.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_EMAIL)
            isVerfied = false
        } else if zNSignUpInfo.email.isEmail() == false {
            _ = AlertController.alert(BLANK,message: VALID_EMAIL)
            isVerfied = false
        } else if zNSignUpInfo.email.trimWhiteSpace().length > 64 {
            _ = AlertController.alert(BLANK,message: MAX_EMAIL)
            isVerfied = false
        } else if zNSignUpInfo.password.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_PASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.password.trimWhiteSpace().length < 8  {
            _ = AlertController.alert(BLANK,message: MIN_PASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.password.trimWhiteSpace().length > 16  {
            _ = AlertController.alert(BLANK,message: MAX_PASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.confirmPassword.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_CONFIRMPASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.confirmPassword.trimWhiteSpace().length < 8  {
            _ = AlertController.alert(BLANK,message: MIN_CONFIRMPASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.confirmPassword.trimWhiteSpace().length > 16  {
            _ = AlertController.alert(BLANK,message: MAX_CONFIRMPASSWORD )
            isVerfied = false
        } else if (zNSignUpInfo.password == zNSignUpInfo.confirmPassword) == false {
            _ = AlertController.alert(BLANK,message: MATCH_PASSWORD)
            isVerfied = false
        } else if zNSignUpInfo.mobileNumber.length != 0 && zNSignUpInfo.mobileNumber.length < 7  {
            _ = AlertController.alert(BLANK,message: MINI_MOBILENUMBER )
            isVerfied = false
        } else if zNSignUpInfo.mobileNumber.length > 15  {
            _ = AlertController.alert(BLANK,message: MAX_MOBILENUMBER)
            isVerfied = false
            
        } else if flag == false
        {           _ = AlertController.alert(BLANK,message: "Please accept terms and conditions.")
            isVerfied = false
        }
        return isVerfied
    }
    
    // MARK: - UIButton Actions
    @IBAction func buttonTap(sender: AnyObject) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -60
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show(BLANK, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.zNSignUpInfo.dob = dateFormatter.string( from: (dt))
                self.signUpTableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignUPClick(_ sender: Any) {
        self.view .endEditing(true)
        if  isallFieldsVerfield() {
            self.callApiMethodForSignUp()
        }
    }
    
    @IBAction func onSignUpImageClick(_ sender: UIButton) {
        self.view .endEditing(true)
        self.signUpImage.setTitleColor(UIColor.white, for: .normal)
        self.signUpImage.isUserInteractionEnabled = true
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.signUpImage.setImage(image, for: .normal)
            let imageData: NSData = UIImageJPEGRepresentation(image, 0.4)! as NSData
            zNSignUpInfo.profileImageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        signUpTableView.reloadData()
    }
    
    @IBAction func tcBtnAction(_ sender: UIButton) {
        self.view .endEditing(true)
        let vcObj = ZNTCViewController()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    @IBAction func tickButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            flag = true
        }
        else
        {
            flag = false
        }
        
    }
    
   //MARK: - WebService Method
    
    func callApiMethodForSignUp() -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[Kemail] = zNSignUpInfo.email
        paramDict[Kpassword] = zNSignUpInfo.password
        paramDict[KfirstName] = zNSignUpInfo.firstName
        paramDict[KLastName] = zNSignUpInfo.lastName
        paramDict[KPhoneNumber] = zNSignUpInfo.mobileNumber
        paramDict[Kdob] = zNSignUpInfo.dob
        paramDict[KProfileImage] = zNSignUpInfo.profileImageBase64
        paramDict[Kdevice_token] = UserDefaults.standard.value(forKey: Kdevice_token)
        paramDict[Kdevice_type] = "ios"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: false, apiName: KsignUp) { (result :AnyObject?, error :NSError?) in
            
            let response = result as! NSDictionary

            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    let userDict = response.validatedValue(KUserInfo, expected: NSDictionary())
                    UserDefaults.standard.set(userDict.validatedValue(KUser_Id, expected: "" as AnyObject), forKey: KUser_Id)
                    UserDefaults.standard.set(userDict.validatedValue(KApi_Key, expected: "" as AnyObject), forKey: KApi_Key)
                    UserDefaults.standard.synchronize()
                    
                    self.navigationController?.pushViewController(kAppDelegate.sideMenuController, animated: false)
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
