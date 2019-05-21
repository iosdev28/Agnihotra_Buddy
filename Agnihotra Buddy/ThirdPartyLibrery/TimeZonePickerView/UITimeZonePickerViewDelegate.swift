//
//  TimeZoneSelectorProtocol.swift
//  TimeZonePickerView
//
//  Created by mitesh soni on 17/10/18.
//  Copyright © 2018 Mitesh Soni. All rights reserved.
//
import UIKit

public protocol UITimeZonePickerViewDelegate {
    func timeZonePickerView(_ pickerView: UIPickerView, didSelectTimeZone timeZone: TimeZone)
    
}
