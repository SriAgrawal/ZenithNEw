//
//  ZNMyPointsVC.swift
//  Zenith
//
//  Created by Anjali on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

let myNotification = Notification.Name(rawValue:"MyNotification")

class ZNMyPointsVC: RContainerController {
    @IBOutlet var navigationTitleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var earnedPointsLabel: UILabel!
    @IBOutlet var pointsButton: UIButton!
    @IBOutlet var stampsButton: UIButton!
    @IBOutlet var stampAndPointView: UIView!
    
    
    //Mark:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit();
    }
    
    //MARK: -  Helper Method
    func customInit()   {
        var controllers = [UIViewController]()
        let stampsVC = ZNStampsVC(nibName: "ZNStampsVC", bundle: nil)
        let pointsVC = ZNPointsVC(nibName: "ZNPointsVC", bundle: nil)
        
        // Add Controllers in the Container View.
        controllers.append(pointsVC)
        controllers.append(stampsVC)
        setUpWithControllers(controllers: controllers, containerView: self.containerView)
        
        // Setting Corner Radius and border width of the view.
        stampAndPointView.layer.cornerRadius = 4
        stampAndPointView.layer.borderWidth = 1
        stampAndPointView.layer.borderColor = UIColor.white.cgColor
        
        //Setting Shadow of the outer View
        stampAndPointView.layer.shadowColor = UIColor.gray.cgColor
        stampAndPointView.layer.shadowOpacity = 1
        stampAndPointView.layer.shadowOffset = CGSize.zero
        stampAndPointView.layer.shadowRadius = 2
        pointsButton.isSelected = true
        
        earnedPointsLabel.isHidden = false
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(catchNotification),
            name: NSNotification.Name(rawValue: "MyNotification"),
            object: nil)

        
    }
    
    func catchNotification(notification:Notification) -> Void {
        
        let userInfo = notification.userInfo
        self.earnedPointsLabel.text = String (format: "Earning points: %@", (userInfo?.validatedValue("point", expected: "" as AnyObject) as? String)!)
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        switch (sender.tag) {
            
        // Menu Button Action
        case 100:
            print(self.navigationController?.parent as Any)
            self.toggleSlider()
            break
            
        // Stamps Button Action
        case 101:
            // Setting tiitle of Navigation Bar.
            self.currentIndex = 1
            navigationTitleLabel.text = "My Stamps"
            stampsButton.isSelected = true
            pointsButton.isSelected = false
            earnedPointsLabel.isHidden = true
            break
        // Points Button Action
        case 102:
            self.currentIndex = 0
            navigationTitleLabel.text = "My Points"
            pointsButton.isSelected = true
            stampsButton.isSelected = false
            earnedPointsLabel.isHidden = false
          
            break
        default:
            break
        }
        
    }
    //MARK:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
