//
//  PrivacyPolicyVC.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 02/01/19.
//  Copyright © 2019 Dilip. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet var wetWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL (string: "http://homatherapy.org/privacy-policy/")
        let requestObj = URLRequest(url: url!)
        wetWeb.loadRequest(requestObj)

    }
    @IBAction func didTapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


