//
//  ZNEditProfileVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
class ZNEditProfileVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var zNEditInfo = ZNUserInfo()
    var editCredentialArray = [String]()
    var imagePicker =  UIImagePickerController()
    var flag = Bool()
    var base64Str = NSString()
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var editProfileTableView: UITableView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewLifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.editProfileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // For registereing nib
        self.editProfileTableView.register(UINib(nibName: "ZNSignUpTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNSignUpTableViewCell")
        editCredentialArray = ["First Name", "Last Name", "Email", "Mobile Number (Optional)", "DOB (Optional)"]
        viewHeightConstraint.constant = (window_width == 320) ? 330 : 370
        
        self.profileImage.sd_setImage(with: NSURL (string:zNEditInfo.profileImageBase64) as URL!, placeholderImage: UIImage(named:"userPlaceholder"), options: .refreshCached)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - table view delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZNSignUpTableViewCell") as? ZNSignUpTableViewCell
        cell?.signUpTextField.delegate = self
        cell?.signUpTextField.tag = indexPath.row + 100
        cell?.dobButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        cell?.dobButton.isHidden = true
        cell?.signUpTextField.autocapitalizationType = .none
        cell?.signUpImageView.backgroundColor = UIColor.white
        cell?.signUpLabel.isHidden = false
        
        if cell == nil{
            cell = ZNSignUpTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNSignUpTableViewCell")
        }
        
        cell?.signUpTextField.returnKeyType = .next
        cell?.signUpTextField.isUserInteractionEnabled = true
        
        switch indexPath.row {
        case 0:
            cell?.signUpTextField.keyboardType = .default
            cell?.signUpTextField.placeholder = editCredentialArray[indexPath.row]
            cell?.signUpTextField.autocapitalizationType = .words
            cell?.signUpTextField.text=zNEditInfo.firstName
            cell?.signUpImageView.image = UIImage(named: "firstname_Signup.png")
            break
        case 1:
            cell?.signUpTextField.keyboardType = .default
            cell?.signUpTextField.placeholder = editCredentialArray[indexPath.row]
            cell?.signUpTextField.autocapitalizationType = .words
            cell?.signUpTextField.text=zNEditInfo.lastName
            cell?.signUpImageView.image = UIImage(named: "lastname_Signup.png")
            
            break
        case 2:
            cell?.signUpTextField.isUserInteractionEnabled = false
            cell?.signUpTextField.keyboardType = .emailAddress
            cell?.signUpTextField.placeholder = editCredentialArray[indexPath.row]
            cell?.signUpTextField.text=zNEditInfo.email
            cell?.signUpImageView.image = UIImage(named: "email_Signup.png")
            break
        case 3:
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 103
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell?.signUpTextField.inputAccessoryView = toolbar
            cell?.signUpTextField.placeholder = editCredentialArray[indexPath.row]
            cell?.signUpTextField.keyboardType = .numberPad
            cell?.signUpTextField.text=zNEditInfo.mobileNumber
            cell?.signUpImageView.image = UIImage(named: "call_Signup.png")
            
            break
        case 4:
            cell?.signUpTextField.placeholder = editCredentialArray[indexPath.row]
            cell?.signUpTextField.autocapitalizationType = .words
            cell?.signUpTextField.text=zNEditInfo.dob
            cell?.dobButton.isHidden = false
            cell?.signUpTextField.isUserInteractionEnabled=false
            cell?.signUpImageView.image = UIImage(named: "DOB_Signup.png")
            cell?.signUpLabel.isHidden = true
            
            break
        default:
            break
        }
        cell?.signUpTextField.attributedPlaceholder = NSAttributedString(string:cell?.signUpTextField.placeholder != nil ? (cell?.signUpTextField.placeholder!)! : "", attributes: [NSForegroundColorAttributeName : UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)])
        
        if indexPath.row == 3 {
            let stringAttributed = NSMutableAttributedString.init(string: "Mobile Number (Optional)")
            let font = UIFont(name: "ITCKabelStd-Book", size: 12.0)
            stringAttributed.addAttribute(NSFontAttributeName, value:font!, range: NSRange.init(location: 14, length: 10))
            stringAttributed.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0), range: NSRange.init(location: 0, length: "Mobile Number (Optional)".length))
            cell?.signUpTextField.attributedPlaceholder = stringAttributed
            
        }
            
        else if indexPath.row == 4{
            
            let stringAttributed = NSMutableAttributedString.init(string: "DOB (Optional)")
            let font = UIFont(name: "ITCKabelStd-Book", size: 12.0)
            stringAttributed.addAttribute(NSFontAttributeName, value:font!, range: NSRange.init(location: 4, length: 10))
            stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0), range: NSRange.init(location: 0, length: "DOB (Optional)".length))
            cell?.signUpTextField.attributedPlaceholder = stringAttributed
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58.0
    }
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.length == 0
        {
            return true
        }
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 100, 101:
            if string.isValidName() == true
            {
                if (textField.text?.length)! >= 30 || string.length == 0 {
                    return false
                }
                return true
            }else {
                return false
            }
            
        case 103:
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
        if textField.returnKeyType == .next
        {
            if(textField.tag == 104)
            {
                self.buttonTap(sender: UIButton())
            }
            else if(textField.tag == 101){
                self.editProfileTableView .viewWithTag(103)?.becomeFirstResponder()
            }
            self.editProfileTableView .viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view .layoutIfNeeded()
        
        switch textField.tag {
        case 100:
            zNEditInfo.firstName = textField.text!
            break
        case 101:
            zNEditInfo.lastName = textField.text!
            break
        case 103:
            zNEditInfo.mobileNumber = textField.text!
            break
        default:
            break
        }
    }
    
    // MARK: - TextField Validations
    
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        
        if zNEditInfo.profileImageBase64.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_IMAGE)
            isVerfied = false
        }
        else if zNEditInfo.firstName.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_FIRSTNAME)
            isVerfied = false
        }else  if zNEditInfo.firstName.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_FIRSTNAME)
            isVerfied = false
        }else if zNEditInfo.firstName.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_FIRSTNAME)
            isVerfied = false
        }else if zNEditInfo.lastName.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_LASTNAME)
            isVerfied = false
        }else  if zNEditInfo.lastName.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_LASTNAME)
            isVerfied = false
        }else if zNEditInfo.lastName.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_LASTNAME)
            isVerfied = false
        }else if zNEditInfo.mobileNumber.length != 0 && zNEditInfo.mobileNumber.length < 7 {
            _ = AlertController.alert(BLANK,message: MINI_MOBILENUMBER)
            isVerfied = false
        }else if zNEditInfo.mobileNumber.length > 15  {
            _ = AlertController.alert(BLANK,message: MAX_MOBILENUMBER)
            isVerfied = false
        }
        return isVerfied
    }
    
    //MARK: - UIButton Action Method
    @IBAction func buttonTap(sender: AnyObject) {
        self.view .endEditing(true)
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -60
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show("", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.zNEditInfo.dob = dateFormatter.string( from: (dt))
                self.editProfileTableView.reloadData()
            }
        }
    }
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        self.view .endEditing(true)
        self.editProfileButton.setTitleColor(UIColor.white, for: .normal)
        self.editProfileButton.isUserInteractionEnabled = true
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
            // self.editProfileButton.setImage(image, for: .normal)
            self.profileImage.image = image
            let imageData: NSData = UIImageJPEGRepresentation(image, 0.4)! as NSData
            base64Str = imageData.base64EncodedString(options: .lineLength64Characters) as NSString
            zNEditInfo.profileImageBase64 = (imageData.base64EncodedString(options: .lineLength64Characters) as NSString) as String
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        editProfileTableView.reloadData()
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        self.view .endEditing(true)
        if  isallFieldsVerfield() {
            //self.navigationController?.popViewController(animated: true)
                        self.callApiMethodToEditProfile()
            
        }
    }
    
    @IBAction func onMenuClick(_ sender: UIButton) {
        self.view .endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
        //MARK: - WebService Method
    
        func callApiMethodToEditProfile() -> Void {
    
            let paramDict = NSMutableDictionary()
            paramDict[KfirstName] = zNEditInfo.firstName
            paramDict[KLastName] = zNEditInfo.lastName
            paramDict[KPhoneNumber] = zNEditInfo.mobileNumber
            paramDict[Kdob] = zNEditInfo.dob
            paramDict[KProfileImage] = base64Str
    
            ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "update_profile") { (result :AnyObject?, error :NSError?) in
    
                if error == nil {
                    let response = result as! NSDictionary
                    
                    if Int(response.object(forKey: KresponseCode) as! String) == 200 {
    
                        _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
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
