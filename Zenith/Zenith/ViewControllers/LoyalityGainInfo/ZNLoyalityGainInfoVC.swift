//
//  ZNLoyalityGainInfoVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNLoyalityGainInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var dataArray = [String]()
    var numArray = [String]()
    
    @IBOutlet weak var loyalityTableView: UITableView!
    
    @IBOutlet var webViewLoyalitygain: UIWebView!
    //MARK: - ViewLifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod()
    {
        self.navigationController?.isNavigationBarHidden = true
       // self.loyalityTableView.register(UINib(nibName: "ZNLoyalityGainInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNLoyalityGainInfoTableViewCell")
        //self.loyalityTableView.allowsSelection=false;
        //self.loyalityTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        dataArray = ["After sharing the Products via Facebook or any social media options you can get the 5 loyality Points.", "After sharing the Products with your friends you can get the 5 loyality Points.", "After sharing the Products via Facebook you can get the 5 loyality Points.", "After sharing the Products via Facebook or any social media options you can get the 5 loyality Points.", "After sharing the Products with your friends you can get the 5 loyality Points."]
        numArray = ["1 .", "2 .", "3 .", "4 .", "5 ."]
        
        callApiMethodToGetLoayalityGainInfp()
    }
    
    //MARK: - UITableView DataSource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNLoyalityGainInfoTableViewCell") as? ZNLoyalityGainInfoTableViewCell
        
        if cell1 == nil {
            cell1 = ZNLoyalityGainInfoTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNLoyalityGainInfoTableViewCell")
        }
        
        switch indexPath.row {
        case 0:
            cell1?.gainInfoLabel.text = dataArray[indexPath.row]
            cell1?.numberLabel.text = numArray[indexPath.row]
            cell1?.gainInfoLabel.setLineHeight(lineHeight: 10)
            break
        case 1:
            cell1?.gainInfoLabel.text = dataArray[indexPath.row]
            cell1?.numberLabel.text = numArray[indexPath.row]
            cell1?.gainInfoLabel.setLineHeight(lineHeight: 10)
            break
        default:
            cell1?.gainInfoLabel.text = dataArray[indexPath.row]
            cell1?.numberLabel.text = numArray[indexPath.row]
            cell1?.gainInfoLabel.setLineHeight(lineHeight: 10)
            break
        }
        return cell1!
    }
    
    
    //MARK: - UITableView Delegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 125.0
    }
    
    //MARK: - UIButon Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - WebService Method
    
    func callApiMethodToGetLoayalityGainInfp() -> Void {
        
        let paramDict = NSMutableDictionary()
    
        ServiceHelper.callAPIWithParameters(paramDict, method:  .get, isToken: true, apiName: KLoyalityGain) { (result :AnyObject?, error :NSError?) in
        
            if error == nil {
                
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    // if let dataArray = response.object(forKey: "data") as? NSArray {
                    
                    var staticDic = NSMutableDictionary()
                    
                       staticDic = response .value(forKey: "loyality_gain_info") as! NSMutableDictionary
                    // self.tcTextView.text = response.validatedValue("description", expected: "" as String as AnyObject) as! String
                    
                    self.webViewLoyalitygain .loadHTMLString(staticDic.validatedValue("description", expected: "" as String as AnyObject) as! String, baseURL: nil)
                    // }
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
