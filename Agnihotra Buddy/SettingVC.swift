//
//  SettingVC.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 28/12/18.
//  Copyright © 2018 Dilip. All rights reserved.
//

import UIKit
import UserNotifications

class SettingVC: UIViewController {
    
    
    @IBOutlet var agnihotraLbl: UILabel!
    @IBOutlet var agnihoraAlarmLbl: UILabel!
    @IBOutlet var displaycoubdowndSecondLbl: UILabel!
    @IBOutlet var dislayLbl: UILabel!
    @IBOutlet var displayCoundownLbl: UILabel!
    @IBOutlet var meditationBellLbl: UILabel!
    @IBOutlet var changeTimeFormatLbl: UILabel!
    @IBOutlet var timeFormatLbl: UILabel!
    @IBOutlet var keepscrenLbl: UILabel!
    @IBOutlet var screenAlwaysOnLbl: UILabel!
    @IBOutlet var genralLbl: UILabel!
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var loadStartupLbl: UILabel!
    @IBOutlet var homeLocationLbl: UILabel!
    @IBOutlet var alawaysOnSwitch: UISwitch!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var changeLocationPopup: UIView!
    @IBOutlet var hourFormatSwitch: UISwitch!
    @IBOutlet var meditationSwitch: UISwitch!
    @IBOutlet var placeChangeLabel: UILabel!
    @IBOutlet var lblAlarmTime: UILabel!
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet var countDownSwitch: UISwitch!
    
    var savedata    :[[String: Any]] = []
    var switchOn: Bool = false
    let defaults = UserDefaults.standard
    var popsaveData: NSDictionary!
    
      // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setUp()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       viewSetUp()
        
    }
    
    
      // MARK: - setUp
    func setUp()
    {
        agnihotraLbl.text = NSLocalizedString("Agnihotra Buddy", comment: "")
        homeLocationLbl.text = NSLocalizedString("Home Location", comment: "")
        
        loadStartupLbl.text = NSLocalizedString("Loads on start up", comment: "")
        
        changeButton.setTitle(NSLocalizedString("CHANGE", comment: ""), for: .normal)
        
        genralLbl.text = NSLocalizedString("General", comment: "")
        
        screenAlwaysOnLbl.text = NSLocalizedString("Screen Always on", comment: "")
        
        keepscrenLbl.text = NSLocalizedString("Keeps screen awake while app is open", comment: "")
        
        timeFormatLbl.text = NSLocalizedString("24 hour clock", comment: "")
        
        changeTimeFormatLbl.text = NSLocalizedString("Change Time Format to 12 or 24 hours", comment: "")
        
        meditationBellLbl.text = NSLocalizedString("Meditation Bell", comment: "")
        
        displayCoundownLbl.text = NSLocalizedString("Display countdown or clock in centre", comment: "")
        
        dislayLbl.text = NSLocalizedString("Display Countdown", comment: "")
        displaycoubdowndSecondLbl.text = NSLocalizedString("Display countdown or clock in centre", comment: "")
        
        agnihoraAlarmLbl.text = NSLocalizedString("Agnihotra Alarm", comment: "")
        
        lblAlarmTime.text = NSLocalizedString("Set alarm to ring before agnihotra", comment: "Set alarm to ring before agnihotra")
        
        
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            print(UserDefaults.standard.object(forKey: "placeData") ?? "")
            savedata = ((UserDefaults.standard.object(forKey: "placeData") as! NSArray) as! [[String : Any]])
            
        }
            
        else{
            
        }
        
        let tapset = UITapGestureRecognizer(target: self, action: #selector((handleFrontTap)))
        shadowView.isUserInteractionEnabled = true
        shadowView.addGestureRecognizer(tapset)
    }
    
    func viewSetUp()
    {
        alawaysOnSwitch.setOn(false, animated: false)
        if defaults.value(forKey: "screenOn") != nil{
            let switchON: Bool = defaults.value(forKey: "screenOn")  as! Bool
            if switchON == true {
                alawaysOnSwitch.setOn(true, animated: true)
            } else if switchON == false{
                alawaysOnSwitch.setOn(false, animated: false)
            }
        }
        
        hourFormatSwitch.setOn(false, animated: false)
        if defaults.value(forKey: "clockType") != nil{
            let switchON: Bool = defaults.value(forKey: "clockType")  as! Bool
            if switchON == true {
                hourFormatSwitch.setOn(true, animated: true)
            } else if switchON == false{
                hourFormatSwitch.setOn(false, animated: false)
            }
        }
        
        alarmSwitch.setOn(false, animated: false)
        if defaults.value(forKey: "alarmSwitch") != nil{
            let switchON: Bool = defaults.value(forKey: "alarmSwitch")  as! Bool
            if switchON == true {
                alarmSwitch.setOn(true, animated: true)
                let alarmTime = self.defaults.value(forKey: "alarmTime")
                
                
                let alarmText1 = NSLocalizedString("Alarm set for", comment: "Alarm set for")
                let alarmText2 = NSLocalizedString("minutes before Agnihotra.", comment: "minutes before Agnihotra.")
                self.lblAlarmTime.text = String(format: "%@ %@ %@", alarmText1 , alarmTime as! CVarArg , alarmText2)
            } else if switchON == false{
                alarmSwitch.setOn(false, animated: false)
                self.lblAlarmTime.text = NSLocalizedString("Set alarm to ring before agnihotra", comment: "Set alarm to ring before agnihotra")
            }
        }
        
        meditationSwitch.setOn(false, animated: false)
        if defaults.value(forKey: "MeditationSwitch") != nil{
            let switchON: Bool = defaults.value(forKey: "MeditationSwitch")  as! Bool
            if switchON == true {
                meditationSwitch.setOn(true, animated: true)
            } else if switchON == false{
                meditationSwitch.setOn(false, animated: false)
            }
        }
        countDownSwitch.setOn(false, animated: false)
        if defaults.value(forKey: "countDownSwitch") != nil{
            let switchON: Bool = defaults.value(forKey: "countDownSwitch")  as! Bool
            if switchON == true {
                countDownSwitch.setOn(true, animated: true)
            } else if switchON == false{
                countDownSwitch.setOn(false, animated: false)
            }
        }
        
        
        
        placeChangeLabel.text = "Location Not Set"
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            if((UserDefaults.standard.object(forKey: "selectedIndex") as? NSInteger) != nil)
            {
                
                placeChangeLabel.text = (((UserDefaults.standard.object(forKey: "placeData") as! NSArray)[UserDefaults.standard.object(forKey: "selectedIndex") as! NSInteger] as! NSDictionary)["address"] as? String)
            }
        }
        
    }
    
    
    
    // MARK: - UIbutton Action
    
    @IBAction func didTapChangeBtn(_ sender: Any) {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            shadowView.isHidden = false
            showChanegeplace()
        }
        else
        {
            CommonUtils.createAlert(title: "Agnihotra Buddy", message: "No location found", obj: self)
        }
    }
    @objc func handleFrontTap(sender: UITapGestureRecognizer) {
        shadowView.isHidden = true
        changeLocationPopup.isHidden = true
        print("tap working")
    }
    
    @IBAction func didTapalwaysOnAction(_ sender: UISwitch) {
        
        if(sender.isOn == true) {
            switchOn = true
            UIApplication.shared.isIdleTimerDisabled = true
            
        }
        else {
            switchOn = false
            UIApplication.shared.isIdleTimerDisabled = false
        }
        defaults.set(switchOn, forKey: "screenOn")       
    }
    
    
    @IBAction func onMeditationSwitch(_ sender: UISwitch) {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            if(sender.isOn == true) {
                switchOn = true
                
            }
            else {
                switchOn = false
            }
            defaults.set(switchOn, forKey: "MeditationSwitch")
        }
        else
        {
            let apptitle = NSLocalizedString("Agnihotra Buddy", comment: "")
            let msg = NSLocalizedString("please Location First", comment: "")
            
            CommonUtils.createAlert(title: apptitle, message: msg, obj: self)
            meditationSwitch.setOn(false, animated: true)
        }
        
    }
    
    @IBAction func checkState(_ sender: UISwitch) {
        
        if(sender.isOn == true) {
            switchOn = true
        }
        else {
            switchOn = false
        }
        defaults.set(switchOn, forKey: "clockType")
        
        //self.defaults.set(hourFormatSwitch.isOn, forKey: "mySwitch")
    }
    
    @IBAction func onAlarmSwitch(_ sender: UISwitch) {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            if(sender.isOn == true) {
                openAlarmPopUp()
            }
            else {
                self.defaults.set(false, forKey: "alarmSwitch")
                self.alarmSwitch.setOn(false, animated: true)
                cancelAllLocalNotification()
                lblAlarmTime.text = NSLocalizedString("Set alarm to ring before agnihotra", comment: "Set alarm to ring before agnihotra")
            }
        }
        else
        {
            let apptitle = NSLocalizedString("Agnihotra Buddy", comment: "")
            let msg = NSLocalizedString("please Location First", comment: "")
            CommonUtils.createAlert(title: apptitle, message: msg, obj: self)
            alarmSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func onCountDownSwitch(_ sender: UISwitch) {
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            if(sender.isOn == true) {
                switchOn = true
            }
            else {
                switchOn = false
            }
            defaults.set(switchOn, forKey: "countDownSwitch")
        }
        else
        {
            CommonUtils.createAlert(title: AppName, message: "Please set Location First", obj: self)
            countDownSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func DidTapBackArrow(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Custom Methods
    
    func showChanegeplace(){
        
        changeLocationPopup.isHidden = false
        self.view.addSubview(changeLocationPopup)
        changeLocationPopup.center = self.view.center
        changeLocationPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        changeLocationPopup.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.changeLocationPopup.alpha = 1
            self.changeLocationPopup.transform = CGAffineTransform.identity
        }
    }
    
    func cancelAllLocalNotification()
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
    }
    
    func openAlarmPopUp()
    {
        
        let title = NSLocalizedString("Set Alarm Time", comment: "")
        let msg = NSLocalizedString("Save", comment: "")
        let cancemsg = NSLocalizedString("Cancel", comment: "")
        
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter time between 3 to 120 minutes"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let saveAction = UIAlertAction(title: msg, style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            //print(firstTextField.text)
            
            let Formatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
            let final = Formatter.number(from: firstTextField.text!)
            let finalValue = final?.intValue
            
            
            
            if ((finalValue! > 0) && (finalValue!  > 2) && (finalValue! < 121))
            {
                self.defaults.set(true, forKey: "alarmSwitch")
                self.defaults.set(String(format: "%d", finalValue!), forKey:"alarmTime")
                self.alarmSwitch.setOn(true, animated: true)
                let alarmText1 = NSLocalizedString("Alarm set for", comment: "Alarm set for")
                let alarmText2 = NSLocalizedString("minutes before Agnihotra.", comment: "minutes before Agnihotra.")
                self.lblAlarmTime.text = String(format: "%@ %d %@",alarmText1,finalValue ?? 0, alarmText2)
            }
            else
            {
                CommonUtils.createAlert(title: AppName, message: "Please enter valid value", obj: self)
                self.alarmSwitch.setOn(false, animated: true)
            }
            
            
        })
        let cancelAction = UIAlertAction(title: cancemsg, style: UIAlertActionStyle.default, handler: {alert -> Void in
            self.defaults.set(false, forKey: "alarmSwitch")
            self.alarmSwitch.setOn(false, animated: true)
            self.lblAlarmTime.text = NSLocalizedString("Set alarm to ring before agnihotra", comment: "Set alarm to ring before agnihotra")
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}


extension SettingVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (UserDefaults.standard.object(forKey: "placeData")) != nil
        {
            print((UserDefaults.standard.object(forKey: "placeData") as! NSArray).count)
            let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
            if (count == 3)
            {
                return (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
            }
            return (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
            
        }
            
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLocationCell")as! ChangeLocationCell
        let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
        if indexPath.row <  count {
            cell.changeLbl.text = (((UserDefaults.standard.object(forKey: "placeData") as! NSArray)[indexPath.row] as! NSDictionary)["address"] as? String)
            
        }
        
        return cell
    }
}



extension SettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let count = (UserDefaults.standard.object(forKey: "placeData") as! NSArray).count
        if indexPath.row <  count {
            let dict = (UserDefaults.standard.object(forKey: "placeData") as! NSArray)[indexPath.row] as! NSDictionary
            placeChangeLabel.text = String(format: "%@", dict["address"] as! String)
            
            print(dict["lat"] as! Double)
            print(dict["long"] as! Double)
            UserDefaults.standard.set(indexPath.row, forKey: "selectedIndex")
            //  popsaveData = dict as NSDictionary
            
            
            changeLocationPopup.removeFromSuperview()
            shadowView.isHidden = true
        }
        
    }
}




