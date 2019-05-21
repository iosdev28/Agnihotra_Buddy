//
//  FindLocation.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 29/12/18.
//  Copyright © 2018 Dilip. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

protocol saveView {
    
    func onSave(lati: String, longi: String)
    func onSaveFromMap(lati: Double, longi: Double, addressString : String)
}

class FindLocation: UIViewController {
    
    let LocationData: LocationService = LocationService()
    
    @IBOutlet var agnihotraLabel: UILabel!
    @IBOutlet var longLbl: UILabel!
    
    @IBOutlet var seethisLocationButton: UIButton!
    @IBOutlet var useLocationButton: UIButton!
    @IBOutlet var latLbl: UILabel!
    @IBOutlet var enterloactionbelowLbl: UILabel!
    @IBOutlet var manualEnteryLbl: UILabel!
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var lat         : Double!
    var long        : Double!
    @IBOutlet var longTxtFiled: UITextField!
    @IBOutlet var latTextFild: UITextField!
    var delegate : saveView!
    var delegateSave : selectAddressDelegate!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         LocationData.locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        
        
        setUp()
    }
    // MARK: - Set Up
    
    func setUp()
    {
        agnihotraLabel.text = NSLocalizedString("Agnihotra Buddy", comment: "")
        manualEnteryLbl.text = NSLocalizedString("Manual Entry", comment: "")
        enterloactionbelowLbl.text = NSLocalizedString("Enter location below in Degrees using Standerd convention +ve for North/East and-ve for South/West", comment: "")
        latLbl.text = NSLocalizedString("Latitude", comment: "")
        longLbl.text = NSLocalizedString("Longtitude", comment: "")
        
        useLocationButton.setTitle(NSLocalizedString("USE THIS LOCATION", comment: ""), for: .normal)
        
        seethisLocationButton.setTitle(NSLocalizedString("SEE THIS LOCATION ON MAP", comment: ""), for: .normal)
        
    }
    
     // MARK: - UIbutton Action
    
    @IBAction func didTapOnFind(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            print("Used location")
            self.lat = self.LocationData.locationManager.location?.coordinate.latitude ?? 0.0
            self.long = self.LocationData.locationManager.location?.coordinate.longitude ?? 0.0
            
            self.latTextFild.text = "\(self.lat!)"
            self.longTxtFiled.text = "\(self.long!)"
           
        }
        
    }
    
    @IBAction func didTapOnUseLocation(_ sender: Any) {
        
        let apptitle = NSLocalizedString("Agnihotra Buddy", comment: "")
        let msg = NSLocalizedString("Please enter latitude", comment: "")
        let msgLong = NSLocalizedString("Please enter longitude", comment: "")
        
        guard let lattext = latTextFild.text, !lattext.isEmpty else  {
            CommonUtils.createAlert(title: apptitle, message: msg, obj: self)
            return
        }
        
        guard let longtext = longTxtFiled.text, !longtext.isEmpty else {
            CommonUtils.createAlert(title: apptitle, message: msgLong, obj: self)
            return
        }
        if validate() {
            self.navigationController?.popToRootViewController(animated: true)
            self.delegate.onSave(lati: latTextFild.text!, longi: longTxtFiled.text!)
        }
    }
    
    @IBAction func didTapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLocationOnMap(_ sender: Any) {
        let apptitle = NSLocalizedString("Agnihotra Buddy", comment: "")
        let msg = NSLocalizedString("please enter latitude", comment: "")
        let msgLong = NSLocalizedString("Please enter longitude", comment: "")
        
        if(latTextFild.text == "")
        {
            CommonUtils.createAlert(title: apptitle, message: msg, obj: self)
            return
        }
        if(longTxtFiled.text == "")
        {
            CommonUtils.createAlert(title: apptitle, message: msgLong, obj: self)
            return
        }
        if validate() {
            let find = self.storyboard?.instantiateViewController(withIdentifier: "MapScreenVC")as! MapScreenVC
            find.selectedLatitude = Double(latTextFild.text!)!
            find.selectedLongitude = Double(longTxtFiled.text!)!
            find.delegate = delegateSave
            find.isFromFindLocation = true
            self.navigationController?.pushViewController(find, animated: true)
        }
    }
    
     // MARK: - Validation
    
    func validate() -> Bool
    {
        if  latTextFild.text!.components(separatedBy:".").count   > 2  {
            CommonUtils.createAlert(title: AppName, message: Message_Constants.INVALID_VALUE , obj: self)
            return false
        }
        else if longTxtFiled.text!.components(separatedBy:".").count > 3  {
            CommonUtils.createAlert(title: AppName, message: Message_Constants.INVALID_VALUE , obj: self)
            return false
        }
        else if latTextFild.text!.components(separatedBy:".").count == 1 && latTextFild.text!.count > 2  {
            CommonUtils.createAlert(title: AppName, message: Message_Constants.INVALID_VALUE , obj: self)
            return false
        }
        else if longTxtFiled.text!.components(separatedBy:".").count == 1 && longTxtFiled.text!.count > 2  {
            CommonUtils.createAlert(title: AppName, message: Message_Constants.INVALID_VALUE , obj: self)
            return false
        }
        return true
    }
    
}
