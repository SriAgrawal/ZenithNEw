 //
//  ZNAddCardViewController.swift
//  Zenith
//
//  Created by Ankit Kumar Gupta on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
 
class ZNAddCardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var objCardDetail = ZNCardOnfo()
    
    var expiryMonth = String()
    var expiryYear = String()



    @IBOutlet var userDeliveryAddressTableView: UITableView!
    @IBOutlet var pickerBackgroundView: UIView!
    @IBOutlet var pickerView: MonthYearPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userDeliveryAddressTableView.register(UINib(nibName: "ZNAddCardTableViewCell", bundle: nil),forCellReuseIdentifier:"ZNAddCardTableViewCell")
        customInit()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    //MARK:- Helper Methods
    func customInit() {
        
        
        pickerBackgroundView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
        pickerBackgroundView.isHidden = true
    }
    
    
    //MARK:- UITableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNAddCardTableViewCell", for: indexPath) as! ZNAddCardTableViewCell
        
       // if cell == nil{
        //    cell = ZNAddCardTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNAddCardTableViewCell")
      //  }
        cell.cardDetailTextField.isSecureTextEntry = false

        cell.cardDetailTextField.isSecureTextEntry = false
        cell.cardDetailTextField.delegate = self as? UITextFieldDelegate
        cell.cardDetailButton.addTarget(self, action:#selector(self.showPicker(sender:)), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.cardDetailTextField.tag = indexPath.row + 100
            cell.cardDetailButton.tag = indexPath.row + 500

            cell.cardDetailTitleLabel.text = "Card Number"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "XXXX XXXX XXXX 1234",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.returnKeyType = UIReturnKeyType.next
            cell.cardDetailTextField.text = objCardDetail.strCardNumber
            cell.cardDetailTextField.keyboardType = UIKeyboardType.numberPad
            
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 3002
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell.cardDetailTextField.inputAccessoryView = toolbar
            
            cell.cardDetailButton.isHidden = true
            cell.cardDetailTextField.isUserInteractionEnabled = true
            
        } else if indexPath.row == 2 {
            cell.cardDetailTextField.tag = indexPath.row + 100
            cell.cardDetailButton.tag = indexPath.row + 500

            cell.cardDetailTitleLabel.text = "Name"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "Name",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.returnKeyType = UIReturnKeyType.done
            cell.cardDetailTextField.text = objCardDetail.strName

            cell.cardDetailTextField.keyboardType = UIKeyboardType.asciiCapable
            cell.cardDetailButton.isHidden = true
            cell.cardDetailTextField.isUserInteractionEnabled = true
            
        }
        
        else{
            cell.cardDetailTextField.tag = indexPath.row + 100
            cell.cardDetailButton.tag = indexPath.row + 500

            cell.cardDetailTitleLabel.text = "Expiry Date"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "MM/YYYY",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.text = objCardDetail.strCardRxpiryNumber
            cell.cardDetailButton.isHidden = false
            cell.cardDetailTextField.isUserInteractionEnabled = false
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }

  
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextField Delegate Methods
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField.isFirstResponder {
            if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
                return false
            }
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        if textField.tag == 100 {
            
            if str.length>16 {
                return false
            }else{
                objCardDetail.strCardNumber = str as String
                return true
            }
            
        }else if textField.tag == 102  {
            
            if str.length > 30 {
                return false

            }else {
                objCardDetail.strName = str as String
                return true

            }
        }
        else{
            return true
        }
        
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerBackgroundView.isHidden = true
    }
    
    
    //MARK:- Validation Method
    func isAllFieldsVerified() -> Bool {
        var fieldVerified: Bool = false
        if (self.objCardDetail.strCardNumber.trimWhiteSpace().length == 0) {
            presentAlert("", msgStr: "Please enter card number.", controller: self)
        } else if (self.objCardDetail.strCardNumber.trimWhiteSpace().length < 16) {
            presentAlert("", msgStr: "Please enter valid card number.", controller: self)
        } else if (!self.objCardDetail.strCardNumber.containsNumberOnly() ) {
            presentAlert("", msgStr: "Please enter valid card number.", controller: self)
        } else if (self.objCardDetail.strCardRxpiryNumber.trimWhiteSpace().length == 0) {
            presentAlert("", msgStr: "Please enter expiry date.", controller: self)
        } else if (self.objCardDetail.strName.trimWhiteSpace().length == 0) {
            presentAlert("", msgStr: "Please enter name.", controller: self)
        } else {
            fieldVerified = true
        }
        return fieldVerified
    }
    
    func isvalidExpiryDate()  -> Bool{
        
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        
        var dateValid: Bool = false
        if pickerView.year ==  currentYear {
            if pickerView.month < currentMonth{
                dateValid = false
            }else{
                dateValid = true
            }
        } else {
            dateValid = true
        }
        return dateValid
    }
    
    
    // MARK: - Button Add Target Action Method
    func showPicker(sender:UIButton) {
        self.view.endEditing(true)
        if sender.tag == 501 {
            pickerBackgroundView.isHidden = false
        }
    }
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        pickerBackgroundView.isHidden = true
        if isAllFieldsVerified(){
            var expDate: [Any] = objCardDetail.strCardRxpiryNumber.components(separatedBy: "/")
            self.expiryMonth = expDate[0] as? String ?? ""
            self.expiryYear = "\(expDate[1] as? String ?? "")"
            
            self.callApiMethodToAddCard()
            
        }
    }
    
    @IBAction func pickerViewDoneButtonAction(_ sender: Any){
        
        if  pickerView.month != 0 && pickerView.year != 00{
            
            if isvalidExpiryDate(){
                pickerBackgroundView.isHidden = true
                objCardDetail.strCardRxpiryNumber   = String(format: "%02d/%d", pickerView.month, pickerView.year)
                self.userDeliveryAddressTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func pickerViewCancelButtonAction(_ sender: Any){
        pickerBackgroundView.isHidden = true
    }
    
    // MARK: - UIButton Actions.
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func callApiMethodToAddCard() -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[KCardNumber] = AESCrypt.encrypt(objCardDetail.strCardNumber, password:KEncryptionKey)
        paramDict[KCardExpiryMonth] = AESCrypt.encrypt(self.expiryMonth, password: KEncryptionKey)
        paramDict[KCardExpiryYear] = AESCrypt.encrypt(self.expiryYear, password: KEncryptionKey)
        paramDict[KCardType] = ""
        paramDict[KCardNameHolder] = objCardDetail.strName

        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KSaveCard) { (result :AnyObject?, error :NSError?) in

            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
               
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String, acceptMessage: "OK", acceptBlock: {
                        
                        self.navigationController?.popViewController(animated: true)
                    })

                }
                else {
                    //_ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                 _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
