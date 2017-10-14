//
//  ZNCustomSharePopUpViewController.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 10/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import  Social
import MessageUI




class ZNCustomSharePopUpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var sharefbBtn: UIButton!
    @IBOutlet weak var shareEmailBtn: UIButton!
    var productObj = ZNProductInfo()
    
    //MARK: - UIVirewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        btnView.layer.cornerRadius = 8
        cancelBtn.layer.cornerRadius = 8
        sharefbBtn.layer.cornerRadius = 8
        shareEmailBtn.layer.cornerRadius = 8
    }
    
    //MARK: - UIButton Action Method
    @IBAction func shareViaFbBtnAction(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("\(productObj.storeName) offer you \(productObj.productName)")
            let shareImageView = UIImageView()
           shareImageView.sd_setImage(with: URL(string: productObj.storeCoverImage), placeholderImage:UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
                        facebookSheet.add(shareImageView.image)
            
            facebookSheet.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.cancelled:
                    print("Cancelled")
                    break
                case SLComposeViewControllerResult.done:
                    self.callApiMethodToCheckInForGoogle()
                    break
                }
            }
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareViaEmailBtnAction(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("\(productObj.storeName) offer you \(productObj.productName)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        _ = AlertController.alert("Could Not Send Email", message:  "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("Cancelled")
            break
        case MFMailComposeResult.sent:
            self.callApiMethodToCheckInForGoogle()
            break
        default:
            break
        }
        
        controller.dismiss(animated: true, completion:nil)
        
    }
    
    
    func callApiMethodToCheckInForFacebook() {
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = productObj.storeId
        paramDict["address_id"] = productObj.addressId
        paramDict["social_type"] = "facebook_checkin"
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "social_sign_point_detail") { (result :AnyObject?, error :NSError?) in
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    // text to share
                    let storeDic =  response.object(forKey: "social_detail" ) as! NSDictionary
                    let text = storeDic["message"] as! String
                    if text.length == 0{
                        _ = AlertController.alert("Try Again!", message:"No rewards are available." , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                            
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                    else{
                        _ = AlertController.alert("Congratulation!", message:text , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                            
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                    
                }
                else {
                }
            }
            else {
            }
        }
    }
    
    func callApiMethodToCheckInForGoogle() {
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = productObj.storeId
        paramDict["address_id"] = productObj.addressId
        paramDict["social_type"] = "share"
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: "social_sign_point_detail") { (result :AnyObject?, error :NSError?) in
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    let storeDic =  response.object(forKey: "social_detail" ) as! NSDictionary
                    let text = storeDic["message"] as! String
                    if text.length == 0{
                        _ = AlertController.alert("Try Again!", message:"No rewards are available." , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                        
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                    else{
                        _ = AlertController.alert("Congratulation!", message:text , controller: self, buttons: ["OK"], tapBlock: { (alertAction, index) in
                            
                            self.dismiss(animated: true, completion: {})
                        })
                    }
                }
                else {
                    
                    
                }
            }
            else {
            }
        }
    }

    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
