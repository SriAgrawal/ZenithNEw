//
//  ZNCardListViewController.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNCardListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var cardTableView: UITableView!
    var CardName : String = "Sbi"
    var cardNumber : String = "4111111111111111"
    var ExpiryDate : String = "06/2025"
    var selectedIndex : Int = 0

    @IBOutlet var labelMessage: UILabel!
    //var cardInfoArray = [ZNAddressListInfo]()
    var dataSourceArray = [Any]()
    var TotalPrice = NSString()
    var addressId = NSString()
    var orderArray = NSMutableArray()

    
    
    //MARK: - UIViewController Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

       self.initialMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.callApiMethodToGetCardList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    //MARK: - Helper Methods
    func initialMethod()
    {
       
        self.cardTableView.tableFooterView = UIView(frame: .zero)

        self.cardTableView.estimatedRowHeight  = 300
        
        self.cardTableView.register(UINib(nibName: "ZNSaveListTableViewCell",bundle: nil), forCellReuseIdentifier: "ZNSaveListTableViewCell")
        
    }
    
    //MARK: - UITableView Delegate and DataSource Methods

   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
    return self.dataSourceArray.count;
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNSaveListTableViewCell") as? ZNSaveListTableViewCell
        cell1?.selectionStyle = UITableViewCellSelectionStyle.none
        cell1?.editButton.isHidden = true
        cell1?.editButton?.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)

        
        cell1?.addressLabel.text =  "Name          :"
        cell1?.cityLabel.text =    "Card Expiry    :"
        cell1?.countryLabel.text = "Card Number :"
        
        let dataDict:ZNCardOnfo = (self.dataSourceArray[indexPath.row]as! ZNCardOnfo)

        cell1?.addressLabelInfo.text = dataDict.strName
        cell1?.cityLabelInfo.text =   dataDict.strCardRxpiryNumber
        cell1?.countryLabelInfo.text = dataDict.strCardNumber
        
        return cell1!
    }
    
   
    //MARK: - UITableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardInfo:ZNCardOnfo = (self.dataSourceArray[indexPath.row]as! ZNCardOnfo)
         let vcObj = ZNPaymentViewController()
        vcObj.TotalPrice = self.TotalPrice
        vcObj.orderArray = self.orderArray
        vcObj.addressId = self.addressId as NSString
        vcObj.objCardDetail = cardInfo
        self.navigationController?.pushViewController(vcObj, animated: true)
    }

    
    //MARK: - EditRow Methods
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let cardInfo:ZNCardOnfo = (self.dataSourceArray[indexPath.row]as! ZNCardOnfo)
            
            self.callApiMethodToDeleteCard(objCardDetail: cardInfo)
            selectedIndex = indexPath.row
           // cardTableView .reloadData()
        }
    }
    
    //MARK: UIButton Action
   
    @IBAction func editButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
         let vcObj = ZNAddCardViewController()
        self.navigationController?.pushViewController(vcObj, animated: true)
    
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: WebServiceApi Method

    func callApiMethodToGetCardList() -> Void {
        
        let paramDict = NSMutableDictionary()

        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .get, isToken: true, apiName: KCardList) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                
                    self.dataSourceArray .removeAll()
                    if let dict = response.object(forKey: "card_list") as? NSArray {
                        
                        for rowItem in dict as! Array<Dictionary<String,Any>>{
                            
                            self.dataSourceArray += [ZNCardOnfo .getCardInfo(responseDict:rowItem as Dictionary<String, AnyObject>)]
                        }
                        self.cardTableView.reloadData()
                    }
                    
                    if self.dataSourceArray.count == 0 {
                        self.labelMessage.isHidden  = false
                    }else {
                        self.labelMessage.isHidden  = true

                    }
                    
                    
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
    
    func callApiMethodToDeleteCard(objCardDetail: ZNCardOnfo) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KCardID] = objCardDetail.strCardID

        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KCardDelete) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.dataSourceArray .remove(at: self.selectedIndex)
                    self.cardTableView.reloadData()
                    
                    if self.dataSourceArray.count == 0 {
                        self.labelMessage.isHidden  = false
                    }else {
                        self.labelMessage.isHidden  = true
                        
                    }
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
    
    
    
    

}
