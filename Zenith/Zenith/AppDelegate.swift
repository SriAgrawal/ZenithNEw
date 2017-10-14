 //
//  AppDelegate.swift
//  Zenith
//
//  Created by Mobiloitte on 29/05/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import CoreLocation
import GooglePlaces
import CoreBluetooth

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,  CBPeripheralManagerDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var navController = UINavigationController()
    var sidePanel = KYDrawerController()
    let locationManager = CLLocationManager()
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var bluetoothPeripheralManager: CBPeripheralManager?
    var isReachable = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        //Paypal Set up
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSPlacesClient.provideAPIKey("AIzaSyArkwiMmhcivcSk6-UszNhsbBKV6oK_aYE")

        //To check the internet connection
        self.setupReachability()
        self.startLocationUpdating()
        
        
        
        registerForPushNotifications(application: application)
        //Register for remote notification
        
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//                // Enable or disable features based on authorization.
//            }
//            application.registerForRemoteNotifications()
//        } else {
//            
//            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//            application.registerForRemoteNotifications()
//            // Fallback on earlier versions
//        }
        
        // set root view controller
        let homeVC = ZNLoginVC(nibName: "ZNLoginVC", bundle: nil)
        self.navController = UINavigationController(rootViewController: homeVC)
        self.navController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = self.navController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    //MARK:- Delegate of Location for getting the Current location of user
    
    func startLocationUpdating() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    func stopLocationUpdating() -> Void {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let location = locations.last
//        print("locations = \(String(describing: location?.coordinate.latitude)) \(String(describing: location?.coordinate.longitude))")
        currentLatitude = (location?.coordinate.latitude)!
        currentLongitude = (location?.coordinate.longitude)!
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
    
        print(error.localizedDescription)
    }
    
    
    //MARK: Helper Method For Manage Bluetooth
    
    func initBluetoothManager(){
        let options = [CBCentralManagerOptionShowPowerAlertKey:true] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    //MARK: CBPeripheral Manager Delegate
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if #available(iOS 10.0, *) {
            switch peripheral.state {
            case CBManagerState.poweredOn:
                print ("on")
                break
            case CBManagerState.poweredOff:
                print ("off")
                break
                
            case CBManagerState.resetting:
                print ("reset")
                break
                
            case CBManagerState.unauthorized:
                print ("unauth")
                break
                
            case CBManagerState.unsupported:
                print ("unsuppo")
                break
                
            case CBManagerState.unknown:
                print ("unknown")
                break
                
            default : break
                
            }
        }
    }

    
    //MARK:- Side menu @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    private var privateSideMenuController: MASliderViewController?
    
    var sideMenuController: MASliderViewController {
        
        if let privateSideMenuController = privateSideMenuController {
            return privateSideMenuController
        }
        let mainViewController   = ZNHomeVC(nibName: "ZNHomeVC", bundle: nil)
        let drawerViewController = ZNSideMenuVC(nibName: "ZNSideMenuVC", bundle: nil)
        let centerNavController = UINavigationController(rootViewController: mainViewController)
        centerNavController.isNavigationBarHidden = true
        let sliderViewController = MASliderViewController()
        sliderViewController.centerViewController = centerNavController
        sliderViewController.leftViewController = drawerViewController
        sliderViewController.leftDrawerWidth = window_width - 60
        privateSideMenuController = sliderViewController
        return privateSideMenuController!
    }

    func logout(){
        
        self.navController.popToRootViewController(animated: false)
        UserDefaults.standard.set(false, forKey: KisLoggedIn)
        UserDefaults.standard.removeObject(forKey: KUser_Id)
        UserDefaults.standard.removeObject(forKey: KApi_Key)
        kAppDelegate.stopLocationUpdating()
        UserDefaults.standard.synchronize()
        self.privateSideMenuController = nil
    }
    
    fileprivate func setupReachability() {
        
        // Allocate a reachability object
        let reach = Reachability.forInternetConnection()
        self.isReachable = (reach?.isReachable())!
        
        // Set the blocks
        
        reach?.reachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = true
            })
        }
        
        reach?.unreachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = false
            })
        }
        
        reach?.startNotifier()
    } 

    
    //Mark - Method for the Application Notification
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        UserDefaults.standard.setValue(deviceTokenString, forKey: Kdevice_token)
        UserDefaults.standard.synchronize()
        
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        UserDefaults.standard.setValue("811e90a2cb4c2de225120e1c6192fc12f5662876", forKey: Kdevice_token)
        UserDefaults.standard.synchronize()
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                
                if (granted){
                    
                    UIApplication.shared.registerForRemoteNotifications()
                    
                }
                    
                else{
                    
                    //Do stuff if unsuccessful...
                    
                }
                
            })
            
        }
            
        else{
            
            //If user is not on iOS 10 use the old methods we've been using
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        
    }
    

    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound,.badge])

        
        //Handle the notification
    }
    

    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Handle the notification
        
        let dic = response.notification.request.content.userInfo as! Dictionary<String, AnyObject>
        
        //_ = AlertController.alert("", message: "\(dic)")
        
        let notificationDict = dic.validatedValue("aps", expected: NSDictionary()) as? Dictionary<String,AnyObject>
        let notificationBody = notificationDict?.validatedValue("notificationData", expected: NSDictionary()) as? Dictionary<String,AnyObject>
        let notifyType = notificationBody?.validatedValue("noti_type", expected: "" as AnyObject) as! String
        
        if notifyType == "broadcast" {
            _ = AlertController.alert("", message: notificationDict?.validatedValue("alert", expected: "" as AnyObject) as! String)
        }
        else{
        
            _ = AlertController.alert("", message: notificationBody?.validatedValue("message", expected: "" as AnyObject) as! String , controller: self , buttons: ["Cancel", "View"], tapBlock: { (UIAlertAction, index) in
                
                if index == 0 {
                    if self.navController.topViewController is ZNRestaurantDetailVC {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreenForTheItem"), object: nil, userInfo: notificationBody)
                    }else {
                        let storeVC = ZNRestaurantDetailVC(nibName: "ZNRestaurantDetailVC", bundle: nil)
                        storeVC.fromNotification = true
                        storeVC.storeId = "\(notificationBody?.validatedValue("store_id", expected: "" as AnyObject) ?? "" as AnyObject)" as NSString
                        storeVC.addressId = "\(String(describing: notificationBody?.validatedValue("store_address_id", expected: "" as AnyObject)))" as String
                        self.navController.pushViewController(storeVC, animated: true)
                    }
                }
            })
        
       }
    }
    
    //Push notification received
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
//        RemoteNotificationHelper.didReceiveRemoteNotification(application: application, data: data)
        
        let dic = data as! Dictionary<String, AnyObject>
        
        let notificationDict = dic.validatedValue("aps", expected: NSDictionary()) as? Dictionary<String,AnyObject>
        let notificationBody = notificationDict?.validatedValue("notificationData", expected: NSDictionary()) as? Dictionary<String,AnyObject>
       let notifyType = notificationBody?.validatedValue("noti_type", expected: "" as AnyObject) as! String
        
        if notifyType == "broadcast" {
            _ = AlertController.alert("", message: notificationDict?.validatedValue("alert", expected: "" as AnyObject) as! String)
        }
        else{
            
            _ = AlertController.alert("", message: notificationBody?.validatedValue("message", expected: "" as AnyObject) as! String , controller: self , buttons: ["Cancel", "View"], tapBlock: { (UIAlertAction, index) in
                
                if index == 0 {
                    if self.navController.topViewController is ZNRestaurantDetailVC {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreenForTheItem"), object: nil, userInfo: notificationBody)
                    }else {
                        let storeVC = ZNRestaurantDetailVC(nibName: "ZNRestaurantDetailVC", bundle: nil)
                        storeVC.fromNotification = true
                        storeVC.storeId = "\(notificationBody?.validatedValue("store_id", expected: "" as AnyObject) ?? "" as AnyObject)" as NSString
                        storeVC.addressId = "\(String(describing: notificationBody?.validatedValue("store_address_id", expected: "" as AnyObject)))" as String
                        self.navController.pushViewController(storeVC, animated: true)
                    }
                }
            })
            
        }
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.startLocationUpdating()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
 }
