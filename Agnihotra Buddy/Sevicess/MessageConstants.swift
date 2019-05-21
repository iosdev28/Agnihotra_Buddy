//
//  MessageConstants.swift
//  Agnihotra Buddy
//
//  Created by VISHAL SETH on 24/01/19.
//  Copyright © 2019 Infoicon Technologies. All rights reserved.
//

import Foundation
import UIKit


let AppName = "Agnihotra Buddy"
let Base_Url = "https://www.homatherapie.de/en/Agnihotra_Zeitenprogramm/results/api/v2"
var currentLatitude = 0.0
var currentLongitude = 0.0
struct Message_Constants {
    static let INVALID_VALUE = NSLocalizedString("Invalid Value", comment: "")
    static let kAlertNoNetworkMessage = "A network connection is required. Please verify your network settings & try again."
    static let KPLEASEWAIT = "Please wait we are still finding accurate location for Agnihotra"
    static let KLOCATIONNOTSET = "Location Not set, Click on Icon !"
}
