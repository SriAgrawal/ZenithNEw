//
//  ZNBookATableVC.swift
//  Zenith
//
//  Created by Suresh patel on 09/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit


class ZNBookATableVC: UIViewController, JBDatePickerViewDelegate {

    var storeId = NSString()
    var bookObj = ZNBookTableInfo()
    var thankObj = ZNThankYou()
    
    @IBOutlet weak var datePickerView: JBDatePickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var countButton: UIButton!
    var selectedDate = Date()
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        datePickerView.delegate = self
        
        //get presented month
        self.dateLabel.text = datePickerView.presentedMonthView?.monthDescription
        selectedDateLabel.text = "Date Of Booking: \(ZNUtility().getCurrentShortDate(datePickerView.selectedDateView.date!))"
        bookObj.booking_date = (ZNUtility().getCurrentShortDate(datePickerView.selectedDateView.date!))

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //timeButton.setTitle(ZNUtility().getTimeFrom(Date()), for: .normal)
        timeButton.setTitle("Select Time", for: .normal)
        countButton.setTitle("No. of Person", for: .normal)
        bookObj.book_numberOfPerson = "No. of Person"
        bookObj.booking_time = "Select Time"
    }
    
    //MARK: - Class Instance Method

    func setupDefaults() {
    }
    
    //MARK: - BDatePickerView Method For Customization

    var colorForWeekDaysViewBackground: UIColor {
        return UIColor(red: 144.0/255.0, green: 144.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    }
    
    var colorForSelectionCircleForToday: UIColor{
        return UIColor(red: 69.0/255.0, green: 163.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    var colorForSelectionCircleForOtherDate: UIColor{
        return UIColor(red: 69.0/255.0, green: 163.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    var colorForDayLabelInMonth: UIColor{
        return UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    }
    
    var weekDaysViewHeightRatio: CGFloat{
        return 0.12
    }

    var shouldShowMonthOutDates: Bool{
        
        return false
    }
    //custom font for weekdaysView
    var fontForWeekDaysViewText: JBFont {
        
        return JBFont(name: "ITCKabelStd-Medium", size: .large)
    }
    //custom font for dayLabel
    var fontForDayLabel: JBFont {
        return JBFont(name: "ITCKabelStd-Book", size: .small)
    }

    // MARK: - JBDatePickerViewDelegate
    
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        
        selectedDateLabel.text = "Date Of Booking: \(ZNUtility().getCurrentShortDate(datePickerView.selectedDateView.date!))"
        bookObj.booking_date = (ZNUtility().getCurrentShortDate(datePickerView.selectedDateView.date!))
        }
    
    func shouldAllowSelectionOfDay(_ date: Date?) -> Bool{
        
        let disableDateThresHold = Date().onlyDate()
        return date! < disableDateThresHold! ? false : true
        }
    
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView) {
        self.dateLabel.text = datePickerView.presentedMonthView.monthDescription
    }

    // MARK: - IBAction Methods

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func loadNextMonth(_ sender: UIButton) {
        datePickerView.loadNextView()
    }
    
    @IBAction func loadPreviousMonth(_ sender: UIButton) {
        datePickerView.loadPreviousView()
    }
    
    @IBAction func timePickerButtonAction(_ sender: UIButton) {
        
        RPicker.selectDate(datePickerMode: .time, selectedDate: selectedDate, minDate: Date(), maxDate: nil) { (date) in
            sender.setTitle(ZNUtility().getTimeFrom(date), for: .normal)
            self.bookObj.booking_time = ZNUtility().getTimeFrom(date)
        }
    }
    @IBAction func bookButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if bookObj.booking_date.length == 0 {
            _ = AlertController.alert("", message: "please choose any date.")
        }
       else if bookObj.booking_time == "Select Time" {
            _ = AlertController.alert("", message: "please select time.")
        }
       else if bookObj.book_numberOfPerson == "No. of Person"  {
            _ = AlertController.alert("", message: "please select no. of person.")
            
        }
        else{
        callApiMethodToBookATable()
        }
    }
    
    @IBAction func selectPersonCountButtonAction(_ sender: UIButton) {
        OptionPickerManager().showOptionPickerSelectedIndex(-1, withData: ["No. of Person","1","2","3","4","5","6","7","8","9","10"]) { (selectedIndex, selectedItems) in
               sender.setTitle(selectedItems?.first as? String, for: .normal)
                self.bookObj.book_numberOfPerson = (selectedItems?.first as? String)!
        }
    }
    
    //MARK: - WebService Method
    
    func callApiMethodToBookATable() {
        
        let paramDict = NSMutableDictionary()
        paramDict[KStore_Id] = storeId
        paramDict[KBookDate] = ZNUtility.getTimeStampFromDate(bookObj.booking_date)
        paramDict[KBookTime] = bookObj.booking_time
        paramDict[KnumberOfPerson] = bookObj.book_numberOfPerson
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KBookATable) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.thankObj = ZNThankYou.getThankBookTableData(responseDict: response.validatedValue("booking_detail", expected:NSDictionary() as AnyObject) as? Dictionary<String, AnyObject>)
                    
                     _ = AlertController.alert("", message: response.validatedValue(KresponseMessage, expected: "" as String as AnyObject) as! String , controller: self, buttons: ["Ok"], tapBlock: { (alertAction, index) in
                        let vcObj = ZNThankYouVC()
                        vcObj.objThanks = self.thankObj
                        self.navigationController?.pushViewController(vcObj, animated: true)
                    }) 
                 
                }
                else {
                    _ = AlertController.alert("", message: response.object(forKey: KresponseMessage) as! String)
                }
            }
            else {
                _ = AlertController.alert("", message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - Did Receive Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
