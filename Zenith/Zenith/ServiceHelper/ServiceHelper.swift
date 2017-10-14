//
//  ServiceHelper.swift
//  Template
//
//  Created by Raj Kumar Sharma on 05/04/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import UIKit

//@@@@@@  Development URL
//@@@@@@  "http://172.16.0.9/PROJECTS/Zenith/api/"
//@@@@@@  Production URL
//@@@@@@  "http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/Zenith/api/"


let development = false

// Production URL

let baseURL: String = development == true ? "http://172.16.0.9/PROJECTS/Zenith/api/" : "http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/Zenith/api/"

let timeoutInterval:Double = 45

enum MethodType: CGFloat {
    case get  = 0
    case post  = 1
    case put  = 2
    case delete  = 3
}

class ServiceHelper: NSObject {

    //MARK:- Public Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class func callAPIWithParameters(_ parameterDict:NSMutableDictionary, method:MethodType, isToken:Bool, apiName :String, completionBlock: @escaping (AnyObject?, NSError?) -> Void) ->Void {
        
        //hud_type = hudType
        
        if (kAppDelegate.isReachable == false) {
            
            _ = AlertController.alert("Connection Error!", message: "Internet connection appears to be offline. Please check your internet connection.")
            
            return
        }
        
        //>>>>>>>>>>> create request
        let url = requestURL(method, apiName: apiName, parameterDict: parameterDict)
        var request = URLRequest(url: url)
        request.httpMethod = methodName(method)
        
        //>>>>>>>>>>>> insert json data to the request
        
        request.httpBody = body(method, parameterDict: parameterDict)
        
        // Add Auth Token
        let username = "zenithadmin"
        let password = "zenithadmin1234"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        if(isToken){
            request.setValue(UserDefaults.standard.object(forKey: KApi_Key) as! String?, forHTTPHeaderField: KApi_Key)
        }
        request.timeoutInterval = timeoutInterval
        
        if method == .post  || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        logInfo("\n\n Request URL  >>>>>>\(url)")
        logInfo("\n\n Request Header >>>>>> \n\(String(describing: request.allHTTPHeaderFields))")
        
        //logInfo("\n\n Request Body  >>>>>>\(request.HTTPBody)")
        
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        
        
        
        hideAllHuds(false)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        logInfo("\n\n Request URL  >>>>>>\(url)")

        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            hideAllHuds(true)
            
            if error != nil {
                
                logInfo("\n\n error  >>>>>>\n\(String(describing: error))")
                DispatchQueue.main.async(execute: {
                    completionBlock(nil,error as NSError?)
                })
                
            } else {
                
                let httpResponse = response as! HTTPURLResponse
                let responseCode = httpResponse.statusCode
                
                //let responseHeaderDict = httpResponse.allHeaderFields as NSDictionary
                //logInfo("\n\n Response Header >>>>>> \n\(responseHeaderDict)")
                
                let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
                logInfo("\n\n Response Code >>>>>> \n\(responseCode) \nResponse String>>>> \n \(String(describing: responseString))")
                
                
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    //>>>> Check if authentication error
                    
                    if let dataDict = result as? Dictionary<String, AnyObject> {
                        let allKeysArray = dataDict.keys
                        if allKeysArray.contains(KresponseCode) {
                            
                            if let errorDict = result as? Dictionary<String, AnyObject> {
                                
                                let statusCode = Int(errorDict[KresponseCode] as! String)
                                if (statusCode == 401) {
                                    
                                    // go to login screen
                                    kAppDelegate.logout()

                                    DispatchQueue.main.async(execute: {
                                        let alertController = UIAlertController(title: "Authentication Error!", message: "Please login and try again.", preferredStyle: .alert)
                                        
                                        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in}
                                        
                                        alertController.addAction(okAction)
                                        kAppDelegate.window?.currentController!.present(alertController, animated: true, completion: nil)
                                    })
                                    
                                } else {
                                    DispatchQueue.main.async(execute: {
                                        completionBlock(result as AnyObject?,nil)
                                    })
                                }
                            } else {
                                DispatchQueue.main.async(execute: {
                                    completionBlock(result as AnyObject?,nil)
                                })
                            }
                            
                        } else {
                            DispatchQueue.main.async(execute: {
                                completionBlock(result as AnyObject?,nil)
                            })
                        }
                    } else {
                        DispatchQueue.main.async(execute: {
                            completionBlock(result as AnyObject?,nil)
                        })
                    }
                } catch {
                    
                    logInfo("\n\n error in JSONSerialization")
                    logInfo("\n\n error  >>>>>>\n\(error)")
                    
                    if responseCode == 200 {
                        let result = ["responseCode":"200"]
                        DispatchQueue.main.async(execute: {
                            completionBlock(result as AnyObject?,nil)
                        })
                    }
                    
                }
            }
            
        })
        task.resume()
        
    }
    
    
   
    
    //MARK:- Private Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class fileprivate func methodName(_ method:MethodType)-> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        }
    }
    
    class fileprivate func body(_ method:MethodType, parameterDict:NSMutableDictionary) -> Data {
        
        switch method {
        case .get: return Data()
        case .post: return parameterDict.toNSData() as Data
        case .put: return parameterDict.toNSData() as Data
            
        default: return Data()
        }
    }
    
    class fileprivate func requestURL(_ method:MethodType, apiName:String, parameterDict:NSMutableDictionary) -> URL {
        let urlString = baseURL + apiName
        
        switch method {
        case .get:
            return getURL(apiName, parameterDict: parameterDict)
            
        case .post:
            return URL(string: urlString)!
            
        case .put:
            return URL(string: urlString)!
            
        default: return URL(string: urlString)!
        }
    }
    
    class fileprivate func getURL(_ apiName:String, parameterDict:NSMutableDictionary) -> URL {
        
        var urlString = baseURL + apiName
        var isFirst = true
        
        for key in parameterDict.allKeys {
            
            let object = parameterDict[key as! String]
            
            if object is NSArray {
                
                let array = object as! NSArray
                for eachObject in array {
                    var appendedStr = "&"
                    if (isFirst == true) {
                        appendedStr = "?"
                    }
                    urlString += appendedStr + (key as! String) + "=" + (eachObject as! String)
                    isFirst = false
                }
                
            } else {
                var appendedStr = "&"
                if (isFirst == true) {
                    appendedStr = "?"
                }
                let parameterStr = parameterDict[key as! String] as! String
                urlString += appendedStr + (key as! String) + "=" + parameterStr
            }
            
            isFirst = false
        }
        
        let strUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        
        return URL(string:strUrl!)!
    }
}

private func hideAllHuds(_ status:Bool) {
    //UIApplication.sharedApplication().networkActivityIndicatorVisible = !status
    
    DispatchQueue.main.async(execute: {
        var hud = MBProgressHUD(for: kAppDelegate.window!)
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: kAppDelegate.window!, animated: true)
        }
        hud?.cornerRadius = 8.0
        hud?.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        hud?.margin = 12
        if (status == false) {
            hud?.show(animated: true)
        } else {
            hud?.hide(animated: true)
        }
    })
}


