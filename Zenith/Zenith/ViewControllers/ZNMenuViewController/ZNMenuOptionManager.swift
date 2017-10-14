//
//  ZNMenuOptionManager.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

enum SVMenuOptions {
    case Home
    case Offers
    case Settings
    case TodaysOffers
    case MyRewards
    case MyCoupons
    case Logout
    var menuTitle: String {
        
        return String(describing: self)
    }

     }

class ZNMenuOptionManager: NSObject {
    static let sharedInstance = ZNMenuOptionManager()
    
    let slidingPanel: SVSlidingPanelViewController
    
    
    override init() {
        
        self.slidingPanel = SVSlidingPanelViewController()
        
        super.init()
        
     
        let  lefthamburgerMenuController = ZNMenuVC()
        
//        let  righthamburgerMenuController : SVMenuViewController = storyboard.instantiateViewController(withIdentifier: "SVMenuViewController") as! SVMenuViewController
        
        
        let  detailController = ZNProfileViewController()
        let navigation = UINavigationController(rootViewController:detailController)
        
        self.slidingPanel.leftPanel = lefthamburgerMenuController
        self.slidingPanel.centerPanel = navigation
        //        self.slidingPanel.rightPanel = righthamburgerMenuController
        
        
        lefthamburgerMenuController.menuSelectionClosure = {[weak self](selectedMenuOption: SVMenuOptions, animated:Bool) in
            
            self?.showScreenForMenuOption(menuOntion: selectedMenuOption, animation: animated)
        }
        
        //righthamburgerMenuController.menuSelectionClosure = {[weak self](selectedMenuOption: SVMenuOptions, animated:Bool) in
            
//            self?.showScreenForMenuOption(menuOntion: selectedMenuOption, animation: animated)
//        }
        
        
    }
    
    func showScreenForMenuOption(menuOntion: SVMenuOptions, animation animated: Bool) {
        
        
        let navigationController = self.slidingPanel.centerPanel as! UINavigationController
        _ = navigationController.viewControllers.first as! ZNProfileViewController
        
        self.slidingPanel.showCenterPanel(animated: animated)
        
    }

}
