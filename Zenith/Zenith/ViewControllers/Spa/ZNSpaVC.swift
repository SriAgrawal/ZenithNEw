//
//  ZNSpaVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 12/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSpaVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var spaTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var spaArray = [ZNSpaInfo]()
    var spaInfo = ZNSpaInfo()
    
    //MARK: - UIView LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.spaTableView.allowsSelection = true
        pointsLabel.text = spaInfo.spaPoints
        self.spaTableView.register(UINib(nibName:"ZNSpaTableViewCell",bundle:nil),forCellReuseIdentifier : "ZNSpaTableViewCell")
        
        let dummyArray = [["spaName" : "Delhi Spa", "spaAddress" : "Okhla Phase 1,Delhi", "spaDistance" : "0.5m", "spaImage" : "spaImage"],["spaName" : "Aura Spa", "spaAddress" : "Okhla Phase 2,Delhi", "spaDistance" : "1.5m", "spaImage" : "spaImage"], ["spaName" : "Delhi Spa", "spaAddress" : "Okhla Phase 1,Delhi", "spaDistance" : "2.5m", "spaImage" : "spaImage"], ["spaName" : "Aura Spa", "spaAddress" : "Okhla Phase 2,Delhi", "spaDistance" : "3.5m", "spaImage" : "spaImage"], ["spaName" : "Delhi Spa", "spaAddress" : "Okhla Phase 1,Delhi", "spaDistance" : "4.5m", "spaImage" : "spaImage"]]
        
        self.spaArray = ZNSpaInfo.getSpaList(responseArray: dummyArray)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return spaArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNSpaTableViewCell")as? ZNSpaTableViewCell
        cell1?.selectionStyle = .none
        
        if cell1 == nil {
            cell1 = ZNSpaTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNSpaTableViewCell")
        }
        
        let spaInfo = spaArray[indexPath.row]
        cell1?.spaNameLabel.text = spaInfo.spaName
        cell1?.spaAddressLabel.text = spaInfo.spaAddress
        cell1?.spaDistanceLabel.text = spaInfo.spaDistance
        cell1?.spaImage.image = UIImage(named: spaInfo.spaImage)
        
        if UIScreen.main.bounds.width == 320 {
            cell1?.arrowTrailingConstraint.constant = 6
        }
        return cell1!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 117.0
    }
    
    //MARK: - UITableView Delegate Methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vcObj = ZNSpaDetailVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 1:
            let vcObj = ZNSpaDetailVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 2:
            let vcObj = ZNSpaDetailVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 3:
            let vcObj = ZNSpaDetailVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
            
        case 4:
            let vcObj = ZNSpaDetailVC()
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
        default:
            break
        }
    }
    
    //MARK :- BackButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
