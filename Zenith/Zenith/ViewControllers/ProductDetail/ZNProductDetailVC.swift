//
//  ZNProductDetailVC.swift
//  Zenith
//
//  Created by Anshu Aggarwal on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var productObj = ZNProductInfo()
    var navTitle = String()
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDetailTableView: UITableView!
    @IBOutlet weak var loyaltyEarnedView: UIView!
    
    //MARK: - UIViewController LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        productImageView.clipsToBounds = true
        
        //register cell
        self.productDetailTableView.register(UINib(nibName:"ZNProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNProductDetailTableViewCell")
        self.productDetailTableView.register(UINib(nibName: "ZNProductDetailDescTableViewCell", bundle: nil), forCellReuseIdentifier: "ZNProductDetailDescTableViewCell")
        
        //navTitleLabel.text = productObj.productName
        pointsLabel.text = productObj.earnPoint
        productImageView.sd_setImage(with: URL(string: productObj.productImage), placeholderImage:UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
        
        self.productDetailTableView.estimatedRowHeight = 50;
        
        //Setting view Shadow
        loyaltyEarnedView.layer.cornerRadius = 10
        loyaltyEarnedView.layer.shadowColor = UIColor.lightGray.cgColor
        loyaltyEarnedView.layer.shadowOpacity = 1
        loyaltyEarnedView.layer.shadowOffset = CGSize.zero
        loyaltyEarnedView.layer.shadowRadius = 5
    }
    
    //MARK: - UITableView DataSource and Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"ZNProductDetailTableViewCell") as? ZNProductDetailTableViewCell
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNProductDetailDescTableViewCell")as? ZNProductDetailDescTableViewCell
        
        productDetailTableView.allowsSelection = true
        
        if cell == nil {
            cell = ZNProductDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNProductDetailTableViewCell")
        }
        if cell1 == nil {
            cell1 = ZNProductDetailDescTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNProductDetailDescTableViewCell")
        }
        
        cell?.selectionStyle = .none
        cell1?.selectionStyle = .none
      
        
        switch indexPath.row {
            
        case 0:
            cell?.productSpecLabel.text = "Store"
            cell?.productValueLabel.text = productObj.storeName
            break
        case 1:
            cell?.productSpecLabel.text = "Address"
            cell?.productValueLabel.text = productObj.storeAddress
            break
        case 2:
            cell?.productSpecLabel.text = "Start Date"
            cell?.productValueLabel.text = productObj.productStartDate
            break
        case 3:
            cell?.productSpecLabel.text = "End Date"
            cell?.productValueLabel.text = productObj.productEndDate
            break
        case 4:
            cell1?.productTitleLbl.text = "Title"
            cell1?.productDescriptionLabel.text = productObj.productName
            return cell1!
        case 5:
            cell1?.productTitleLbl.text = "Description"
            cell1?.productDescriptionLabel.attributedText = productObj.productDescription.getAttributedHTMLString(productObj.productDescription)
            return cell1!
        default:
            break
        }
        return cell!
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        let vcObj = ZNCustomSharePopUpViewController()
        vcObj.productObj = self.productObj
        let navController = UINavigationController.init(rootViewController: vcObj)
        navController.modalPresentationStyle = .overCurrentContext
        navController.navigationBar.isHidden = true
        self.present(navController, animated: true, completion: nil)

    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
