//
//  AboutVC.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 28/12/18.
//  Copyright © 2018 Dilip. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    @IBOutlet var loadFeatureLbl: UILabel!
    
    @IBOutlet var agnihotraLbl: UILabel!
    @IBOutlet var discLbl: UILabel!
    @IBOutlet var courtsevLbl: UILabel!
    @IBOutlet var entieLbl: UILabel!
    @IBOutlet var bruceJonsonLbl: UILabel!
    @IBOutlet var maxmilianLbl: UILabel!
    @IBOutlet var creditsLbl: UILabel!
    @IBOutlet var clickOnDateLbl: UILabel!
    @IBOutlet var iconLbl: UILabel!
    @IBOutlet var longPressLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    
    @IBOutlet var renameLbl: UILabel!
    @IBOutlet var functionalLbl: UILabel!
    @IBOutlet var aboutLbl: UILabel!
    
        // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUp()
        
    }
    
     // MARK: - SetUp
    func setUp()
    {
        functionalLbl.text = NSLocalizedString("Functional Shortcuts", comment: "")
        
        renameLbl.text = NSLocalizedString("Rename/Delete", comment: "")
        locationLbl.text = NSLocalizedString("Location", comment: "")
        loadFeatureLbl.text = NSLocalizedString("Load Feature Timeing", comment: "")
        longPressLbl.text = NSLocalizedString("Long Press Location", comment: "")
        iconLbl.text = NSLocalizedString("Icon", comment: "")
        clickOnDateLbl.text = NSLocalizedString("Click on Date", comment: "")
        creditsLbl.text = NSLocalizedString("Credits", comment: "")
        maxmilianLbl.text = NSLocalizedString("Maximilian Weber", comment: "")
        bruceJonsonLbl.text = NSLocalizedString("Bruce johnson and Ulrich Berk", comment: "")
        entieLbl.text = "Mathias Fehringer"
        courtsevLbl.text = "Shashi Bushan Singh"
        discLbl.text = NSLocalizedString("2004 Deustsche Gesellschaft f.Home-Thrape haldenhof, 78357 Muehhlingen", comment: "")
        
        agnihotraLbl.text = NSLocalizedString("Agnihotra Buddy", comment: "")
    }
    
    @IBAction func didTapbackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)    }
    
    
    
}
