//
//  ZNStoreDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ZNStoreDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var storeObj = ZNStoreInfo()
    var rewardsArray = [String]()
    var rewardNumArray = [String]()
    
    @IBOutlet weak var storeDetailTableView: UITableView!
    @IBOutlet weak var storeDetailImageView: UIImageView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var emailContentBtn: UIButton!
    @IBOutlet weak var contactNoBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var offersBtn: UIButton!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        storeDetailTableView.tableHeaderView = headerView
        storeDetailImageView.image = UIImage(named: "myReward_Vmart")
        
        //register cell
        self.storeDetailTableView.register(UINib(nibName:"ZNStoreDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
        self.storeDetailTableView.tableFooterView = UIView(frame: CGRect.zero)

        emailContentBtn.setTitle(storeObj.storeEmail, for: .normal)
        contactNoBtn.setTitle(storeObj.storeContactNo, for: .normal)
        rewardsArray = ["On a purchasing of Rs 5000 you will get a 500 points.", "After a 5th visit ypu will get a 5 loyality points."]
        rewardNumArray = ["1.", "2."]
        
        //Set exclusive touch
         callBtn.isExclusiveTouch = true
         mapBtn.isExclusiveTouch = true
         shareBtn.isExclusiveTouch = true
        
        //Setting text size according to 5s
        if UIScreen.main.bounds.width == 320 {
            emailLabel.font = UIFont.textMediumFont(fontSize: 15)
            contactNoLabel.font = UIFont.textMediumFont(fontSize: 15)
            emailContentBtn.titleLabel?.font =  UIFont.textBookFont(fontSize: 15)
            contactNoBtn.titleLabel?.font =  UIFont.textBookFont(fontSize: 15)
        }
        //self.callApiMethodForCategoryList()
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 73.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
        
        storeDetailTableView.allowsSelection = true
        
        if cell == nil {
            cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
        }
        
       // cell?.rewardLabel.setLineHeight(lineHeight: 25)
        cell?.selectionStyle = .none
//        cell?.rewardLabel.text = rewardsArray[indexPath.row]
//        cell?.rewardNumLabel.text = rewardNumArray[indexPath.row]
        cell?.storeAddressLabel.text = "On a purchasing of $500 you will get a 50 points."
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Valid until 08/09/2017")
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 0, green: 189, blue: 251, alpha: 1.0), range: NSMakeRange(11, (attrString.length-11)))
        
        cell?.storeDistanceLabel.attributedText = attrString
        return cell!
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func myRewardsButtonAction(_ sender: UIButton) {
        let vcObj = ZNRewardVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func joinBtnAction(_ sender: UIButton) {
        _ = AlertController.alert("", message:"Work in Progress.")
    }
    
    @IBAction func offerButtonAction(_ sender: UIButton) {
        let vcObj =  ZNOffersLoyalityEarnedVC()
        vcObj.isFrom = false
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func sendEmailButtonTapped(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            //self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([storeObj.storeEmail])
        mailComposerVC.setSubject(storeObj.storeName)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        _ = AlertController.alert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor.white
        mapLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        if let phoneCallURL = URL(string: "tel://\(storeObj.storeContactNo)") {
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
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        callLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        mapLabel.backgroundColor = UIColor.white
        shareLabel.backgroundColor = UIColor(red:(0/255.0), green:(181/255.0), blue:(251/255.0), alpha: 1.0)
        
        let vcObj = ZNRouteMapVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
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
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - WebService Method
    
//    func callApiMethodForCategoryList() {
//        
//        let paramDict = NSMutableDictionary()
//        paramDict[KStore_Id] = "1"
//        
//        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KStoreDetail) { (result :AnyObject?, error :NSError?) in
//            let response = result as! NSDictionary
//            
//            if error == nil {
//                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
//                }
//                else {
//                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
//                }
//            }
//            else {
//                _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
//            }
//        }
//    }

    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}










