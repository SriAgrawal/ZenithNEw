//
//  FacebookManager.swift
//  Template
//
//  Created by Raj Kumar Sharma on 20/01/16.
//  Copyright © 2016 Innology. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookManager: NSObject {

    typealias LoginCompletionBlock = (Dictionary<String, AnyObject>?, String, NSError?) -> Void
    
    class var facebookManager: FacebookManager {
        struct Static {
            static let instance: FacebookManager = FacebookManager()
        }
        return Static.instance
    }
    
    //MARK:- Public functions

    func getFacebookInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {
      
//        if (kAppDelegate.isReachable == false) {
//            
//            let _ = AlertViewController.alert("Connection Error!", message: "Internet connection appears to be offline. Please check your internet connection.")
//            
//            return
//        }
        
        self.getFBInfoWithCompletionHandler(fromViewController) { (dataDictionary:Dictionary<String, AnyObject>?, token:String, error: NSError?) -> Void in
            onCompletion(dataDictionary, token, error)
        }
    }
    
    func logoutFromFacebook() {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    //MARK:- Private functions

    fileprivate func getFBInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {
        
        let permissionDictionary = [
            "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)",
            //"locale" : "en_US"
        ]
        
        if FBSDKAccessToken.current() != nil {

            FBSDKGraphRequest(graphPath: "/me", parameters: permissionDictionary)
                .start(completionHandler:  { (connection, result, error) in
                    
                    if error == nil {
                        onCompletion(result as? Dictionary<String, AnyObject>, FBSDKAccessToken.current().tokenString, nil)
                    } else {
                        onCompletion(nil, "",  error as NSError?)
                    }
                })
        
        } else {
            
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_photos","user_friends"], from: fromViewController as! UIViewController, handler: { (result, error) -> Void in
                
                
                if error != nil {
                    FBSDKLoginManager().logOut()
                    
                    if let error = error as NSError? {
                        let errorDetails = [NSLocalizedDescriptionKey : "Processing Error. Please try again!"]
                        let customError = NSError(domain: "Error!", code: error.code, userInfo: errorDetails)
                        
                        onCompletion(nil, "", customError)
                    } else {
                        onCompletion(nil, "", error as NSError?)
                    }
                    
                } else if (result?.isCancelled)! {
                    FBSDKLoginManager().logOut()
                    let errorDetails = [NSLocalizedDescriptionKey : "Request cancelled!"]
                    let customError = NSError(domain: "Request cancelled!", code: 1001, userInfo: errorDetails)
                    
                    onCompletion(nil, "", customError)
                } else {
                    let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: permissionDictionary)
                    let _ = pictureRequest?.start(completionHandler: {
                        (connection, result, error) -> Void in
                        
                        if error == nil {
                            onCompletion(result as? Dictionary<String, AnyObject>, FBSDKAccessToken.current().tokenString, nil)
                        } else {
                            onCompletion(nil, "", error as NSError?)
                        }
                    })
                }
            })
        }
    }
    
}
