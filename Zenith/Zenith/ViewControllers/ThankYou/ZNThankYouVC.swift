//
//  ZNThankYouVC.swift
//  Zenith
//
//  Created by Anjali on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.

import UIKit

class ZNThankYouVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let blueCustom = UIColor(red: CGFloat(0)/255
        ,green: CGFloat(181)/255
        ,blue: CGFloat(251)/255
        ,alpha: 1.0)
    
    var  objThanks = ZNThankYou()
    var bookingInfoData = NSMutableArray()
    
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var thanksMessageLabel: UILabel!
    @IBOutlet var helpLabel: UILabel!
    
    
    //Mark View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        helpLabel.text = "For any help: +\(objThanks.helpString)"
        self.demoData()
        self.customInit()
        
    }
    
    func demoData()
    {
        let  objdate = ZNThankYou()
        objdate.titleString = "Date of Booking :  "
        objdate.valueString = objThanks.bookingDate
        
        let  objTime = ZNThankYou()
        objTime.titleString = "Time : "
        objTime.valueString = objThanks.bookingTime
        
        let  objTableNo = ZNThankYou()
        objTableNo.titleString = "Table Booking Id : "
        objTableNo.valueString = String (format: "%d", objThanks.bookingId)
        
        let  objPeople = ZNThankYou()
        objPeople.titleString = "No of people : "
        objPeople.valueString = objThanks.noOfPeople
        
        bookingInfoData.setArray([objdate, objTime, objTableNo, objPeople])
    }
    
    //Mark:- Helper Method
    func customInit(){
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = headerView
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = footerView
        
        self.tableView.register(UINib(nibName: "ZNPlaceOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNPlaceOrderTableViewCell")
        thanksMessageLabel.text = "Thanks for book a table!"
    }
    
    //Mark:- UIButton Action Method
    @IBAction func okButtonAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ZNHomeVC.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNPlaceOrderTableViewCell") as! ZNPlaceOrderTableViewCell
    
        cell.selectionStyle = .none
        let infoObj = bookingInfoData.object(at: indexPath.row) as! ZNThankYou
        let string = infoObj.titleString + infoObj.valueString
        let range = string.range(of: infoObj.valueString)
        cell.titleLabel.makeAtttributedText(range: string.nsRange(from: range!), text: string, size: 20)
        
        return cell
    }
    
    //Mark:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
     
}
