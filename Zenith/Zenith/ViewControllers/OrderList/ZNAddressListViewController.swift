//
//  ZNAddressListViewController.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 21/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNAddressListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var addressListTableView: UITableView!

    var addressInfoArray = [ZNAddressListInfo]()
    var TotalPrice = NSString()
    var orderArray = NSMutableArray()
    
    //MARK: viewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    self.initialMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApiMethodToGetAddressList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
 //MARK: Helper Method
func initialMethod()
{
    self.addressListTableView.estimatedRowHeight  = 300
    self.addressListTableView.tableFooterView = UIView(frame: CGRect.zero)
    self.addressListTableView.register(UINib(nibName: "ZNSaveListTableViewCell",bundle: nil), forCellReuseIdentifier: "ZNSaveListTableViewCell")

    }
   
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.addressInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
     let cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNSaveListTableViewCell") as? ZNSaveListTableViewCell
    cell1?.selectionStyle = UITableViewCellSelectionStyle.none
    
        cell1?.editButton.tag = indexPath.row + 500
        cell1?.editButton?.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        
        let addreesInfo = addressInfoArray[indexPath.row] 
        cell1?.addressLabelInfo.text =  addreesInfo.nameLabel
        cell1?.cityLabelInfo.text =   addreesInfo.addressLabel
        cell1?.countryLabelInfo.text =   addreesInfo.mobileLabel

        return cell1!
    }
    //MARK: - UITableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
      return UITableViewAutomaticDimension
    }
    //MARK: - EditRow Methods
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let deleteObj = addressInfoArray[indexPath.row] as ZNAddressListInfo
            callApiMethodToDeleteAddressList(addressId : deleteObj.addressId)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressObj = addressInfoArray[indexPath.row] as ZNAddressListInfo
        let vcObj = ZNCardListViewController()
        vcObj.TotalPrice = self.TotalPrice
        vcObj.orderArray = self.orderArray
        vcObj.addressId = addressObj.addressId as NSString
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    //MARK: UIButton Action
    @IBAction func editButtonAction(_ sender: UIButton) {
        let addressObj = addressInfoArray[sender.tag - 500] as ZNAddressListInfo
        let vcObj = ZNUserDeliveryAddressVC()
        vcObj.addressId = addressObj.addressId
        vcObj.isFromEdit = true
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
  self.navigationController?.popViewController(animated: true)
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        let vcObj = ZNUserDeliveryAddressVC()
              self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    //MARK: - WebApi Method
    
    func callApiMethodToGetAddressList() -> Void {
        
        let paramDict = NSMutableDictionary()
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .get, isToken: true, apiName: KAddressList) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.addressInfoArray .removeAll()
                    if let dict = response.object(forKey: "delivery_address_list") as? NSArray {
                        
                        self.addressInfoArray = ZNAddressListInfo.getAddressArray(responseArray: dict as! Array<Dictionary<String, String>>)
                    }
                    if(self.addressInfoArray.count == 0){
                        _ = AlertController.alert("", message:"There is no address saved! Please add address.")
                    }
                        self.addressListTableView.reloadData()
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
    func callApiMethodToDeleteAddressList(addressId : String) -> Void {
        
        let paramDict = NSMutableDictionary()
        paramDict[KAddress_Id] = addressId
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "delete_delivery_address") { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                  _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                        self.callApiMethodToGetAddressList()
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
    
}
