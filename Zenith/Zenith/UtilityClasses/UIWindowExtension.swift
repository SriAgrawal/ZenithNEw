//
//  UIWindowExtensions.swift
//  Template
//
//  Created by Johan Wiig on 24/11/15.
//  Copyright © 2015 Innology. All rights reserved.
//

import UIKit

extension UIWindow {
    
    static var currentController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window?.currentController
    }
    
    var currentController: UIViewController? {
        if let vc = self.rootViewController {
            return getCurrentController(vc)
        }
        return nil
    }
    
    func getCurrentController(_ vc: UIViewController) -> UIViewController {
        
        if let pc = vc.presentedViewController {
            return getCurrentController(pc)
        }
        
        else if let nc = vc as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return getCurrentController(nc.viewControllers.last!)
            } else {
                return nc
            }
        }
        
        else {
            return vc
        }
    }
}
