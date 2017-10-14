//
//  ZNSpaRewardVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 14/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNSpaRewardVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var storeObj = ZNStoreInfo()
    var rewardsArray = [String]()
    var rewardNumArray = [String]()
    @IBOutlet var spaRewardTableView: UITableView!
    @IBOutlet var spaPoint: UIButton!
    @IBOutlet var spaStamp: UIButton!
    @IBOutlet var spaCoupon: UIButton!
    @IBOutlet var spaImageView: UIImageView!
    @IBOutlet var spaContainerView: UIView!
    @IBOutlet var shadowView: UIView!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit();
    }
    
    func customInit()   {
        spaImageView.image = UIImage(named: "myReward_Vmart.png")
        
        self.spaRewardTableView.register(UINib(nibName: "ZNStoreDetailTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
        //Setting Shadow of the View
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset =  CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 5
        
        //Set exclusive touch
        spaPoint.isExclusiveTouch = true
        spaCoupon.isExclusiveTouch = true
        spaStamp.isExclusiveTouch = true
        rewardsArray = ["On a purchasing of Rs 5000 you will get a 500 points.", "After a 5th visit you will get a 5 loyality points.","On a purchasing of Rs 5000 you will get a 500 points.", "After a 5th visit you will get a 5 loyality points.","After a 5th visit you will get a 5 loyality points."]
        rewardNumArray = ["1.", "2.","3.","4.","5."]
    }
    //MARK: - TableViewDataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UIScreen.main.bounds.width == 320 {
            self.spaPoint.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.spaStamp.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.spaCoupon.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
        }
        var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
        
        spaRewardTableView.allowsSelection = true
        
        if cell == nil {
            cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
        }
        //cell?.rewardLabel.setLineHeight(lineHeight: 25)
        cell?.selectionStyle = .none
        cell?.storeAddressLabel.text = "On a purchasing of $500 you will get a 50 points."
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: "Valid until 08/09/2017")
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 0, green: 189, blue: 251, alpha: 1.0), range: NSMakeRange(11, (attrString.length-11)))
        
        cell?.storeDistanceLabel.attributedText = attrString
        return cell!
        
    }
    
    //MARK: - TableViewDelegate Methods
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    //Mark: - UIButton Action Methods
    
    @IBAction func spaCouponButtonaction(_ sender: UIButton) {
        self.spaPoint.setTitleColor(.darkGray, for: .normal)
        self.spaPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.spaPoint.backgroundColor = UIColor.white
        
        self.spaCoupon.setTitleColor(.white , for: .normal )
        self.spaCoupon.setImage(UIImage(named: "coupan_s.png"), for: .normal)
        self.spaCoupon.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        
        self.spaStamp.setTitleColor(.darkGray , for: .normal )
        self.spaStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.spaStamp.backgroundColor = UIColor .white
        self.spaRewardTableView .reloadData()
    }
    
    @IBAction func spaPointButtonAction(_ sender: UIButton) {
        self.spaPoint.setTitleColor(.white, for: .normal)
        self.spaPoint.setImage(UIImage(named: "point_s.png"), for: .normal)
        self.spaPoint.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        
        self.spaCoupon.setTitleColor(.darkGray , for: .normal )
        self.spaCoupon.setImage(UIImage(named: "coupan"), for: .normal)
        self.spaCoupon.backgroundColor = UIColor .white
        
        self.spaStamp.setTitleColor(.darkGray , for: .normal )
        self.spaStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.spaStamp.backgroundColor = UIColor .white
        self.spaRewardTableView .reloadData()
        
        
    }
    
    @IBAction func spaStampbuttonAction(_ sender: UIButton) {
        self.spaPoint.setTitleColor(.darkGray, for: .normal)
        self.spaPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.spaPoint.backgroundColor = UIColor.white
        
        self.spaCoupon.setTitleColor(.darkGray , for: .normal )
        self.spaCoupon.setImage(UIImage(named: "coupan"), for: .normal)
        self.spaCoupon.backgroundColor = UIColor .white
        
        self.spaStamp.setTitleColor(.white , for: .normal )
        self.spaStamp.setImage(UIImage(named: "stamp_s.png"), for: .normal)
        self.spaStamp.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        
        self.spaRewardTableView.reloadData()
    }
    @IBAction func onbackButtonClick(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
