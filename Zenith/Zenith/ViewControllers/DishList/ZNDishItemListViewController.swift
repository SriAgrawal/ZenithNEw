//
//  ZNDishItemListViewController.swift
//  Zenith
//
//  Created by Shridhar Agarwal on 19/07/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNDishItemListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate{

    var dataSourceArray = NSMutableArray()
    var orderListInfo = ZNOrderListInfo()
    var navString = NSString()
    var earnPoints = NSString()
    var currencySymbol :String = ""
   // var objDish = ZNDishInfo()

    @IBOutlet weak var storeListTableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    
    //MARK: - viewLifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
    }

    //MARK: - helper method
    func initialMethod()
    {
        self.navLabel.text = self.navString as String
        self.pointsLabel.text = self.earnPoints as String
        self.storeListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.storeListTableView.register(UINib(nibName: "ZNDishTableCell", bundle: nil),forCellReuseIdentifier:"ZNDishTableCell")
        
        //self.demoData()
    }
    
    func demoData( ) {
        
        for _ in 0  ... 2{
            let modalObj = ZNOrderListInfo()
            modalObj.dishName = "Burger"
            modalObj.dishPrice = ""
            //modalObj.extra = "Extra Cheese"
            modalObj.dishCount = 1
            modalObj.dishImage = UIImage.init(named: "burgur_Icon" )!
            modalObj.isChecked = false
            self.dataSourceArray.add(modalObj)
        }
        
    }
    
    //Mark:- UITable View Data Source and Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSourceArray.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZNDishTableCell", for: indexPath) as! ZNDishTableCell

        cell.addButton.tag = indexPath.row + 1000
        cell.removeButton.tag = indexPath.row + 2000
        cell.extraTextField.tag = indexPath.row + 3000
        
        cell.addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        cell.removeButton.addTarget(self, action: #selector(removeButtonClick), for: .touchUpInside)
        
        let modal = self.dataSourceArray.object(at: indexPath.row)  as!  ZNDishInfo
        
        if Int(modal.dishQuantity)! > 0 {
            cell.addButton.isUserInteractionEnabled = true
            cell.removeButton.isUserInteractionEnabled = true
            cell.extraTextField.isUserInteractionEnabled = true
            self.storeListTableView.allowsSelection = true
        }
        else{
            cell.addButton.isUserInteractionEnabled = false
            cell.removeButton.isUserInteractionEnabled = false
            cell.extraTextField.isUserInteractionEnabled = false
            self.storeListTableView.allowsSelection = false
        }
        
        if modal.isSelected == false {
            cell.checkImageView.image = UIImage (named: "uncheckSquare")
        }
        else{
            cell.checkImageView.image = UIImage (named: "checkSquare")
        }
        cell.extraTextField.keyboardType = .alphabet
        cell.extraTextField.delegate = self
        cell.dishNameLabel.text = modal.dishName
        cell.dishPriceLabel.text = "\(self.currencySymbol)\(modal.dishPrice)"
        cell.dishDiscriptionLabel.attributedText = modal.dishDescription.getAttributedHTMLString(modal.dishDescription)
        
        cell.dishListImageView.sd_setImage(with: URL(string:modal.dishImage), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
        cell.extraTextField.text = modal.specialIngrediant
        let myString = String(modal.dishCount)
        cell.noOfDishLabel.text = myString
        

        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let modal = self.dataSourceArray.object(at: indexPath.row)  as!  ZNDishInfo
        modal.isSelected = !modal.isSelected
        self.storeListTableView.reloadData()
    }
    
    //Mark - Text Feild Delegate Method
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view .layoutIfNeeded()
        let modal = self.dataSourceArray.object(at: textField.tag - 3000 ) as! ZNDishInfo

            modal.specialIngrediant = textField.text!
        }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        else if (textField.text?.length)! >= 100 && range.length == 0 {
            return false
        }
        return true
    }
    
    
    @IBAction func addButtonClick(sender: UIButton)
    {
        self.view .endEditing(true)
        let modal = self.dataSourceArray.object(at: sender.tag - 1000 ) as! ZNDishInfo
        modal.dishCount = modal.dishCount  + 1
        
        var floatValue : Float = NSString(string: modal.dishPrice).floatValue
        var floatdishCount : Float = Float(modal.dishCount) // 3.09999990463257
        
        modal.dishTotalCount =  floatValue * floatdishCount
        
        let indexPath = IndexPath(row: sender.tag - 1000, section: 0)
        storeListTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    @IBAction func removeButtonClick(sender: UIButton)
    {
        self.view .endEditing(true)

        let modal = self.dataSourceArray.object(at: sender.tag - 2000) as! ZNDishInfo
        if modal.dishCount <= 1 {
        }
        else
        {
            modal.dishCount = modal.dishCount  - 1
            
            var floatValue : Float = NSString(string: modal.dishPrice).floatValue
            var floatdishCount : Float = Float(modal.dishCount) // 3.09999990463257
            
            
            modal.dishTotalCount =  floatValue * floatdishCount
            
            storeListTableView.reloadData()
        }
    }
    //MARK: - backButtonAction
    
    @IBAction func backButtonAction(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - nextButtonAction
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
