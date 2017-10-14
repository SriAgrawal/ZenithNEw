//
//  ZNSpaDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 13/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSpaDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var spaInfo = [ZNSpaInfo]()
    
    @IBOutlet weak var spaDetailImageView: UIImageView!
    @IBOutlet weak var spaDetailTableView: UITableView!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        //register cell
        self.spaDetailTableView.register(UINib(nibName:"ZNStoreDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
        spaDetailImageView.image = UIImage(named: "spaImage")
        spaDetailImageView.clipsToBounds = true
        spaDetailTableView.tableHeaderView = headerView
        self.spaDetailTableView.tableFooterView = UIView(frame: CGRect.zero)

        let dummyArray = [["spaNum" : "1.", "spaReward" : " After third visit you will get a head massage free."], ["spaNum" : "2.", "spaReward" : " On the booking of 2000 you will get a 100 points."]]
        
        spaInfo =  ZNSpaInfo.getSpaRewardList(responseArray: dummyArray)
        
        //Set exclusive touch
         callBtn.isExclusiveTouch = true
         mapBtn.isExclusiveTouch = true
         shareBtn.isExclusiveTouch = true
        
//        if UIScreen.main.bounds.width == 320 {
//            btnLeadingConstraint.constant = 23
//            btnTrailingConstraint.constant = 23
//        }
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
        
        if cell == nil {
            cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
        }
        
        cell?.selectionStyle = .none
        cell?.storeAddressLabel.text = "On a purchasing of $500 you will get a 50 points."
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Valid until 08/09/2017")
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 0, green: 189, blue: 251, alpha: 1.0), range: NSMakeRange(11, (attrString.length-11)))
        
        cell?.storeDistanceLabel.attributedText = attrString
        return cell!
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myRewardBtnAction(_ sender: UIButton) {
        let vcObj = ZNSpaRewardVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func joinBtnAction(_ sender: UIButton) {
          _ = AlertController.alert("", message:"Work in Progress.")
    }
    
    @IBAction func callBtnAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor.white
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        if let phoneCallURL = URL(string: "tel://\("9999999999")") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                print("call failed")
            }
        }
    }
    
    @IBAction func mapBtnAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor.white
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        let vcObj = ZNRouteMapVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor.white
        
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func bookAppointmentBtnAction(_ sender: UIButton) {
        let vcObj = ZNBookAppointmentVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
