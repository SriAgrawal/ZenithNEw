//
//  ZNProductListVC.swift
//  Zenith
//
//  Created by Sunil Datt Joshi on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNProductListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var productInfo = ZNProductInfo()
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var productListTableView: UITableView!
    
    // Array declaration and definition
    var productNameArray = NSMutableArray(array:["Jeans","Video Game","Girls Tops","Home Remedy","Footwears"])
    var productPriceArray = NSMutableArray(array:["$1000","$3000","$400","$200","$500"])
    var productQuantityArray = NSMutableArray (array: ["5","5","5","5","5"])
    var productImageArray = NSMutableArray(array: ["jeans.png","top.png","jeans.png","top.png","jeans.png"])
    
    //MARK: - UIView LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }
    //MARK: - Helper Method
    func initialMethod() {
        self.navigationController?.isNavigationBarHidden = true
        
        pointsLabel.text = productInfo.productPoint
        self.productListTableView.allowsSelection = true
        self.productListTableView.register(UINib(nibName: "ZNProductListTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNProductListTableViewCell")
    }
    
    //MARK: - UITableView DataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productNameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell1 = tableView.dequeueReusableCell(withIdentifier: "ZNProductListTableViewCell") as? ZNProductListTableViewCell
        
        cell1?.selectionStyle = .none
        
        if cell1 == nil {
            cell1 = ZNProductListTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNProductListTableViewCell")
        }
        
        productInfo.productName = productNameArray .object(at: indexPath.row) as! String
        productInfo.productPrice = productPriceArray .object(at: indexPath.row) as! String
        productInfo.productQuantity = productQuantityArray .object(at: indexPath.row) as! String
        productInfo.productImage = productImageArray.object(at: indexPath.row) as! String
        
        cell1?.productName.text = productInfo.productName
        cell1?.productPrice.text = productInfo.productPrice
        cell1?.productQuantity.text = productInfo.productQuantity
        cell1?.productImageview.image = UIImage(named:productInfo.productImage)
        return cell1!
    }
    
    //MARK: - UITableView Delegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcObj = ZNProductDetailVC()
        self.navigationController?.pushViewController(vcObj, animated: true)
    }
    
    //MARK: - UIButton Action Method
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
