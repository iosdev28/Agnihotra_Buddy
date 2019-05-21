//
//  CommonUtils.swift
//  Agnihotra Buddy
//
//  Created by Infoicon Technologies on 03/01/19.
//  Copyright © 2019 Infoicon Technologies. All rights reserved.
//

import Foundation
import UIKit

class  CommonUtils: NSObject {

    class func createAlert (title:String, message:String, obj: UIViewController)
{
    let alertView = UIAlertController(title: "Agnihotra Buddy", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in})
    alertView.addAction(action)
    obj.present(alertView, animated: true, completion: nil)
}

}

