//
//  ZNBookAppointmentVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNBookAppointmentVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var appointmentInfo = ZNUserInfo()
    var thankObj = ZNThankYou()
    var storeId = NSString()
    var array = [String]()
    var countryArray = [String]()
    var sortedArray = [String]()
    
    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var btnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var navTitle: UILabel!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        appointmentTableView.tableFooterView = footerView
        self.getDialingCode()
        //register cell
        self.appointmentTableView.register(UINib(nibName:"ZNLoginTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNLoginTableViewCell")
        
        if UIScreen.main.bounds.width == 320 {
            btnLeadingConstraint.constant = 23
            btnTrailingConstraint.constant = 23
            navTitle.font = UIFont.textMediumFont(fontSize: 16)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITableView DataSource and Delegate Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ZNLoginTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZNLoginTableViewCell", for: indexPath) as! ZNLoginTableViewCell
        
        cell.loginTextField.delegate = self as UITextFieldDelegate
        cell.loginTextField.tag = indexPath.row + 100
        cell.loginTextField.autocapitalizationType = .none
        cell.dateBookinBtn.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        cell.loginTextField.returnKeyType = .next
        cell.loginTextField.isSecureTextEntry = false
        cell.dateBookinBtn.isHidden = true
        
        cell.loginImageView.layer.cornerRadius = cell.loginImageView.frame.size.height / 2
        cell.loginImageView.clipsToBounds = true
        cell.selectionStyle = .none
        
        //Setting cell view constraints
        if UIScreen.main.bounds.width == 320 {
            cell.leadingConstraintOutlet.constant = 23
            cell.trailingConstraintOutlet.constant = 23
        }
        
        switch indexPath.row {
        case 0:
            cell.loginTextField.keyboardType = .alphabet
            cell.loginTextField.placeholder = "Name"
            cell.loginImageView.image = UIImage(named: "profileIcon")
            cell.loginTextField.autocapitalizationType = .words
            cell.loginTextField.text=appointmentInfo.name
            break
        case 1:
            cell.loginTextField.keyboardType = .default
            cell.loginTextField.placeholder = "Address"
            cell.loginImageView.image = UIImage(named: "address")
            cell.loginTextField.text = appointmentInfo.address
            break
        case 2:
            cell.loginTextField.keyboardType = .namePhonePad
            cell.loginTextField.placeholder = "Post Code"
            cell.loginImageView.image = UIImage(named: "pincodeIcon")
            cell.loginTextField.text = appointmentInfo.pincode
            break
        case 3:
            cell.loginTextField.placeholder = "Country"
            cell.loginImageView.image = UIImage(named: "country")
            cell.loginTextField.text = appointmentInfo.country
            break
        case 4:
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 3002
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell.loginTextField.inputAccessoryView = toolbar
            
            cell.loginTextField.placeholder = "Phone Number"
            cell.loginImageView.image = UIImage(named: "phoneNumber")
            cell.loginTextField.keyboardType = .numberPad
            cell.loginTextField.text=appointmentInfo.mobileNumber
            break
        case 5:
            cell.loginTextField.keyboardType = .alphabet
            cell.loginTextField.placeholder = "Description"
            cell.loginImageView.image = UIImage(named: "field_icon7")
            cell.loginTextField.autocapitalizationType = .words
            cell.loginTextField.text=appointmentInfo.bodyMassage
            break
        case 6:
            cell.loginTextField.placeholder = "Date of Booking"
            cell.loginImageView.image = UIImage(named: "field_icon8")
            cell.loginTextField.text=appointmentInfo.dateOfBooking
            break
            
        default:
            break
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    //MARK:- UITextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 100:
            if string.length == 0 {
                return true
            }
            if string.isValidName() == true
            {
                if (textField.text?.length)! >= 30 {
                    return false
                }
                return true
            }   else{
                return false
            }
            
        case 101:
            if  (textField.text?.length)! >= 101 {
                return false
            }
        case 102:
            if  (textField.text?.length)! >= 6 && range.length == 0{
                return false
            }
        case 103:
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
            
        case 104:
            if (str.length == 1) &&  (str == "0") {
                return false
            }
            if  (textField.text?.length)! >= 12 && range.length == 0 {
                return false
            }
        case 105:
            if string.isValidName() == true
            {
                if (textField.text?.length)! >= 64 {
                    return false
                }
                return true
            }
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            self.appointmentTableView .viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 103 {
            view.endEditing(true)
            OptionPickerManager().showOptionPickerSelectedIndex(-1, withData: sortedArray) { (selectedIndex, selectedItems) in
                self.appointmentInfo.country = (selectedItems?.first as? String)!
                self.appointmentTableView.reloadData()
            }
            return false
        }
        else if textField.tag == 106{
           datePicker()
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
        
        sortedArray = countryArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.view .layoutIfNeeded()
        switch textField.tag {
        case 100:
            appointmentInfo.name = textField.text!
            break
        case 101:
            appointmentInfo.address = textField.text!
            break
        case 102:
            appointmentInfo.pincode = textField.text!
            break
        case 104:
            appointmentInfo.mobileNumber = textField.text!
            break
        case 105:
            appointmentInfo.bodyMassage = textField.text!
        default:
            break
        }
    }
    
    // MARK: - TextField Validations
    func isallFieldsVerfield() -> Bool {
        var isVerfied = true
        
        if appointmentInfo.name.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK,message: BLANK_NAME)
            isVerfied = false
        } else  if appointmentInfo.name.trimWhiteSpace().length < 2 {
            _ = AlertController.alert(BLANK,message: MINI_NAME)
            isVerfied = false
        } else if appointmentInfo.name.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_NAME)
            isVerfied = false
        } else if appointmentInfo.address.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_ADDRESS)
            isVerfied = false
        } else if appointmentInfo.address.trimWhiteSpace().length > 140 {
            _ = AlertController.alert(BLANK, message: MAX_ADDRESS)
            isVerfied = false
        } else if appointmentInfo.pincode.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_POSTCODE)
            isVerfied = false
        } else if appointmentInfo.pincode.length < 6 {
            _ = AlertController.alert(BLANK, message: MIN_POSTCODE)
            isVerfied = false
        } else if appointmentInfo.country.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_COUNTRY)
            isVerfied = false
        }else if appointmentInfo.mobileNumber.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_MOBILENUMBER)
            isVerfied = false
        } else if appointmentInfo.mobileNumber.length < 7  {
            _ = AlertController.alert(BLANK,message: MINI_MOBILENUMBER )
            isVerfied = false
        } else if appointmentInfo.mobileNumber.length > 15  {
            _ = AlertController.alert(BLANK,message: MAX_MOBILENUMBER)
            isVerfied = false
        } else if appointmentInfo.bodyMassage.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_SERVICE)
            isVerfied = false
        } else if appointmentInfo.bodyMassage.isValidName() == false {
            _ = AlertController.alert(BLANK,message: VALID_BODY_MASSAGE)
            isVerfied = false
        } else if appointmentInfo.dateOfBooking.trimWhiteSpace().length == 0 {
            _ = AlertController.alert(BLANK, message: BLANK_DATE_BOOK)
            isVerfied = false
        }
        return isVerfied
    }
    
    //MARK: - UIButon Action Method
    
    func datePicker() -> Void  {
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        components.year = 100
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        DatePickerDialog().show(BLANK, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: currentDate as Date, maximumDate: maxDate as Date, datePickerMode: .date) { (date) in
            if let dt = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.appointmentInfo.dateOfBooking = dateFormatter.string( from: (dt))
                self.appointmentTableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonTap(sender: AnyObject) {
      
       
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isallFieldsVerfield() == true {
        
            callApiMethodToBookAnAppointment()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }

    
    //MARK: - WebService Method
    
    func callApiMethodToBookAnAppointment() {
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeId
        paramDict[KAddress] = appointmentInfo.address
        paramDict[KBookDate] = ZNUtility.getTimeStampFromDate(appointmentInfo.dateOfBooking)
        paramDict[KName] = appointmentInfo.name
        paramDict[KPhoneNumber] = appointmentInfo.mobileNumber
        paramDict[Kcountry] = appointmentInfo.country
        paramDict[Kpostcode] = appointmentInfo.pincode
        paramDict[KDescription] = appointmentInfo.bodyMassage
        
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "appointment_booking") { (result :AnyObject?, error :NSError?) in
            if error == nil {
                 let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                self.thankObj = ZNThankYou.getThankAppointmentData(responseDict: response.validatedValue("booking_detail", expected:NSDictionary() as AnyObject) as? Dictionary<String, AnyObject>)

                    _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                        let vcObj = ZNThanksVC()
                        vcObj.thankObj = self.thankObj
                        self.navigationController?.pushViewController(vcObj, animated: true)
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


