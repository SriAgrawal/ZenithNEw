//
//  ZNTCViewController.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNTCViewController: UIViewController {
    
    @IBOutlet var webViewTC: UIWebView!
    @IBOutlet weak var tcTextView: UITextView!
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callApiMethodToStaticContent()
        tcTextView.textContainerInset = UIEdgeInsetsMake(20, 5, 10, 5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tcTextView.setContentOffset(CGPoint.zero, animated: false)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        paragraphStyle.alignment = tcTextView.textAlignment
    }
    
    //UIButton Action Method
    @IBAction func tcButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - WebService Method
    
    func callApiMethodToStaticContent() -> Void {
        
        let paramDict = NSMutableDictionary()

        paramDict[Kstatic_type] = "2"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: Kstatic_pages) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                   // if let dataArray = response.object(forKey: "data") as? NSArray {
                        
                     //   var staticDic = NSMutableDictionary ()
                     //   staticDic = dataArray.lastObject as! NSMutableDictionary
                       // self.tcTextView.text = response.validatedValue("description", expected: "" as String as AnyObject) as! String
                    
                        self.webViewTC .loadHTMLString(response.validatedValue("description", expected: "" as String as AnyObject) as! String, baseURL: nil)
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
