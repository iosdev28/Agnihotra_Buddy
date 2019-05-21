//
//  ViewController.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 27/12/18.
//  Copyright © 2018 dilip. All rights reserved.
//

import UIKit
import DatePickerDialog
import GooglePlacePicker
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import CoreData
import AVFoundation
import Crashlytics
import UserNotifications



class ViewController: UIViewController {
    
    @IBOutlet var agnihoraBuddyTitlLabel: UILabel!
    var isFromSetting = false
    var dictMain = NSMutableDictionary()
    
    var startDate = Date()
    var endDate = Date()
    var countAPI = 0
    
    var lat         : Double = 0.0
    var long        : Double = 0.0
    var address     : String!
    var savedata    :[[String: Any]] = []
    var pickerHidden = true
    
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var timeZoneForLocationLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var confIrm: UIButton!
    @IBOutlet var changeTimeZone: UIButton!
    @IBOutlet var settimeZoneNameLbl    : UILabel!
    @IBOutlet var timeZoneConforimView  : UIView!
    @IBOutlet var stackView             : UIStackView!
    @IBOutlet var lblTimeZonePopUp        : UILabel!
    @IBOutlet var tblView               : UITableView!
    @IBOutlet var shadowView            : UIView!
    @IBOutlet var chooseMapView         : UIView!
    @IBOutlet var addLocatonView        : UIView!
    @IBOutlet var popVIew               : UIView!
    @IBOutlet var popViewDeleteSingle   : UIView!
    @IBOutlet var placeLebal            : UILabel!
    @IBOutlet weak var tapLabel         : UILabel!
    @IBOutlet var timeLabel             : UILabel!
    @IBOutlet weak var labelRise        : UILabel!
    @IBOutlet weak var labelSunset      : UILabel!
    @IBOutlet var enterManuallyButton: UIButton!
    @IBOutlet var useGoogleMapButton: UIButton!
    @IBOutlet var mapPin: UIButton!
    
    var saveAlldata                    : NSDictionary!
    var timer                       = Timer()
    var selectedTimeZone            = ""
    var defaults = UserDefaults.standard
    var dicti:[String:String] = [:]
    
    var nextAgniHotraTime = ""
    var isToday = true
    
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnRename: UIButton!
    
    
      // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        languageSetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSetup()
    }
    
   // MARK: - Setup
    
    func languageSetUp()
    {
        enterManuallyButton.setTitle(NSLocalizedString("Enter Manually", comment: ""), for: .normal)
        useGoogleMapButton.setTitle(NSLocalizedString("Use Googlle Map",comment: ""),for:.normal)
        changeTimeZone.setTitle(NSLocalizedString("Change TimeZone", comment: ""), for: .normal)
        confIrm.setTitle(NSLocalizedString("Confirm",comment: ""),for:.normal)
        titleLabel.text = NSLocalizedString("titleLabel", comment: "")
        timeZoneForLocationLabel.text = NSLocalizedString("Please confirm timezone for this location", comment: "")
        agnihoraBuddyTitlLabel.text = NSLocalizedString("Agnihotra Buddy", comment: "")
        placeLebal.text = NSLocalizedString("Location Not set,Click on Icon!", comment: "")
        btnDelete.setTitle(NSLocalizedString("Delete this Location", comment: "Delete this Location"), for: .normal)
        btnRename.setTitle(NSLocalizedString("Rename this Location", comment: "Rename this Location"), for: .normal)
    }
    
    func setUp()
    {
        // Long Press Gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressed(sender:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 2.0
        self.mapPin.addGestureRecognizer(longPressRecognizer)
        
        // NotificationCenter
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        lblTimeZonePopUp.text = NSTimeZone.local.abbreviation()! + " "  + NSTimeZone.local.identifier
        selectedTimeZone = NSTimeZone.local.identifier
        
        // Date
        let currentDate   = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateStr =  dateFormatter.string(from: currentDate)
        self.tapLabel.text = dateStr

        // Tap Press Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector((tapDateLabel)))
        let tapset = UITapGestureRecognizer(target: self, action: #selector((handleFrontTap)))
        tapLabel.isUserInteractionEnabled = true
        tapLabel.addGestureRecognizer(tap)
        shadowView.isUserInteractionEnabled = true
        shadowView.addGestureRecognizer(tapset)
        setValueOnLocationLbl()
    }
    
    func viewSetup()
    {
        // Date Timer
        runTimer()
        
        // Screen Always On From Settings
        if ((defaults.object(forKey:"screenOn") != nil) && (UserDefaults.standard.bool(forKey: "screenOn") == true))
        {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else
        {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        // Local Notification Setup
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
            }
        })
        
        if isFromSetting == true {
            setValueOnLocationLbl()
        }
        isFromSetting = false
    }
    
    @objc func appMovedToForeground() {
        setValueOnLocationLbl()
        let currentDate   = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateStr =  dateFormatter.string(from: currentDate)
        self.tapLabel.text = dateStr
    }
    
    
       // MARK: - Custom Methods
    
    func deleteAllLocation()
    {
        let AgnihotraBuddyTitle = NSLocalizedString("Agnihotra Buddy", comment: "")
        let msg = NSLocalizedString("Are You Sure You Wish To Delete All Location", comment: "")
        
        let cancelBtn = NSLocalizedString("Cancel", comment: "Cancel")
        let procedButton = NSLocalizedString("Proceed", comment: "Proceed")
        
        
        let uiAlert = UIAlertController(title: AgnihotraBuddyTitle, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: procedButton, style: .default, handler: { action in
            UserDefaults.standard.removeObject(forKey: "placeData")
            UserDefaults.standard.removeObject(forKey: "selectedIndex")
            //   self.placeLebal.text = ""
            self.setValueOnLocationLbl()
            print("Click of default button")
            self.savedata.removeAll()
            self.addLocatonView.isHidden = true
            self.chooseMapView.isHidden = true
            self.shadowView.isHidden = true
            self.popVIew.isHidden = true
            
            UserDefaults.standard.set(nil, forKey: "lastSelected")
            UserDefaults.standard.set("", forKey: "address")
            UserDefaults.standard.set("", forKey: "lat")
            UserDefaults.standard.set("", forKey: "long")
        }))
        
        uiAlert.addAction(UIAlertAction(title: cancelBtn, style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
    }
    
    func animateOut(){
        
        UIView.animate(withDuration: 0.3, animations:{
            self.popVIew.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popVIew.alpha = 0
        }){ (success: Bool) in
            self.popVIew.removeFromSuperview()
            
        }
    }
    
    func setAlarmClock()
    {
        if (UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)")) != nil {
            let dicted = UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)") as! NSMutableDictionary
            print(dicted)
            let dt = Date()
            for i in 0...30
            {
                let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
                let next30Days = cal?.date(byAdding: NSCalendar.Unit.NSDayCalendarUnit, value: i, to: dt, options: NSCalendar.Options.matchStrictly)
                
                if (dicted[next30Days!.convertDatetoStringGet(dt: next30Days!)] == nil)
                {
                    
                    return
                }
                let todayDict = dicted[dt.convertDatetoStringGet(dt: next30Days!)] as! NSMutableDictionary
                let sunRiseTimeString = todayDict["rise"] as! String
                let sunSetTimeString = todayDict["set"] as! String
                let sunRiseArray = sunRiseTimeString.components(separatedBy: ":")
                let sunSetArray = sunSetTimeString.components(separatedBy: ":")
                
                let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: next30Days!)
                
                let minutes  = NSInteger(UserDefaults.standard.value(forKey: "alarmTime") as! String)
                // Change the time to 9:30:00 in your locale
                components.hour = NSInteger(sunRiseArray[0] )
                components.minute = NSInteger(sunRiseArray[1] )
                components.second = NSInteger(sunRiseArray[2] )
                
                var sunRiseDate = gregorian.date(from: components)!
                sunRiseDate = sunRiseDate.addingTimeInterval(TimeInterval(-(60 * minutes!)))
                
                
                components.hour = NSInteger(sunSetArray[0])
                components.minute = NSInteger(sunSetArray[1])
                components.second = NSInteger(sunSetArray[2])
                
                var sunSetDate = gregorian.date(from: components)!
                sunSetDate = sunSetDate.addingTimeInterval(TimeInterval(-(60 * minutes!)))
                setLocalPushNotificationForAlarm(timeArray: sunRiseArray as NSArray, dt: sunRiseDate)
                setLocalPushNotificationForAlarm(timeArray: sunSetArray as NSArray, dt: sunSetDate)
            }
        }
    }
    
    func setLocalPushNotificationForAlarm(timeArray : NSArray , dt : Date)
    {
        //Local Notification
        let content = UNMutableNotificationContent()
        content.title = "Agnihotra Buddy"
        content.body = "Alarm Time"
        content.sound = UNNotificationSound.default()
        //  content.setValue(true, forKey: "shouldAlwaysAlertWhileAppIsForeground")
        
        
        let gregorian = Calendar(identifier: .gregorian)
        //let now = Date()
        let components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: String(format:"%@,%@",dt as CVarArg,timeArray[2] as! CVarArg), content: content, trigger: trigger)
        print("INSIDE NOTIFICATION")
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error = error {
                print("SOMETHING WENT WRONG")
            }
        })
    }
    
    func cancelAllLocalNotification()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    @objc func presentTimeZonePicker(){
        let vc = NavigationController()
        vc.vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func setClockType(dicted : NSDictionary)
    {
        let dt = Date()
        let todayDict = dicted[dt.convertDatetoStringGet(dt: dt)] as! NSMutableDictionary
        var riseTime = ""
        var setTime = ""
        
        if(defaults.object(forKey:"clockType") != nil && UserDefaults.standard.bool(forKey: "clockType") == false)
        {
            riseTime = CommonUtils.convertStringToDateIn12Hour(str: todayDict["rise"] as? String ?? "")
            setTime = CommonUtils.convertStringToDateIn12Hour(str: todayDict["set"] as? String ?? "")
            if !riseTime.contains("-"){
                if !setTime.contains("-"){
                    self.labelRise.text = riseTime
                    self.labelSunset.text = setTime
                }else{
                    self.labelRise.text = ""
                    self.labelSunset.text = ""
                }
            }else{
                self.labelRise.text = ""
                self.labelSunset.text = ""
            }
        }
        else
        {
            if !(todayDict["rise"] as? String)!.contains("-"){
                if !(todayDict["set"] as? String)!.contains("-"){
                    self.labelRise.text = todayDict["rise"] as? String
                    self.labelSunset.text = todayDict["set"] as? String
                }else{
                    self.labelRise.text = ""
                    self.labelSunset.text = ""
                }
            }else{
                self.labelRise.text = ""
                self.labelSunset.text = ""
            }
            
        }
    }
    
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.tick)), userInfo: nil, repeats: true)
    }
    func getNextAgnihotra()
    {
        isToday = true
        let dict = NSMutableDictionary()
        dict["rise"] = labelRise.text
        dict["set"] = labelSunset.text
        dict["lat"] = self.lat
        dict["long"] = self.long
        (nextAgniHotraTime,isToday) = CommonUtils.getNextAgnihotraTime(dict: dict) as! (String, Bool) 
        
    }
    
    func meditattionSoundCheck()
    {
        if ((defaults.object(forKey:"MeditationSwitch") != nil) && (UserDefaults.standard.bool(forKey: "MeditationSwitch") == true) && ((Date().getCurrentTimein24Hour() == nextAgniHotraTime) || (timeLabel.text == "0:0:0"))) {
            getNextAgnihotra()
            let systemSoundID: SystemSoundID = 1005
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func showClockType()
    {
        if((defaults.object(forKey:"countDownSwitch") == nil) || ((defaults.object(forKey:"countDownSwitch") as! Bool) == false))
        {
            if(defaults.object(forKey:"clockType") != nil)
            {
                if (UserDefaults.standard.bool(forKey: "clockType") == true) {
                    
                    let today1 = NSDate()
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "HH:mm:ss"
                    let timestring = dateFormatter1.string(from: today1 as Date)
                    timeLabel.text = timestring
                    print(timestring)
                    return
                }
                if (UserDefaults.standard.bool(forKey: "clockType") == false) {
                    //   let today1 = NSDate()
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "h:mm:ss a"
                    dateFormatter1.locale = Locale(identifier: "en-US")
                    let timestring = dateFormatter1.string(from: Date())
                    timeLabel.text = timestring
                    print(timestring)
                    return
                }
            }
                
            else {
                timeLabel.text = DateFormatter.localizedString(from: Date(),dateStyle: .none,timeStyle: .medium)
                
            }
        }
        else
        {
            if (nextAgniHotraTime.count > 0)
            {
                
                var elapsed = 0.0
                
                if(defaults.object(forKey:"clockType") != nil && UserDefaults.standard.bool(forKey: "clockType") == false)
                {
                    elapsed = CommonUtils.convertStringToDateForCountDown12Hour(str: nextAgniHotraTime, isToday: isToday).timeIntervalSince(Date())
                }
                else
                {
                    elapsed = CommonUtils.convertStringToDateForCountDown(str: nextAgniHotraTime, isToday: isToday).timeIntervalSince(Date())
                }
                
                
                print(nextAgniHotraTime)
                let (h,m,s) = CommonUtils.secondsToHoursMinutesSeconds(seconds: Int(elapsed))
                print(h,m,s)
                timeLabel.text = String(format:"%02d:%02d:%02d",h,m,s)
                if(h < 1 && m < 1 && s < 1)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // your code here
                        self.getNextAgnihotra()
                    }
                    
                }
            }
            
        }
    }
    
    
    @objc func tick() {
        
        if self.viewIfLoaded?.window != nil {
            // viewController is visible
            
            meditattionSoundCheck()
            
            showClockType()
            
        }
    }
    
    
    func hitHomeAPI()
    {
        
        if ReachabilityNetwork.isConnectedToNetwork() == true
        {
            
            MMTHUD.showHUDAddedTo(self.view, animated: true)
            
            startDate = Date()
            endDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
            hitHomeApi(strtDate: startDate.convertDatetoString(dt: startDate), endDate: (endDate.convertDatetoString(dt: endDate)))
        }
        
    }
    // MARK: - Show Pop Up's

    func chooseMapViewPopup(){
        chooseMapView.isHidden = false
        self.view.addSubview(chooseMapView)
        chooseMapView.center = self.view.center
        chooseMapView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        chooseMapView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.chooseMapView.alpha = 1
            self.chooseMapView.transform = CGAffineTransform.identity
        }
    }
    
    func showTimeZonepopup(){
        popVIew.isHidden = false
        self.view.addSubview(popVIew)
        popVIew.center = self.view.center
        popVIew.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popVIew.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.popVIew.alpha = 1
            self.popVIew.transform = CGAffineTransform.identity
        }
    }
    
     func showAddLocationView(){
        
        addLocatonView.isHidden = false
        self.view.addSubview(addLocatonView)
        addLocatonView.center = self.view.center
        addLocatonView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addLocatonView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.addLocatonView.alpha = 1
            self.addLocatonView.transform = CGAffineTransform.identity
            
        }
        
        
    }
    
    
    // MARK: - Location Label Method
    
    
    func setValueOnLocationLbl() {
        
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            var arr = ((UserDefaults.standard.object(forKey: "placeData") as! NSArray) as! [[String : Any]])
            
            let selectedIndex =   UserDefaults.standard.object(forKey: "selectedIndex") as! NSInteger
            var dict = arr[selectedIndex]
            
            placeLebal.text = String(format: "%@ (%f, %f) %@",
                                     dict["address"] as! String,
                                     dict["long"]  as! Double,
                                     dict["lat"] as! Double, dict["timeZone"] as! String)
            self.lat = dict["lat"] as! Double
            self.long =  dict["long"]  as! Double
            self.address = dict["address"] as! String
            
            //Set Alarm Clock
            if (defaults.object(forKey:"alarmSwitch") != nil && UserDefaults.standard.bool(forKey: "alarmSwitch") == true)
            {
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                    if requests.count < 20
                    {
                        self.cancelAllLocalNotification()
                        self.setAlarmClock()
                    }
                })
            }
            
            if (UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)")) != nil {
                let dicted = UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)") as! NSMutableDictionary
                print(dicted)
                let dt = Date()
                print(dt.convertDatetoStringGet(dt: dt))
                if (dicted[dt.convertDatetoStringGet(dt: dt)] == nil)
                {
                    CommonUtils.createAlert(title: "Agnihotra Buddy", message: "Oops! Data not found for date. Try updating Database", obj: self)
                    return
                }
                
                setClockType(dicted: dicted)
                getNextAgnihotra()
                runTimer()
             
            }
                
            else
            {
                CommonUtils.createAlert(title: "Agnihotra Buddy", message: "Oops! Data not found for date. Try updating Database", obj: self)
            }
        }
        else
        {
            // placeLebal.text = Message_Constants.KLOCATIONNOTSET
            placeLebal.text = NSLocalizedString("Location Not set,Click on Icon!", comment: "")
            labelRise.text = ""
            labelSunset.text = ""
        }
        
    }
    
    
    
    
    func setValueOnSunriseLabel(selecteddate : String)
    {
        if (UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)")) != nil   {
            
            let dicted = UserDefaults.standard.object(forKey: "\(self.lat) + \(self.long)") as! NSMutableDictionary
            print(dicted)
            if (dicted[selecteddate] == nil)
            {
                CommonUtils.createAlert(title: "Agnihotra Buddy", message: "Oops! Data not found for date. Try updating Database", obj: self)
                return
            }
            let todayDict = dicted[selecteddate] as! NSMutableDictionary
            var riseTime = ""
            var setTime = ""
            if(defaults.object(forKey:"clockType") != nil && UserDefaults.standard.bool(forKey: "clockType") == false)
            {
                riseTime = CommonUtils.convertStringToDateIn12Hour(str: todayDict["rise"] as? String ?? "")
                setTime = CommonUtils.convertStringToDateIn12Hour(str: todayDict["set"] as? String ?? "")
                if !riseTime.contains("-"){
                    if !setTime.contains("-"){
                        self.labelRise.text = riseTime
                        self.labelSunset.text = setTime
                    }else{
                        self.labelRise.text = ""
                        self.labelSunset.text = ""
                    }
                }else{
                    self.labelRise.text = ""
                    self.labelSunset.text = ""
                }
            }
            else
            {
                if !(todayDict["rise"] as? String)!.contains("-"){
                    if !(todayDict["set"] as? String)!.contains("-"){
                        self.labelRise.text = todayDict["rise"] as? String
                        self.labelSunset.text = todayDict["set"] as? String
                    }else{
                        self.labelRise.text = ""
                        self.labelSunset.text = ""
                    }
                }else{
                    self.labelRise.text = ""
                    self.labelSunset.text = ""
                }
            }
            
            
            
        }
        else
        {
            CommonUtils.createAlert(title: "Agnihotra Buddy", message: "Oops! Data not found for date. Try updating Database", obj: self)
        }
    }
    
    func saveDataofLocation()
    {
        self.savedata.removeAll()
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            print(UserDefaults.standard.object(forKey: "placeData") ?? "")
            savedata = ((UserDefaults.standard.object(forKey: "placeData") as! NSArray) as! [[String : Any]])
            UserDefaults.standard.set(savedata.count, forKey: "selectedIndex")
        }
            
        else{
            UserDefaults.standard.set(0, forKey: "selectedIndex")
        }
        
        savedata.append(["lat": self.lat, "long": self.long, "address": self.address ,"timeZone" : self.selectedTimeZone])
        
        if savedata.count > 0 {
            
        UserDefaults.standard.set(savedata, forKey: "placeData")
        }
    }
    
    // convert Coordinate into Address
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        CommonUtils.getAddressFromLocation(lat: pdblLatitude, longitude: pdblLongitude) { (value) in
            print(value)
            self.address = value
            self.showTimeZonepopup()
        }
    }
    
    // MARK: - UIButton Action
    
    @IBAction func didTapSetting(_ sender: Any) {
        isFromSetting = true
        let popupvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingPopUpVC") as? SettingPopUpVC
        self.addChildViewController(popupvc!)
        popupvc?.view.frame = self.view.frame
        self.view.addSubview((popupvc?.view)!)
        popupvc?.didMove(toParentViewController: self)
    }
    
    @IBAction func didTapMapPin(_ sender: UIButton) {
        
        lblTimeZonePopUp.text = NSTimeZone.local.abbreviation()! + " "  + NSTimeZone.local.identifier
        selectedTimeZone = NSTimeZone.local.identifier
        shadowView.isHidden = false
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            showAddLocationView()
            tblView.reloadData()
        }
        else
        {
            chooseMapViewPopup()
        }
    }
    
    @IBAction func didTapEnterManually(_ sender: Any) {
        
        chooseMapView.isHidden = true
        shadowView.isHidden = false
        let find = self.storyboard?.instantiateViewController(withIdentifier: "FindLocation")as! FindLocation
        find.delegate = self
        find.delegateSave = self
        self.navigationController?.pushViewController(find, animated: true)
        
    }
    
    @IBAction func didTapUseGoogleMap(_ sender: Any) {
        
        if ReachabilityNetwork.isConnectedToNetwork() == true{
            let find = self.storyboard?.instantiateViewController(withIdentifier: "MapScreenVC")as! MapScreenVC
            find.delegate = self
            self.navigationController?.pushViewController(find, animated: true)
            chooseMapView.isHidden = true
            shadowView.isHidden = false
        }else{
            chooseMapView.isHidden = true
            shadowView.isHidden = false
            CommonUtils.createAlert(title: "Agnihotra Buddy", message: "No Network Available", obj: self)
        }
    }
    
    @IBAction func didTapOnTimeZone(_ sender: Any) {
        popVIew.removeFromSuperview()
        presentTimeZonePicker()
    }
    
    
    @IBAction func didTapOnConFirm(_ sender: Any) {
        hitHomeAPI()
        shadowView.isHidden = true
        animateOut()
        saveDataofLocation()
    }
    @IBAction func deleteSingleLocation(_ sender: Any) {
        self.popViewDeleteSingle.isHidden = true
        self.shadowView.isHidden = true
        
        let alertController = UIAlertController(title: NSLocalizedString("Delete this Location ?", comment: "Delete this Location ?") , message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: NSLocalizedString("YES", comment: "YES") , style: UIAlertActionStyle.default, handler: { alert -> Void in
            // Delete Single Location
            if (UserDefaults.standard.object(forKey: "placeData")) != nil
            {
                var arr = ((UserDefaults.standard.object(forKey: "placeData") as! NSArray) as! [[String : Any]])
                
                let selectedIndex =   UserDefaults.standard.object(forKey: "selectedIndex") as! NSInteger
                arr.remove(at: selectedIndex)
                
                if(arr.count >= 1)
                {
                    UserDefaults.standard.set(arr, forKey: "placeData")
                    UserDefaults.standard.set(0, forKey: "selectedIndex")
                    
                }
                else
                {
                    UserDefaults.standard.removeObject(forKey: "placeData")
                    UserDefaults.standard.removeObject(forKey: "selectedIndex")
                    
                }
                UserDefaults.standard.synchronize()
                self.labelRise.text = ""
                self.labelSunset.text = ""
                self.placeLebal.text = ""
                self.lat = 0.0
                self.long = 0.0
                self.address = ""
                self.didTapMapPin(self.mapPin)
                self.placeLebal.text = NSLocalizedString("Location Not set,Click on Icon!", comment: "")
                
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("NO", comment: "NO"), style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func renameSingleLocation(_ sender: Any) {
        self.popViewDeleteSingle.isHidden = true
        self.shadowView.isHidden = true
        
        let alertController = UIAlertController(title: NSLocalizedString("Enter new name for location", comment: "Enter new name for location") , message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Location Name", comment: "Location Name")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("RENAME THIS LOCATION", comment: "RENAME THIS LOCATION") , style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if (firstTextField.text!.count > 0)
            {
                // Delete Single Location
                if (UserDefaults.standard.object(forKey: "placeData")) != nil
                {
                    var arr = ((UserDefaults.standard.object(forKey: "placeData") as! NSArray) as! [[String : Any]])
                    
                    let selectedIndex =   UserDefaults.standard.object(forKey: "selectedIndex") as! NSInteger
                    
                    arr[selectedIndex].updateValue(firstTextField.text!, forKey: "address")
                    
                    UserDefaults.standard.set(arr, forKey: "placeData")
                    
                    
                    UserDefaults.standard.synchronize()
                    self.setValueOnLocationLbl()
                    
                }
            }
            
            
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "CANCEL") , style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func datePickerTapped() {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.month = 12
            let oneYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            let datePicker = DatePickerDialog(textColor: .black,
                                              buttonColor: .black,
                                              font: UIFont.boldSystemFont(ofSize: 17),
                                              showCancelButton: true)
            datePicker.show("DatePickerDialog",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            minimumDate: currentDate,
                            maximumDate: oneYearAgo,
                            datePickerMode: .date) { (date) in
                                if let dt = date {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MMMM/yyyy"
                                    self.tapLabel.text = formatter.string(from: dt)
                                    
                                    self.setValueOnSunriseLabel(selecteddate: dt.convertDatetoStringGet(dt: dt))
                                    
                                }
            }
            
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
            if (count == 3)
            {
                return (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count + 1
            }
            return (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count + 2
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell")as! AddLocationCell
        let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
        if indexPath.row <  count {
            cell.lbl.text = (((UserDefaults.standard.object(forKey: "placeData") as! NSArray)[indexPath.row] as! NSDictionary)["address"] as? String)
        }
        else if indexPath.row == count && count != 3
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            cell.lbl.text = NSLocalizedString("Add Location", comment: "Add Location")
        }
        else
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            cell.lbl.text = NSLocalizedString("Delete All Location", comment: "Delete All Location")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
        if indexPath.row < count
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == count && count != 3
        {
            return 50.0
        }
        else
        {
            return 50.0
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
        if indexPath.row <  count {
            let dict = (UserDefaults.standard.object(forKey: "placeData") as! NSArray)[indexPath.row] as! NSDictionary
            UserDefaults.standard.set(indexPath.row, forKey: "selectedIndex")
            let currentDate   = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let dateStr =  dateFormatter.string(from: currentDate)
            self.tapLabel.text = dateStr
            saveAlldata = dict
            print(dict["address"] as! String)
            self.setValueOnLocationLbl()
        }
        else if indexPath.row == count && count != 3
        {
            addLocatonView.isHidden = true
            chooseMapViewPopup()
        }
        else
        {
         deleteAllLocation()
           
        }
    }
    
   
}



extension ViewController: TimeZonePickerViewControllerDelegate{
    func timeZonePickerView(_ timeZonePickerViewController: UITimeZonePickerViewController, didSelectTimeZone timeZone: TimeZone) {
        
        print("Timezone selected is", timeZone.identifier)
        self.selectedTimeZone = timeZone.identifier
        
        saveDataofLocation()
        hitHomeAPI()
    }
}

extension Date
{
    func convertDatetoString(dt : Date) -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        let myString = formatter.string(from: dt) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MM/dd/yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        return myStringafd
    }
    
    func convertDatetoStringGet(dt : Date) -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: dt) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        return myStringafd
    }

    func getGMTTimeDate() -> Date {
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        comp.calendar = Calendar.current
        comp.calendar?.locale = NSLocale.current
        // comp.timeZone = TimeZone(abbreviation: "GMT")!
        return Calendar.current.date(from: comp)!
    }
    func tomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = Date() // Current date
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
        
        return tomorrow!
    }
    
    func getCurrentTimein24Hour() -> String
    {
        let today1 = NSDate()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        let timestring = dateFormatter1.string(from: today1 as Date)
        // print(timestring)
        return timestring
    }
}

extension ViewController
{
    func hitHomeApi(strtDate: String, endDate: String) {
        
        Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
            
            let setLat: Double = self.lat
            let latNum:String = String(format:"%f", setLat)
            
            let setLong: Double = self.long
            let latLongNum:String = String(format:"%f", setLong)
            
            multipartFormData.append(latNum.data(using: String.Encoding.utf8)!, withName: "lat_deg")
            multipartFormData.append(latLongNum.data(using: String.Encoding.utf8)!, withName: "lon_deg")
            multipartFormData.append(strtDate.data(using: String.Encoding.utf8)!, withName: "date")
            multipartFormData.append(endDate.data(using: String.Encoding.utf8)!, withName: "end_date")
            multipartFormData.append(self.selectedTimeZone.data(using: String.Encoding.utf8)!, withName: "timeZoneId")
            
            
        }, to: BASEURL, method: .post, headers: nil, encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
            switch encodingResult
            {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (Response) in
                    
                    let responseDict = Response.result.value
                    self.parseData(responseDict: responseDict as! Dictionary<String, AnyObject>)
                })
                
                
                
            case .failure(let error):
                print(error)
                MMTHUD.hideHUDForView(self.view, animated: true)
                
                
            }
        })
    }
    
    func parseData(responseDict : Dictionary<String, AnyObject>)
    {
        self.countAPI = self.countAPI + 1
        if self.countAPI < 4
        {
            self.startDate = self.endDate
            self.endDate = Calendar.current.date(byAdding: .month, value: 3, to: self.startDate)!
            self.hitHomeApi(strtDate: self.startDate.convertDatetoString(dt: self.startDate), endDate: (self.endDate.convertDatetoString(dt: self.endDate)))
        }
        
        if let value = responseDict as? Dictionary<String, AnyObject>
        {
            let keys = Array(value.keys)
            for values in keys
            {
                
                var resultdict = value[values] as! Dictionary<String,AnyObject>
                print(resultdict)
                let keysDays = Array(resultdict.keys)
                for values in keysDays
                {
                    let resultDicted = resultdict[values]
                    let dictSave = NSMutableDictionary()
                    if let sunrise = resultDicted!["rise"]
                    {
                        dictSave["rise"] = sunrise
                    }
                    if let sunset = resultDicted!["set"]
                    {
                        dictSave["set"] = sunset
                    }
                    
                    if let weekdayName = resultDicted!["weekdayName"]
                    {
                        dictSave["weekdayName"] = weekdayName
                    }
                    self.dictMain[values] = dictSave
                }
            }
            if self.countAPI == 4
            {
                MMTHUD.hideHUDForView(self.view, animated: true)
                self.countAPI = 0
                UserDefaults.standard.set(self.dictMain, forKey: "\(self.lat) + \(self.long)")
                self.setValueOnLocationLbl()
                self.dictMain.removeAllObjects()
            }
            
            
            
        }
    }
    
}
extension ViewController : UIGestureRecognizerDelegate
{
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil && placeLebal.text != NSLocalizedString("Location Not set,Click on Icon!", comment: "")
        {
            shadowView.isHidden = false
            popViewDeleteSingle.isHidden = false
            self.view.addSubview(popViewDeleteSingle)
            popViewDeleteSingle.center = self.view.center
            popViewDeleteSingle.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popViewDeleteSingle.alpha = 0
            UIView.animate(withDuration: 0.4){
                self.popViewDeleteSingle.alpha = 1
                self.popViewDeleteSingle.transform = CGAffineTransform.identity
                
            }
        }
    }
    
    @objc func tapDateLabel(sender: UITapGestureRecognizer) {
        datePickerTapped()
    }
    
    @objc func handleFrontTap(sender: UITapGestureRecognizer) {
        chooseMapView.isHidden = true
        shadowView.isHidden = true
        popVIew.isHidden = true
        addLocatonView.isHidden = true
        popViewDeleteSingle.isHidden = true
        print("tap working")
    }
}

extension ViewController : saveView,selectAddressDelegate
{
    func onSave(lati: String, longi: String) {
        lat = Double(lati) ?? 0.0
        long = Double(longi) ?? 0.0
        if ReachabilityNetwork.isConnectedToNetwork() == true
        {
            getAddressFromLatLon(pdblLatitude: lati, withLongitude: longi)
            
        }
    }
    
    func onSaveFromMap(lati: Double, longi: Double, addressString : String)
    {
        lat = Double(lati)
        long = Double(longi)
        address = addressString
        showTimeZonepopup()
    }
    func onSaveFromMapScreen(lati: Double, longi: Double, addressString : String)
    {
        lat = Double(lati)
        long = Double(longi)
        address = addressString
        showTimeZonepopup()
    }
}
