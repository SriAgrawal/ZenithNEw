//
//  ZNAboutUsVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 30/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNAboutUsVC: UIViewController {
    
    @IBOutlet weak var aboutUsTextView: UITextView!
    @IBOutlet var webViewAbout: UIWebView!
    
    //MARK: - ViewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callApiMethodToStaticContent()
        aboutUsTextView.textContainerInset = UIEdgeInsetsMake(20, 5, 10, 5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutUsTextView.setContentOffset(CGPoint.zero, animated: false)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        paragraphStyle.alignment = aboutUsTextView.textAlignment
    }
    
    
        //MARK: - UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - WebService Method
    
    func callApiMethodToStaticContent() -> Void {
        
        let paramDict = NSMutableDictionary()
        
        paramDict[Kstatic_type] = "1"
        
        
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: Kstatic_pages) { (result :AnyObject?, error :NSError?) in

            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                   // if let dataArray = response.object(forKey: "data") as? NSArray {

                        //var staticDic = NSMutableDictionary ()
                       // staticDic = dataArray.firstObject as! NSMutableDictionary
                      //  self.aboutUsTextView.text = response.validatedValue("description", expected: "" as String as AnyObject) as! String
                      self.webViewAbout .loadHTMLString(response.validatedValue("description", expected: "" as String as AnyObject) as! String, baseURL: nil)
                  //  }
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
