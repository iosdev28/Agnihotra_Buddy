//
//  CommonUtils.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 03/01/19.
//  Copyright © 2019 Dilip. All rights reserved.
//

import Foundation
import UIKit

let appDelegate  = UIApplication.shared.delegate as! AppDelegate

class  CommonUtils  {
    
    static let shared = CommonUtils()


    class func createAlert (title:String, message:String, obj: UIViewController)
{
    let alertView = UIAlertController(title: "Agnihotra Buddy", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in})
    alertView.addAction(action)
    obj.present(alertView, animated: true, completion: nil)
}
    
    class func convertStringToDateForCountDown(str : String , isToday : Bool) -> Date
    {
        var arr: [String] = []
        if str == ""{
           arr.append("0")
           arr.append("0")
           arr.append("0")
        }else{
            arr = str.components(separatedBy: ":")
        }
         var date = NSDate()
        if !isToday {
            date = Date().tomorrow() as NSDate
        }
        
       
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        gregorian.locale = NSLocale.current
        // Change the time to 9:30:00 in your locale
        components.hour = NSInteger(arr[0])
        components.minute = NSInteger(arr[1])
        components.second = NSInteger(arr[2])
        
    let newDate = gregorian.date(from: components)!
       return newDate
    }
    
    class func convertStringToDateForCountDown12Hour(str : String , isToday : Bool) -> Date
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "HH:mm:ss"
        let finalString = dateFormatter.string(from: date!)
        let dt = self.convertStringToDateForCountDown(str: finalString, isToday: isToday)
        return dt
    }
    
    
    
    
    class  func convertStringToDate(str: String) -> Date
    {
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let date = dateFormatter.date(from: str)
        return date!
    }
    class  func convertStringToDateWithAMPM(str: String) -> Date
    {
        let strArray = str.components(separatedBy: " ")
        
        let dateFormatter = DateFormatter()
        if strArray.count == 1{
            dateFormatter.dateFormat = "HH:mm:ss"
        }else{
            dateFormatter.dateFormat = "HH:mm:ss a"
        }
        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let date = dateFormatter.date(from: str)
        return date!
    }
    
    class  func convertStringToDateIn12Hour(str: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "hh:mm:ss a"
        let finalString = dateFormatter.string(from: date!)
        return finalString
    
    }
    
    class  func convert24Hourto12Hour(dt : NSDate) -> String
    {
        let today1 = dt
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US") as Locale?

        dateFormatter1.dateFormat = "hh:mm:ss a"
        let timestring = dateFormatter1.string(from: today1 as Date)
        // print(timestring)
        return timestring
    }
    
    
    class func getNextAgnihotraTime(dict : NSMutableDictionary) -> (String?,Bool)
    {
        var latitude = dict["lat"] as! Double
        var longitude = dict["long"] as! Double
        var isToday = true
        let date = Date().getGMTTimeDate()
        
        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        print(timestamp)
        
        let sunRiseTimeText = dict["rise"]
        let sunSetTimeText = dict["set"]
        var sunRiseTimeDate = Date()
        var sunSetTimeDate = Date()
        if(UserDefaults.standard.object(forKey:"clockType") != nil && UserDefaults.standard.bool(forKey: "clockType") == false)
        {
            sunRiseTimeDate  = CommonUtils.convertStringToDateForCountDown12Hour(str: sunRiseTimeText as! String, isToday: isToday)
            sunSetTimeDate = CommonUtils.convertStringToDateForCountDown12Hour(str: sunSetTimeText  as! String, isToday: isToday)
        }
        else
        {
            sunRiseTimeDate  = CommonUtils.convertStringToDateForCountDown(str: sunRiseTimeText as! String, isToday: isToday)
            sunSetTimeDate = CommonUtils.convertStringToDateForCountDown(str: sunSetTimeText as! String, isToday: isToday)
        }
        //    let currentTimeDate = CommonUtils.convertStringToDateWithAMPM(str: timestamp )
        //  print(sunRiseTimeDate,sunSetTimeDate,currentTimeDate)
        if sunRiseTimeDate.compare(date) == .orderedAscending && sunSetTimeDate.compare(date) == .orderedDescending {
            return (sunSetTimeText as! String,isToday)
         //   nextAgniHotraTime = sunSetTimeText ?? ""
        }
        else if(sunRiseTimeDate.compare(date) == .orderedAscending && sunSetTimeDate.compare(date) == .orderedAscending)
        {
            isToday = false
            print((UserDefaults.standard.object(forKey: "\(latitude) + \(longitude)")))
            print("Rise and Set is passed.")
          //  print(((UserDefaults.standard.object(forKey: latitude + longitude)) ?? ""))
            if ((UserDefaults.standard.object(forKey: "\(latitude) + \(longitude)"))) != nil {
                let dicted = (UserDefaults.standard.object(forKey: "\(latitude) + \(longitude)")) as! NSMutableDictionary
                print(dicted)
                let dt = Date().tomorrow()
                print(dt.convertDatetoStringGet(dt: dt))
                if (dicted[dt.convertDatetoStringGet(dt: dt)] == nil)
                {
                    //CommonUtils.createAlert(title: "Agnihotra Buddy", message: "Oops! Data not found for date. Try updating Database", obj: self)
                  //  return nil
                }
                let todayDict = dicted[dt.convertDatetoStringGet(dt: dt)] as! NSMutableDictionary
                
                if(UserDefaults.standard.object(forKey:"clockType") != nil && UserDefaults.standard.bool(forKey: "clockType") == false)
                {
                    sunRiseTimeDate  = CommonUtils.convertStringToDateForCountDown(str: todayDict["rise"] as! String , isToday: isToday)
                    print(sunRiseTimeDate)
                    print(CommonUtils.convert24Hourto12Hour(dt: sunRiseTimeDate as NSDate))
                 //   nextAgniHotraTime = CommonUtils.convert24Hourto12Hour(dt: sunRiseTimeDate as NSDate)
                     return (CommonUtils.convert24Hourto12Hour(dt: sunRiseTimeDate as NSDate),isToday)
                }
                else
                {
                    //nextAgniHotraTime = todayDict["rise"] as! String
                     return (todayDict["rise"] as! String,isToday)
                }
                
            }
            
        }
        else
        {
        //    nextAgniHotraTime = sunRiseTimeText ?? ""
            return (sunRiseTimeText as! String,isToday)
        }
      return ("",isToday)
    }
    
   class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    class func getAddressFromLocation(lat : String, longitude : String ,completionHandler: @escaping ( String) -> ())
    {
        ServiceManager.instance.makeGetCallWithAlamofire(endPoint: String(format : "https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=%@",lat,longitude,GOOGLEAPI), completionHandler: { (response) in
            print(response)
            let results = response["results"] as! NSArray
            if results.count > 0
            {
                let resultDict = results[0] as! NSDictionary
                completionHandler(resultDict["formatted_address"] as? String ?? "")
               // self.address = resultDict["formatted_address"] as? String
            }
            else
            {
               // self.address = "Location Address Not Found"
                 completionHandler("Location Address Not Found")
            }
            
            
           // self.showTimeZonepopup()
        })
    }
    
}


