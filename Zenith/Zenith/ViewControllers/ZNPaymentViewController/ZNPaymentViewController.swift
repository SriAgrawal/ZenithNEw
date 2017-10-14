//
//  ZNPaymentViewController.swift
//  Zenith
//
//  Created by Ankit Kumar Gupta on 24/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import Stripe

class ZNPaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var objCardDetail = ZNCardOnfo()
    
    var expiryMonth = String()
    var expiryYear = String()
    var clientTokenData = String()
    
    var TotalPrice = NSString()
    var brainTreeId = NSString()
    var nounce = String()
    var addressId = NSString()
    var orderArray = NSMutableArray()

    @IBOutlet var paymentTableView: UITableView!
    
    
    //MARK:- UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.paymentTableView.register(UINib(nibName: "ZNAddCardTableViewCell", bundle: nil),forCellReuseIdentifier:"ZNAddCardTableViewCell")
        customInit()
    }
    
    //MARK:- Helper Methods
    func customInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //self.callApiMethodToGetClientToken()
    }
    
    
    
    //MARK:- UITableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNAddCardTableViewCell", for: indexPath) as! ZNAddCardTableViewCell
        cell.cardDetailTextField.isSecureTextEntry = false
        cell.cardDetailButton.isHidden = true
        cell.cardDetailTextField.isUserInteractionEnabled = false
        cell.cardDetailTextField.delegate = self
        cell.cardDetailTextField.tag = indexPath.row + 100
        cell.cardDetailButton.tag = indexPath.row + 500
        
        if indexPath.row == 0 {
            
            cell.cardDetailTitleLabel.text = "Card Number"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "XXXX XXXX XXXX 1234",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.returnKeyType = UIReturnKeyType.next
            cell.cardDetailTextField.text = objCardDetail.strCardNumber
            cell.cardDetailTextField.keyboardType = UIKeyboardType.numberPad
        } else if indexPath.row == 2 {
            
            cell.cardDetailTitleLabel.text = "CVV Number"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "XXXX",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.text = objCardDetail.strCVVNumber
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackTranslucent
            toolbar.sizeToFit()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.dismissKeyboard))
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
            doneButton.tag = 3001
            let itemsArray: [Any] = [flexSpace, flexSpace, doneButton]
            toolbar.items = itemsArray as? [UIBarButtonItem]
            cell.cardDetailTextField.inputAccessoryView = toolbar
            cell.cardDetailTextField.keyboardType = UIKeyboardType.phonePad
            cell.cardDetailTextField.isSecureTextEntry = true
            cell.cardDetailTextField.isUserInteractionEnabled = true
        }
            
        else{
            cell.cardDetailTitleLabel.text = "Expiry Date"
            cell.cardDetailTextField.attributedPlaceholder = NSAttributedString(string: "MM/YYYY",attributes: [NSForegroundColorAttributeName: UIColor.gray])
            cell.cardDetailTextField.text = objCardDetail.strCardRxpiryNumber
        }
        return cell
    }
    
    
    
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
        if textField.tag == 102 {
            objCardDetail.strCVVNumber = str as String
        }
        
        if textField.tag == 102 && str.length > 4 {
            return false
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
    }
    
    
    //MARK:- Validation Method
    func isAllFieldsVerified() -> Bool {
        var fieldVerified: Bool = false
        if (self.objCardDetail.strCVVNumber.trimWhiteSpace().length == 0) {
            presentAlert("", msgStr: "Please enter cvv.", controller: self)
        } else if (self.objCardDetail.strCVVNumber.trimWhiteSpace().length < 3) {
            presentAlert("", msgStr: "Please enter valid cvv.", controller: self)
        }  else {
            fieldVerified = true
        }
        return fieldVerified
    }
    
    
    // MARK: - UIButton Actions Methods
    
    @IBAction func payButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if isAllFieldsVerified(){
            
            hideAllHuds(false)
            
            var expDate: [Any] = objCardDetail.strCardRxpiryNumber.components(separatedBy: "/").flatMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            
            let expMonth: Int = expDate[0] as! Int
            let expYear: Int = expDate[1] as! Int
            let stripeCard = STPCardParams()
            stripeCard.number = self.objCardDetail.strCardNumber
            stripeCard.expMonth = UInt(expMonth)
            stripeCard.expYear = UInt(expYear)
            print("\(stripeCard.expMonth),\(stripeCard.expYear)")
            stripeCard.cvc = self.objCardDetail.strCVVNumber
            
            //test key pk_test_3f49uPxVhQpnbpjYTxMsL2b7
            //live key pk_live_LCx2rXEzBQU00XDbbKSHKeIG
            
            let stripeCardClient = STPAPIClient.init(publishableKey: "pk_test_3f49uPxVhQpnbpjYTxMsL2b7")
            stripeCardClient.createToken(withCard: stripeCard, completion: { (token, error) in
                if !(error != nil){
                self.nounce = (token?.tokenId)!
                self.hideAllHuds(true)
                self.callApiMethodToConfirmOrder()
                }
                else{
                    self.hideAllHuds(true)
                    _ = AlertController.alert("", message: (error?.localizedDescription)!)
                }
            })
        }
    }

    
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    func callApiMethodToConfirmOrder() -> Void {
        
        let paramDict = getParameterForOrder()
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KSavedOrder) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                        let vcObj = ZNThanksVC()
                        let thankYouObj = ZNThankYou()
                        thankYouObj.transactionId = response.validatedValue("transactionId", expected: "" as AnyObject) as! String
                        thankYouObj.helpString = response.validatedValue(KHelpNumber, expected: "" as AnyObject) as! String
                        vcObj.thankObj = thankYouObj
                        vcObj.thanksType = ZNThanksType.product
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
    
    func getParameterForOrder() -> NSMutableDictionary {
        let paramDic = NSMutableDictionary()
        let dishArray = NSMutableArray()
        paramDic[KStore_Id] = UserDefaults.standard.string(forKey: KStore_Id)
        paramDic[KBrainTreeId] = ""
        paramDic[KAddress_Id] = self.addressId
        paramDic["total_price"] = self.TotalPrice
        paramDic["nonce"] = self.nounce
        for productObj in orderArray {
            let obj = productObj as! ZNCategoryInfo
            let innerDic = NSMutableDictionary()
            innerDic["product_category_id"] = obj.categoryID
            for innerObj in obj.dishArray {
                let innerObject = innerObj as! ZNDishInfo
                innerDic[KProductId] = innerObject.dishID
                innerDic[KDishName] = innerObject.dishName
                innerDic[KProductQuantity] = innerObject.dishCount
                innerDic["total_price"] = innerObject.dishPrice
                innerDic["special_instruction"] = innerObject.specialIngrediant
                dishArray.add(innerDic)
            }
        }
        paramDic["product_list"] = dishArray
        return paramDic
    }

   //Helper Method for Hud

    private func hideAllHuds(_ status:Bool) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = !status
        
        DispatchQueue.main.async(execute: {
            var hud = MBProgressHUD(for: kAppDelegate.window!)
            if hud == nil {
                hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
            }
            hud?.cornerRadius = 8.0
            hud?.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            hud?.margin = 12
            if (status == false) {
                hud?.show(animated: true)
            } else {
                hud?.hide(animated: true)
            }
        })
    }
    
    // MARK: - Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
