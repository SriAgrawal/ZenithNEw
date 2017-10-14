//
//  ZNOrderListVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

let myNotificationNew = Notification.Name(rawValue:"MyNotificationNew")

class ZNOrderListVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var orderListTableView: UITableView!
    
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    
    
    var dataSourceArray = NSMutableArray()
    var currencySymbol = String()
    var taxPrice = Float()
    
    var orderListInfo = ZNOrderListInfo()
    var totalPrice: Float = 0
    //MARK: - ViewLifeCycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - helper method
    func initialMethod() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismissPopUp),
            name: NSNotification.Name(rawValue: "MyNotificationNew"),
            object: nil)

        self.orderListTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.orderListTableView.tableFooterView = footerView
        
        self.orderListTableView.register(UINib(nibName: "ZNOrderListTableViewCell", bundle: nil),forCellReuseIdentifier:"ZNOrderListTableViewCell")
        //Price Calculator
        for priceObj in dataSourceArray {
            let obj = priceObj as! ZNCategoryInfo
            totalPrice = (totalPrice + obj.totalPrice)
        }
        self.subTotalLabel.text = "\(self.currencySymbol)\(totalPrice)"
        self.vatLabel.text = "\(taxPrice)%"
        //self.taxLabel.text = "\(taxPrice)"
        
        orderListInfo.totalAmount = "\(totalPrice + (totalPrice * taxPrice)/100)"
        self.totalLabel.text = "\(self.currencySymbol)\(totalPrice + (totalPrice * taxPrice)/100)"
        //self.demoData()
    }
    
    func dismissPopUp(_ notification: NSNotification) {
        if (notification.userInfo?["isPal"] as? Bool) == true {
            let vcObj = ZNCardListViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            
        }
        else
        {
            let vcObj = ZNAddressListViewController()
            self.navigationController?.pushViewController(vcObj, animated: true)
            
        }
    }
    
    //Mark:- UITable View Data Source and Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSourceArray.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNOrderListTableViewCell", for: indexPath) as! ZNOrderListTableViewCell
        
        let modal = self.dataSourceArray.object(at: indexPath.row)  as!  ZNCategoryInfo
        cell.dishNameLabel.text = modal.name
        
        let myString = String(modal.totalPrice)
        cell.dishPriceLabel.text = String (format: "%@%@",modal.currencySymbol,myString)
        cell.distDescription.text = modal.totalDish
       // cell.dishListImageView.image = modal.dishImage
        
        if modal.type == "starters" {
           cell.dishListImageView.image =  UIImage (named: "starter")
            
        }else if modal.type == "main_course"{
           cell.dishListImageView.image =  UIImage (named: "MainCourse")
            
            
        }else if modal.type == "dessert"{
            cell.dishListImageView.image =  UIImage (named: "dessert")
            
        }
        else if modal.type == "drinks"{
            cell.dishListImageView.image =  UIImage (named: "drinks")
            
        }else if modal.type == "snacks"{
           cell.dishListImageView.image =  UIImage (named: "snacks")
            
        } else{
            cell.dishListImageView.image =  UIImage (named: "snacks")
            
        }
    return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 106;
    }
    //Mark:- UI Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func confirmOrderButtonAction(_ sender: Any) {
        
        let vcObj = ZNAddressListViewController()
        vcObj.orderArray = self.dataSourceArray
        vcObj.TotalPrice = orderListInfo.totalAmount as NSString
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
