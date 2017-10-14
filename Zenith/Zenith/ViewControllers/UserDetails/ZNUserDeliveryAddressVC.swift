//
//  ZNUserShippingDetailVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNUserDeliveryAddressVC: UIViewController ,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    var userDetailArray = [String]()
    var countryArray = [String]()
    var zNUserDetailInfo = ZNUserInfo()
    var addressId = String()
    var isFromEdit = Bool()
    
    
    @IBOutlet var navigationBarTitle: UILabel!
    @IBOutlet var userDeliveryTitleLabel: UILabel!
    @IBOutlet var footerView: UIView!
    @IBOutlet var userDeliveryAddressTableView: UITableView!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDialingCode()
        if isFromEdit {
            callApiMethodToGetAddressDetail()
        }
        self.initMethod()
    }
    
    // MARK: - Helper methods
    func initMethod() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        userDetailArray = ["Name","Address","Post Code","LandMark(Optional)","Country","Phone Number"]
        self.userDeliveryAddressTableView.tableFooterView = footerView
        // For registereing nib
        self.userDeliveryAddressTableView.register(UINib(nibName: "ZNUserShippingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNUserShippingDetailTableViewCell")
        
        if UIScreen.main.bounds.width == 320 {
            leadingConstraint.constant = 23
            trailingConstraint.constant = 23
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - table view delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZNUserShippingDetailTableViewCell") as? ZNUserShippingDetailTableViewCell
        cell?.userDetailTextField.delegate = self
        cell?.userDetailTextField.tag = indexPath.row + 100
        cell?.userDetailTextField.autocapitalizationType = .none
        cell?.userDetailTextField.returnKeyType = .next
        cell?.userDetailTextField.isUserInteractionEnabled = true
        if cell == nil{
            cell = ZNUserShippingDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNUserShippingDetailTableViewCell")
        }
        
        if UIScreen.main.bounds.width == 320 {
            cell?.leadingConstraint.constant = 0
            cell?.trailingConstraint.constant = 0
        }
        
        switch indexPath.row {
        case 0:
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            cell?.userDetailTextField.autocapitalizationType = .words
            cell?.userDetailTextField.text=zNUserDetailInfo.name
            cell?.userDetailImageView.image = UIImage(named: "profileIcon.png")
            break
        case 1:
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            cell?.userDetailTextField.text=zNUserDetailInfo.address
            cell?.userDetailImageView.image = UIImage(named: "address.png" )
            break
        case 2:
            cell?.userDetailTextField.keyboardType = .namePhonePad
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            cell?.userDetailTextField.text=zNUserDetailInfo.postcode
            cell?.userDetailImageView.image = UIImage(named: "pincodeIcon.png")
            break
        case 3:
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            cell?.userDetailTextField.text = zNUserDetailInfo.landmark
            cell?.userDetailImageView.image = UIImage(named: "landmark.png" )
            break
        case 4:
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            cell?.userDetailTextField.text = zNUserDetailInfo.country
            cell?.userDetailImageView.image = UIImage(named: "country.png")
            break
        case 5:
            cell?.userDetailTextField.keyboardType = .numberPad
            cell?.userDetailTextField.text=zNUserDetailInfo.mobileNumber
            cell?.userDetailTextField.placeholder = userDetailArray[indexPath.row]
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 3001
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell?.userDetailTextField.inputAccessoryView = toolbar
            cell?.userDetailImageView.image = UIImage(named: "phoneNumber.png")
            
        default:
            break
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 100:
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
        
        case 101:
            if  (textField.text?.length)! >= 64 {
                return false
            }
            break
            
        case 102:
            if  (textField.text?.length)! >= 6 && range.length == 0{
                return false
            }
            break
            
        case 103:
            if  (textField.text?.length)! >= 64 {
                return false
            }
            break
            
        case 104:
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
            self.userDeliveryAddressTableView .viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 104 {
            view.endEditing(true)
            OptionPickerManager().showOptionPickerSelectedIndex(-1, withData: countryArray) { (selectedIndex, selectedItems) in
                self.zNUserDetailInfo.country = (selectedItems?.first as? String)!
                self.userDeliveryAddressTableView.reloadData()
            }
            return false
        }
        return true
    }
    
    
    func getDialingCode() {
        let strBundle: String = Bundle.main.path(forResource: "CountryCodeList", ofType: "csv")!
        let fileObj = try? String(contentsOfFile: strBundle, encoding: String.Encoding.utf8)
        let rows: [String]? = fileObj?.components(separatedBy: "\n")
        if (rows?.count)! > 1 {
            for row: String in rows! {
                let columns: [Any] = row.components(separatedBy: ",")
                if columns.count > 2 {
                    countryArray.append(columns[0] as! String)

                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view .layoutIfNeeded()
        switch textField.tag {
        case 100:
            zNUserDetailInfo.name = textField.text!
            break
        case 101:
            zNUserDetailInfo.address = textField.text!
            break
        case 102:
            zNUserDetailInfo.postcode = textField.text!
            break
        case 103:
            zNUserDetailInfo.landmark = textField.text!
            break
        case 104:
            zNUserDetailInfo.country = textField.text!
            break
        case 105:
            zNUserDetailInfo.mobileNumber = textField.text!
            break
            
        default:
            break
        }
    }
    
    // MARK: - TextField Validations
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        
        if zNUserDetailInfo.name.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_NAME)
            isVerfied = false
        } else  if zNUserDetailInfo.name.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_NAME)
            isVerfied = false
        } else if zNUserDetailInfo.name.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_NAME)
            isVerfied = false
        } else if zNUserDetailInfo.address.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_ADDRESS)
            isVerfied = false
        } else if zNUserDetailInfo.postcode.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_POSTCODE)
            isVerfied = false
        } else if zNUserDetailInfo.postcode.trimWhiteSpace().length < 6 {
            _ = AlertController.alert(BLANK,message: MIN_POSTCODE)
            isVerfied = false
        } else if zNUserDetailInfo.country.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_COUNTRY)
            isVerfied = false
        } else if zNUserDetailInfo.mobileNumber.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_MOBILENUMBER)
            isVerfied = false
        }else if zNUserDetailInfo.mobileNumber.length < 7  {
            _ = AlertController.alert(BLANK,message: MINI_MOBILENUMBER )
            isVerfied = false
        } else if zNUserDetailInfo.mobileNumber.length > 15  {
            _ = AlertController.alert(BLANK,message: MAX_MOBILENUMBER)
            isVerfied = false
        }
        return isVerfied
    }
    
    // MARK: - UIButton Actions.
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func SubmitButtonClick(_ sender: UIButton) {
        self.view .endEditing(true)
        if  isallFieldsVerfield() {
            if isFromEdit {
                self.callApiMethodToUpdateAddress()
            }else{
                self.callApiMethodToSaveAddress()
            }
        }
    }
    
    func callApiMethodToSaveAddress() {
        let paramDict = NSMutableDictionary()
        paramDict[KAddress] = zNUserDetailInfo.address
        paramDict[KName] = zNUserDetailInfo.name
        paramDict[KPhoneNumber] = zNUserDetailInfo.mobileNumber
        paramDict[Kcountry] = zNUserDetailInfo.country
        paramDict[Kpostcode] = zNUserDetailInfo.postcode
        paramDict["landmark"] = zNUserDetailInfo.landmark
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "save_delivery_address") { (result :AnyObject?, error :NSError?) in
            let response = result as! NSDictionary
            
            if error == nil {
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
                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
            }
        }
    }
    
    
    func callApiMethodToGetAddressDetail() {

        let paramDict = NSMutableDictionary()
        let apiName = "get_delivery_address/address_id/\(self.addressId)"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .get, isToken: true, apiName: apiName) { (result :AnyObject?, error :NSError?) in
            let response = result as! NSDictionary
            
            if error == nil {
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    if let dict = response.object(forKey: "deliver_address_detail") as? Dictionary<String, AnyObject> {
                        self.zNUserDetailInfo = ZNUserInfo.getDataOfAddress(userInfo: dict)
                    }
                    self.userDeliveryAddressTableView.reloadData()
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
    func callApiMethodToUpdateAddress() {
        let paramDict = NSMutableDictionary()
        paramDict[KAddress_Id] = self.addressId
        paramDict[KAddress] = zNUserDetailInfo.address
        paramDict[KName] = zNUserDetailInfo.name
        paramDict[KPhoneNumber] = zNUserDetailInfo.mobileNumber
        paramDict[Kcountry] = zNUserDetailInfo.country
        paramDict[Kpostcode] = zNUserDetailInfo.postcode
        paramDict["landmark"] = zNUserDetailInfo.landmark
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "update_delivery_address") { (result :AnyObject?, error :NSError?) in
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
