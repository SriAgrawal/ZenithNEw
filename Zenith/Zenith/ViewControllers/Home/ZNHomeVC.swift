//
//  ZNHomeVC.swift
//  Zenith
//
//  Created by Anjali on 31/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import GooglePlaces

class ZNHomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate,GMSAutocompleteViewControllerDelegate,ESTBeaconManagerDelegate {
    
    
    let FIVE_MINTUE : Double = 1000*60*5
    let homeCellIdentifier = "ZNHomeTableViewCell"
    let offerCellIdentifier = "ZNOffersTableViewCell"

    @IBOutlet var navigationTitleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var containerView: UIView!
    @IBOutlet var listAndMapView: UIView!
    @IBOutlet var listButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var offerButton: UIButton!
    @IBOutlet var searchview: UIView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var annotationView: UIView!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var storeImage: UIImageView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet var emptyTableLabel: UILabel!
    
    //Beacon
    let beaconManager = ESTBeaconManager()
    let calender = NSCalendar.current
    
    
    var pagination = ZNPagination()
    var loadExecute = Bool()
    
    let modalObj = ZNHomeModelClass()
    let isLoadMoreExecuting = false;

    private var offersEarn : String = "productPoint"
    private var offersName : String = "productName"
    private var offersPrice : String = "productPrice"
    private var offersDiscount : String = "productDiscount"
    private var offersImage: String = "productImage"
    var offersLoyaltyArray = [Any]()

    var categoryDataArray  =  NSMutableArray()
    var pageNumber = NSInteger()
    

    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        self.emptyTableLabel.isHidden = true
        super.viewDidLoad()
        customInit();
        beaconIntMethod();
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // searchTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    //MARK: -  Helper Method
    
    func beaconIntMethod() -> Void {
        
        self.beaconManager.delegate = self
        //self.beaconManager.returnAllRangedBeaconsAtOnce = true
        self.beaconManager.requestAlwaysAuthorization()
        // Monitoring the Beacon
        
       let beaconMonitor =  CLBeaconRegion(
            proximityUUID: UUID(uuidString: KStandardBeconUUID)!, identifier: "monitored region")
        
        self.beaconManager.startMonitoring(for: beaconMonitor)
        
        
        let beaconRegion = CLBeaconRegion(
            proximityUUID: UUID(uuidString: KStandardBeconUUID)!, identifier: "ranged region")
        self.beaconManager.startRangingBeacons(in: beaconRegion)

    }
    
    //MARK:- ESTBeacon Manager Delegate Method
    
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beaconObj in beacons {
            
            let beaconMonitor = CLBeaconRegion(
                proximityUUID: beaconObj.proximityUUID, major: CLBeaconMajorValue(beaconObj.major), minor: CLBeaconMinorValue(beaconObj.minor), identifier: "monitored region")
            
            let beaconMonitorRegion = CLBeaconRegion(
                proximityUUID: beaconObj.proximityUUID, major: CLBeaconMajorValue(beaconObj.major), minor: CLBeaconMinorValue(beaconObj.minor), identifier: "ranged region")
            
            self.beaconManager.startMonitoring(for: beaconMonitor)
            self.beaconManager.startRangingBeacons(in: beaconMonitorRegion)
        }
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        //call api for getting
        
        //let hour = calender.component(.hour, from: NSDate() as Date)
        //let minutes = calender.component(.minute, from: NSDate() as Date)
        
        let beaconObj = ZNHomeModelClass()

        if modalObj.beaconArray.count == 0 {
            
            beaconObj.beacon_minnor = region.minor as! Int
            beaconObj.beacon_major = region.major as! Int
            beaconObj.beacon_uid = "\(region.proximityUUID)"
            beaconObj.beacon_time = (NSDate().timeIntervalSince1970)
            modalObj.beaconArray.append(beaconObj)
            callApiforenterbecaon(modalData: modalObj)
        }
        else if modalObj.beaconArray.count > 0 {

            for beaconInnerObj in modalObj.beaconArray {

                if (Int(region.minor!) == beaconInnerObj.beacon_minnor)
                {
                    if ((NSDate().timeIntervalSince1970 - beaconInnerObj.beacon_time) > FIVE_MINTUE ){
                            //Call api
                            _ = AlertController.alert("enter \(region.minor ?? 0)")
                        
                       callApiforenterbecaon(modalData: modalObj)
                            break
                        }
                }
                else{
                    beaconObj.beacon_time = (NSDate().timeIntervalSince1970)
                    beaconObj.beacon_minnor = region.minor as! Int
                    beaconObj.beacon_major = region.major as! Int
                    beaconObj.beacon_uid = "\(region.proximityUUID)"
                    modalObj.beaconArray.append(beaconObj)
                    callApiforenterbecaon(modalData: modalObj)
                
                }
            }
        }

    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        
        _ = AlertController.alert("exit \(region.minor ?? 0)")
    }
    func beaconManager(_ manager: Any, didFailWithError error: Error) {
        
        _ = AlertController.alert(error.localizedDescription)
    }
    
    
    func customInit()   {
        
        searchTextField.delegate = self
        loadExecute = true
        listButton.isSelected = true
        
        listAndMapView.layer.borderWidth = 1
        listAndMapView.layer.borderColor = UIColor.white.cgColor
        listAndMapView.layer.cornerRadius = 4
        
        searchview.layer.borderWidth = 1
        searchview.layer.borderColor = UIColor.white.cgColor
        searchview.layer.cornerRadius = 4
        
        self.tableView.register(UINib(nibName: homeCellIdentifier, bundle: nil), forCellReuseIdentifier: homeCellIdentifier)
        self.tableView.register(UINib(nibName: offerCellIdentifier, bundle: nil), forCellReuseIdentifier: offerCellIdentifier)

        self.mapView.isHidden = true
        pagination.current_page = "1"
        self.addRefreshController()
        self.callApiMethodForCategoryList(pageNumber:pagination.current_page)
    }
    
    //MARK: - Refresh Controller
    func addRefreshController(){
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControll:)), for: .valueChanged)
    }
    
    //Refresh Controller Handller
    func handleRefresh(refreshControll : UIRefreshControl){
        loadExecute = true
        self.refreshControl.endRefreshing()
         pagination.current_page = "1"
        //self.callApiMethodForCategoryList(pageNumber:pagination.current_page)
          offerButton.isSelected ? callApiMethodToGetOfferList(pageNumber:pagination.current_page) : callApiMethodForCategoryList(pageNumber:pagination.current_page)
    }
    
    //MARK: - UITableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listButton.isSelected ? categoryDataArray.count : offersLoyaltyArray.count //categoryDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if listButton.isSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier) as! ZNHomeTableViewCell
            let data = categoryDataArray[indexPath.row] as! ZNHomeModelClass
            
            cell.profileCoverImageView.sd_setImage(with: URL(string:data.cover_image), placeholderImage: UIImage(named:"cover_image_placeholder"), options: .refreshCached)
            cell.profileImageView.sd_setImage(with: URL(string:data.icon_image), placeholderImage: UIImage(named:"icon_image_placeholder"), options: .refreshCached)
            cell.profileNameLbl.text = data.store_name
            cell.profileWorkLbl.text = data.category_name
            cell.timeLbl.text = String(format: "%.2f miles", data.distance)
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: offerCellIdentifier) as? ZNOffersTableViewCell
            
            let obj = offersLoyaltyArray[indexPath.row] as! ZNProductInfo
            cell?.pointNameLabel.text = obj.productName
            cell?.pointPriceLabel.text = obj.productEndDate
            cell?.storeNameLabel.text = obj.storeName
            cell?.storeAddressLabel.text = obj.storeAddress
            cell?.pointImageView.sd_setImage(with: URL(string: obj.productImage), placeholderImage:UIImage(named: "icon_image_placeholder"), options: SDWebImageOptions.refreshCached)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listButton.isSelected ? 255.0 : 110.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.view.endEditing(true)
        if offerButton.isSelected {
            let rowObj = offersLoyaltyArray[indexPath.row] as! ZNProductInfo
            let vcObj = ZNProductDetailVC()
            vcObj.productObj = rowObj
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
        else{
                let storeData = categoryDataArray[indexPath.row] as! ZNHomeModelClass
                let vcObj = ZNRestaurantDetailVC()
                UserDefaults.standard.set(storeData.store_id, forKey: KStore_Id)
                UserDefaults.standard.synchronize()
                vcObj.storeId = storeData.store_id as NSString
                vcObj.addressId = storeData.address_id as String
                self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset <= 10.0) {
            if (pagination.current_page  < pagination.total_page && loadExecute){
                loadExecute = false
                let stringNumber = pagination.current_page
                let numberFromString = Int(stringNumber)!+1
                let x : Int = numberFromString
                let myString = String(x)
                 offerButton.isSelected ? callApiMethodToGetOfferList(pageNumber:myString) : callApiMethodForCategoryList(pageNumber:myString)
                
            }
        }
    }

    //MARK: -  TextField delegate
       func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
       
        if let text = textField.text, !text.isEmpty
        {
            offerButton.isSelected ? callApiMethodToGetOfferList(pageNumber:"1") : callApiMethodForCategoryList(pageNumber:"1")
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.text = ""
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
            }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        modalObj.city = textField.text!

}
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.searchTextField.text = place.name
        modalObj.city = place.name

        offerButton.isSelected ? callApiMethodToGetOfferList(pageNumber:"1") : callApiMethodForCategoryList(pageNumber:"1")
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -  UIButton Methods
    @IBAction func commonBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        switch (sender.tag) {
            
        
        case 100: // Menu Button Action
            view.endEditing(true)
            listAndMapView.isHidden = false
            searchview.isHidden = true
            self.toggleSlider()
            
            break
            
        case 101:  // Search Button Action
            view.endEditing(true)
            sender.isSelected = !sender.isSelected
            listAndMapView.isHidden = sender.isSelected
            searchview.isHidden = !sender.isSelected
            if(!sender.isSelected){
                searchTextField.text = ""
                modalObj.city = ""
                modalObj.zip = ""
                offerButton.isSelected ? callApiMethodToGetOfferList(pageNumber: "1") : callApiMethodForCategoryList(pageNumber:"1")
            }
            break
            
       
        case 102:  // List Button Action
            view.endEditing(true)
            navigationTitleLabel.text = "NearBy Stores"
            self.emptyTableLabel.isHidden = true
            listButton.isSelected = true
            mapButton.isSelected = false
            offerButton.isSelected = false
            self.tableView.isHidden = false
            self.mapView.isHidden = true
            self.tableView.reloadData()
            break
            
        
        case 103: // Maps Button Action
            view.endEditing(true)
            navigationTitleLabel.text = "NearBy Stores"
            self.emptyTableLabel.isHidden = true
            listButton.isSelected = false
            mapButton.isSelected = true
            offerButton.isSelected = false
            self.tableView.isHidden = true
            self.mapView.isHidden = false

            break
            
        case 104: // Maps Button Action
            view.endEditing(true)
            navigationTitleLabel.text = "Offers"
            listButton.isSelected = false
            mapButton.isSelected = false
            offerButton.isSelected = true
            self.tableView.isHidden = false
            self.mapView.isHidden = true
            callApiMethodToGetOfferList(pageNumber:"1")
            break
            
        default:
            break
        }
    }
    
    private func addDummyAnnotations() {
        var annotationArray = [ZNPointAnnotion]()
        if categoryDataArray.count > 0 {
            self.mapView.removeAnnotations(self.mapView.annotations);
        }
        
        for item in self.categoryDataArray {
            
            print("Index Of Object---\(self.categoryDataArray.index(of: item))")
            
            let catInfo = item as! ZNHomeModelClass
            
            let annotation = ZNPointAnnotion()
            annotation.coordinate = CLLocationCoordinate2DMake(Double(catInfo.latitude)!, Double(catInfo.longitude)!)
            annotation.title = catInfo.store_name
            annotation.subtitle = String(format: "%.2f miles", catInfo.distance)
            annotation.tag = self.categoryDataArray.index(of: item) + 1000
            annotationArray.append(annotation)
        }
        mapView.addAnnotations(annotationArray)
        self.zoomToFitMapAnnotations()
    }
    
    func zoomToFitMapAnnotations(){
        if self.mapView.annotations.count == 0 {
            return
        }
        
        var topLeftCoord = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        var bottomRightCoord = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for annotation in self.mapView.annotations {
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        }
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        
        // Add a little extra space on the sides
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
        region = self.mapView.regionThatFits(region);
        self.mapView.setRegion(region, animated: true)
    }

    //MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("delegate called")
        
        if !annotation.isKind(of: ZNPointAnnotion.self) {
            return nil
        }
        
        let znAnnotaion = annotation as! ZNPointAnnotion
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        let storeInfo = self.categoryDataArray.object(at: znAnnotaion.tag!%1000) as! ZNHomeModelClass
        print("Object Tag ---\(String(describing: znAnnotaion.tag))")
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        // Adding UIButton
        let button = UIButton(frame: CGRect(x: 70, y: 100, width: 40, height: 40))
        button.setImage(UIImage(named: "arrow1"), for: .normal)
        button.addTarget(self, action: #selector(ZNHomeVC.detailButtonAction(_:)), for: .touchUpInside)
        button.tag = znAnnotaion.tag! + 1000
        //Adding UIImageView
        let imageName = "Vmart-1"
        let image = UIImage(named: imageName)
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: storeInfo.icon_image), placeholderImage: image, options: SDWebImageOptions.refreshCached)
        imageView.frame = CGRect(x: 40, y: 0, width: 50, height: 50)
        
        // Add On View
        anView?.image = UIImage(named:"pin1")
        anView?.rightCalloutAccessoryView = button
        anView?.leftCalloutAccessoryView = imageView
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
        
        print("This is added  \(views)")
    }
    
    func detailButtonAction(_ sender: UIButton){
        let storeData = categoryDataArray[sender.tag - 2000] as! ZNHomeModelClass
        let vcObj = ZNRestaurantDetailVC()
        vcObj.storeId = storeData.store_id as NSString
        vcObj.addressId = storeData.address_id as String
        self.navigationController?.pushViewController(vcObj, animated: true)
    }

    //MARK: - WebService Method
    
    
    func callApiforenterbecaon(modalData :ZNHomeModelClass ) -> Void {
        let paramArray = NSMutableArray()
        for modalObj in modalData.beaconArray {
            let paramDict = NSMutableDictionary()
            paramDict["uuid"] = modalObj.beacon_uid
            paramDict["major"] = modalObj.beacon_major
            paramDict["minor"] = modalObj.beacon_minnor
            paramArray.add(paramDict)
        }
        let paramDic = NSMutableDictionary()
        paramDic["beacons"] = paramArray
        
        ServiceHelper.callAPIWithParameters(paramDic, method:  .post, isToken: true, apiName: Kbeacon_message) { (result :AnyObject?, error :NSError?) in
            
            if let error = error  {
               // _ = AlertController.alert("", message: (error.localizedDescription))
            }else {
                if let response = result as? Dictionary<String, AnyObject> {
                    //_ = AlertController.alert("", message: "Success with no error")
                }
            }
        }
    }
    

    func callApiMethodForCategoryList(pageNumber: String) {
        
        let paramDict = NSMutableDictionary()
        paramDict[KLatitude] = "\(kAppDelegate.currentLatitude)"
        paramDict[KLongitude] = "\(kAppDelegate.currentLongitude)"
        paramDict[KLocation] = modalObj.city
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"

        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KCategoryList) { (result :AnyObject?, error :NSError?) in
            
            if error == nil {
                let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    let userDict = response.validatedValue(KCategoryList, expected: NSArray())
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.categoryDataArray.removeAllObjects()
                    }
                    self.categoryDataArray.addObjects(from: self.parseCategoryListDataWithList(categories: userDict as! NSArray) as! [Any])
                    if (self.categoryDataArray .count == 0){
                        _ = AlertController.alert("", message: "There is no store in near by your location.")
                    }
                    self.tableView.reloadData()
                    self.addDummyAnnotations()
                   // self.callApiMethodToGetOffersList()
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
    
    func callApiMethodToGetOfferList(pageNumber : String) -> Void {
        
        let paramDict = NSMutableDictionary()

        paramDict[KLatitude] = "\(kAppDelegate.currentLatitude)"
        paramDict[KLongitude] = "\(kAppDelegate.currentLongitude)"
        paramDict[KLocation] = modalObj.city
        paramDict[KPageNumber] = pageNumber
        paramDict[KPageSize] = "4"
        
        ServiceHelper.callAPIWithParameters(paramDict, method:  .post, isToken: true, apiName: KOfferList) { (result :AnyObject?, error :NSError?) in

            if error == nil {
                 let response = result as! NSDictionary
                if Int(response.object(forKey: KresponseCode) as! String) == 200 {
                    
                    self.pagination = ZNPagination .parsePageDataFromDic(dict:response.validatedValue(KPagination, expected: NSDictionary()) as! NSDictionary)
                    if (self.pagination.current_page == "1") {
                        self.offersLoyaltyArray.removeAll()
                    }
                    if let dict = response.object(forKey: "offer_list") as? NSArray {

                        if(dict.count == 0){
                            self.emptyTableLabel.isHidden = false
                        }
                        else{
                            for rowItem in dict as! Array<Dictionary<String,Any>>{
                                self.offersLoyaltyArray.append(ZNProductInfo .getOffersList(responseDic:rowItem as Dictionary<String, AnyObject>))
                            }
                        }
                        self.tableView.reloadData()
                        
                    }
                    
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


    func parseCategoryListDataWithList(categories:NSArray) -> NSMutableArray{
        
        let categoryList = NSMutableArray()
        for item in categories {
            
            let categoryInfo = item as! NSDictionary
            let catObj = ZNHomeModelClass()
            catObj.category_name = categoryInfo.validatedValue(KCategoryName, expected: "" as AnyObject) as! String
            catObj.category_id = categoryInfo.validatedValue(KCategory_Id, expected: "" as AnyObject) as! String
            catObj.category_type = categoryInfo.validatedValue(KCategory_Type, expected: "" as AnyObject) as! String
            catObj.icon_image = categoryInfo.validatedValue(KIcon_Image, expected: "" as AnyObject) as! String
            catObj.cover_image = categoryInfo.validatedValue(KCover_Image, expected: "" as AnyObject) as! String
            catObj.merchant_id = categoryInfo.validatedValue(KMerchant_Id, expected: "" as AnyObject) as! String
            catObj.address_id = categoryInfo.validatedValue(KAddress_Id, expected: "" as AnyObject) as! String
            catObj.address = categoryInfo.validatedValue(KAddress, expected: "" as AnyObject) as! String
            catObj.city = categoryInfo.validatedValue(KCity, expected: "" as AnyObject) as! String
            catObj.state = categoryInfo.validatedValue(KState, expected: "" as AnyObject) as! String
            catObj.country = categoryInfo.validatedValue(KCountry, expected: "" as AnyObject) as! String
            catObj.zip = categoryInfo.validatedValue(KZip, expected: "" as AnyObject) as! String
            catObj.latitude = categoryInfo.validatedValue(KLatitude, expected: "" as AnyObject) as! String
            catObj.longitude = categoryInfo.validatedValue(KLongitude, expected: "" as AnyObject) as! String
            
            catObj.distance = categoryInfo.validatedValue(KDistance, expected: 0 as Float as AnyObject as AnyObject) as! Float
            
            catObj.store_name = categoryInfo.validatedValue(KStore_Name, expected: "" as AnyObject) as! String
            catObj.store_id = categoryInfo.validatedValue(KStore_Id, expected: "" as AnyObject) as! String
            catObj.email = categoryInfo.validatedValue(Kemail, expected: "" as AnyObject) as! String
            catObj.mobile = categoryInfo.validatedValue(KPhoneNumber, expected: "" as AnyObject) as! String
            catObj.book_appointment = categoryInfo.validatedValue(KBook_Appointment, expected: "" as AnyObject) as! String
            catObj.book_table = categoryInfo.validatedValue(KBook_Table, expected: "" as AnyObject) as! String
            catObj.order_take_away = categoryInfo.validatedValue(KOrder_Take_Away, expected: "" as AnyObject) as! String

            categoryList.add(catObj);
        }
        
        return categoryList
    }

    //MARK: -- Memory Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


