//
//  ZNMenuVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet var headerView: UIView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    
    let cellID = "ZNMenuTableViewCell"
    let menuItems = [SVMenuOptions.Home, SVMenuOptions.Offers, SVMenuOptions.Settings, SVMenuOptions.TodaysOffers, SVMenuOptions.MyRewards, SVMenuOptions.MyCoupons,SVMenuOptions.Logout]
    var menuSelectionClosure: ((SVMenuOptions, Bool)-> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMethod()
    }
    
    func initMethod()
    {
     self.menuTableView.tableHeaderView = headerView
    }
    
    // MARK: - table view delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZNMenuTableViewCell") as? ZNMenuTableViewCell
        
        if cell == nil{
            cell = ZNMenuTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNMenuTableViewCell")
        }
        
        let menuItem = self.menuItems[indexPath.row]
        
        cell?.menuLabel.text = menuItem.menuTitle
        return cell!
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = self.menuItems[indexPath.row]
        self.menuSelectionClosure(menuItem, true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
