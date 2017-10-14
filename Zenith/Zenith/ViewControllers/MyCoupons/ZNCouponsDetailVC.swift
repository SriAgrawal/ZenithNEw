//
//  ZNCouponsDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 05/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNCouponsDetailVC: UIViewController {
    
    var couponInfo = ZNProductInfo()

    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var couponsBrandLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var couponsStartDateLabel: UILabel!
    @IBOutlet weak var couponsEndDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availBtnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var availBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var couponDetailTableView: UITableView!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        self.couponDetailTableView.tableHeaderView = headerView
        couponImageView.clipsToBounds = true
        couponImageView.sd_setImage(with: URL(string: couponInfo.couponImage ), placeholderImage: UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
        self.navTitleLabel.text = couponInfo.productName
        storeNameLabel.text = couponInfo.storeName
        storeAddressLabel.text = couponInfo.storeAddress
        couponsBrandLabel.text = couponInfo.productName
        priceLabel.text = couponInfo.couponCode
        couponsStartDateLabel.text = couponInfo.productStartDate
        couponsEndDateLabel.text = couponInfo.productEndDate
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backButtonActiion(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func availButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
