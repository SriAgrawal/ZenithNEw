//
//  ZNRewardVC.swift
//  Zenith
//
//  Created by Sarvada Chauhan on 02/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNRewardVC: RContainerController,UITableViewDelegate,UITableViewDataSource {
    
    var dummyArray = Array<Dictionary<String,String>>()
    var storeObj = ZNStoreInfo()
    var rewardsArray = [String]()
    var rewardNumArray = [String]()
    @IBOutlet var shadowView: UIView!
    @IBOutlet var rewardStamp: UIButton!
    @IBOutlet var rewardCoupons: UIButton!
    @IBOutlet var rewardPoint: UIButton!
    @IBOutlet var myRewardImageView: UIImageView!
    @IBOutlet var myRewardContainerView: UIView!
    @IBOutlet var myRewardTableView: UITableView!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit();
    }
    
    //MARK: -  Helper Method
    func customInit()   {
        myRewardImageView.image = UIImage(named: "myReward_Vmart.png")
      
        self.myRewardTableView.register(UINib(nibName: "ZNStoreDetailTableViewCell",bundle:nil), forCellReuseIdentifier: "ZNStoreDetailTableViewCell")
         rewardsArray = ["On a purchasing of Rs 5000 you will get a 500 points.", "After a 5th visit you will get a 5 loyality points.","On a purchasing of Rs 5000 you will get a 500 points.", "After a 5th visit you will get a 5 loyality points.","After a 5th visit you will get a 5 loyality points."]
        rewardNumArray = ["1.", "2.","3.","4.","5."]

        //Setting Shadow of the View
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset =  CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 5
        
        
        //Set exclusive touch
         rewardPoint.isExclusiveTouch = true
         rewardCoupons.isExclusiveTouch = true
         rewardStamp.isExclusiveTouch = true
    }
    
    //MARK: - TableViewDataSource Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardsArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UIScreen.main.bounds.width == 320 {
            self.rewardPoint.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.rewardStamp.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
            self.rewardCoupons.titleLabel?.font =  UIFont.textDemiFont(fontSize: 15)
        }
       
                    var cell = tableView.dequeueReusableCell(withIdentifier:"ZNStoreDetailTableViewCell") as? ZNStoreDetailTableViewCell
        
        myRewardTableView.allowsSelection = true
        
        if cell == nil {
            cell = ZNStoreDetailTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "ZNStoreDetailTableViewCell")
        }
        
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
    
    
    //Mark: - UIButton Action Mathods
    @IBAction func rewardPointsButtonClick(_ sender: UIButton) {
        self.rewardPoint.setTitleColor(.white, for: .normal)
        self.rewardPoint.setImage(UIImage(named: "point_s.png"), for: .normal)
        self.rewardPoint.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        self.rewardCoupons.setTitleColor(.darkGray , for: .normal )
        self.rewardCoupons.setImage(UIImage(named: "coupan"), for: .normal)
        self.rewardCoupons.backgroundColor = UIColor .white
        
        self.rewardStamp.setTitleColor(.darkGray , for: .normal )
        self.rewardStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.rewardStamp.backgroundColor = UIColor .white
        self.myRewardTableView .reloadData()
    }
    
    @IBAction func rewardCouponsButtonClick(_ sender: UIButton) {
        self.rewardPoint.setTitleColor(.darkGray, for: .normal)
        self.rewardPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.rewardPoint.backgroundColor = UIColor.white
        
        self.rewardCoupons.setTitleColor(.white , for: .normal )
        self.rewardCoupons.setImage(UIImage(named: "coupan_s.png"), for: .normal)
        self.rewardCoupons.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        
        self.rewardStamp.setTitleColor(.darkGray , for: .normal )
        self.rewardStamp.setImage(UIImage(named: "stamp.png"), for: .normal)
        self.rewardStamp.backgroundColor = UIColor .white
        self.myRewardTableView .reloadData()    }
    
    @IBAction func rewardStampsButtonClick(_ sender: UIButton) {
        self.rewardPoint.setTitleColor(.darkGray, for: .normal)
        self.rewardPoint.setImage(UIImage(named: "point.png"), for: .normal)
        self.rewardPoint.backgroundColor = UIColor.white
        self.rewardCoupons.setTitleColor(.darkGray , for: .normal )
        self.rewardCoupons.setImage(UIImage(named: "coupan"), for: .normal)
        self.rewardCoupons.backgroundColor = UIColor .white
        
        self.rewardStamp.setTitleColor(.white , for: .normal )
        self.rewardStamp.setImage(UIImage(named: "stamp_s.png"), for: .normal)
        self.rewardStamp.backgroundColor = UIColor (red: 0/255.0, green: 182/255.0, blue: 251/255.0, alpha: 1.0)
        self.myRewardTableView .reloadData()
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
