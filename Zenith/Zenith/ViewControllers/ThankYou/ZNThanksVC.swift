//
//  ZNThanksVC.swift
//  Zenith
//
//  Created by Anjali on 13/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

enum ZNThanksType {
    case appointment
    case product
}

class ZNThanksVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableViewThanks: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var helpNumber: UILabel!

    var thanksType: ZNThanksType! = .appointment
    var thankObj = ZNThankYou()
    
    var bookingInfoData = NSMutableArray()
    
    //Mark:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if thanksType == .appointment {
            self.titleLabel.text = "Thanks for booking your Appointment."
        }
        else if thanksType == .product {
            
            self.titleLabel.text = "Thanks for placing order."
        }

    }
    
    //Mark:- Helper Method
    func customInit(){
        self.tableViewThanks.register(UINib(nibName: "ZNThankYouTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNThankYouTableViewCell")
        
        self.tableViewThanks.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableViewThanks.tableHeaderView = headerView
        
        self.tableViewThanks.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewThanks.tableFooterView = footerView
        self.helpNumber.text = "For any help: +\(thankObj.helpString)"

        getDummyData()

         }
    
    //MARK: - Method for Static Data
    func getDummyData() {
        
        if thanksType == .appointment {
            
            let  objId = ZNThankYou()
            objId.titleString = "Your Booking ID : "
            objId.valueString  =  String (format: "%d", thankObj.appointmentId)
            let  objDate = ZNThankYou()
            objDate.titleString = "Date of booking : "
            objDate.valueString  = thankObj.bookingDate
            
            bookingInfoData.setArray([objId, objDate])
        }
        else if thanksType == .product {
            
            let  objId = ZNThankYou()
            objId.titleString = "Your Transaction ID : "
            objId.valueString  =  thankObj.transactionId
            bookingInfoData.setArray([objId])
        }
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNThankYouTableViewCell") as! ZNThankYouTableViewCell
        
        cell.selectionStyle = .none
        let infoObj = bookingInfoData.object(at: indexPath.row) as! ZNThankYou
        let string = infoObj.titleString + infoObj.valueString
        let range = string.range(of: infoObj.valueString)
        cell.titleLabel.makeAtttributedText(range: string.nsRange(from: range!), text: string, size: 20)
        return cell
    }
    
    //Mark:- UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ZNHomeVC.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }

    //Mark:- Memory Warning Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
