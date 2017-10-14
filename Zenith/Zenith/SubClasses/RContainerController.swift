//
//  RContainerController.swift
//  Smoogin
//
//  Created by Raj Kumar Sharma on 31/05/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import UIKit

class RContainerController: UIViewController {

    var controllers = [UIViewController]()
    var controllerContainerView: UIView!
    
    var switchWithFadeAnimation = false
    
    var currentController: UIViewController? {
        
        didSet {
            
            if let index = self.currentIndex {
                print("controller did set to index>>>>   \(index)")
            }
        }
    }
    
    var currentIndex: NSInteger? {
        
        willSet {
            
            if let index = newValue {
                
                if index < controllers.count {
                    
                    if (newValue == currentIndex) {
                        print("Already loaded")
                        return
                    }
                    
                    let newViewController = controllers[index]
                    
                    newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.replaceViewController(oldViewController: currentController, toViewController: newViewController)
                    self.currentController = newViewController
                } else {
                    print("Invalid current index>>>>   \(self.currentIndex!)")
                }
            }
        }
    }
    
    //MARK:- UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK:- Public functions

    func setUpWithControllers(controllers: Array<UIViewController>, containerView: UIView, withInitialIndex: Int = 0) {
        
        self.controllers = controllers
        self.controllerContainerView = containerView
        self.currentIndex = withInitialIndex
    }
    
    //MARK:- Private functions
    
    func replaceViewController(oldViewController: UIViewController?, toViewController newViewController: UIViewController) {
        
        if oldViewController == nil {
            
            // old controller is nil, only subview the new one and return
          //  newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(newViewController)
            self.addSubview(subView: newViewController.view, toView: self.controllerContainerView)
            
            return
        }
        
        guard let oldViewController = oldViewController else {
            return
        }
        
        
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.controllerContainerView!)
        
        if (switchWithFadeAnimation) {
            newViewController.view.alpha = 0
        }
        
        newViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if (self.switchWithFadeAnimation) {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
                newViewController.view.layoutIfNeeded()
            }
        },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    //MARK:- Memory handling
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
