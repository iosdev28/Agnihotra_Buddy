//
//  ContectVC.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 02/01/19.
//  Copyright © 2019 Dilip. All rights reserved.
//

import UIKit
import MessageUI

class ContectVC: UITableViewController,MFMailComposeViewControllerDelegate {
    
   
    @IBOutlet var contactforLbl: UILabel!
    @IBOutlet var internationalLbl3 : UILabel!
    @IBOutlet var internationalLbl2 : UILabel!
    @IBOutlet var internationalLbl1 : UILabel!
    @IBOutlet var austrailiyaBl2    : UILabel!
    @IBOutlet var austreliaLblMail  : UILabel!
    @IBOutlet var southAmericaLbl2  : UILabel!
    @IBOutlet var southAmericaLbl1  : UILabel!
    @IBOutlet var homaThrepiLbl1    : UILabel!
    @IBOutlet var fivefoldSite      : UILabel!
    @IBOutlet var fivefoldLbl       : UILabel!
    @IBOutlet var indiaLbl2         : UILabel!
    @IBOutlet var indiaLbl1         : UILabel!
    @IBOutlet var usalbl2           : UILabel!
    @IBOutlet var usalbl1           : UILabel!
    @IBOutlet var section3Lbl2      : UILabel!
    @IBOutlet var section3email1    : UILabel!
    @IBOutlet var section2Lbl2      : UILabel!
    @IBOutlet var section2Lbl1      : UILabel!
    @IBOutlet var eropeLbl2         : UILabel!
    @IBOutlet var dgtLabel          : UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactforLbl.text = NSLocalizedString("Contact for more information", comment: "")
        
        
        
       
        let tap = UITapGestureRecognizer(target: self, action: #selector((didtapMail)))
        dgtLabel.isUserInteractionEnabled = true
        dgtLabel.addGestureRecognizer(tap)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector((didTaperopeLbl2)))
        eropeLbl2.isUserInteractionEnabled = true
        eropeLbl2.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector((didtapsection2Lbl1)))
        section2Lbl1.isUserInteractionEnabled = true
        section2Lbl1.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector((didtapsection2Lbl2)))
        section2Lbl2.isUserInteractionEnabled = true
        section2Lbl2.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector((didtapsectionemail1)))
        section3email1.isUserInteractionEnabled = true
        section3email1.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector((didtapsection3Lbl2)))
        section3Lbl2.isUserInteractionEnabled = true
        section3Lbl2.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector((didtapusalbl1)))
        usalbl1.isUserInteractionEnabled = true
        usalbl1.addGestureRecognizer(tap6)
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector((didtapusalbl2)))
        usalbl2.isUserInteractionEnabled = true
        usalbl2.addGestureRecognizer(tap7)
        
        let tap8 = UITapGestureRecognizer(target: self, action: #selector((didtapindiaLbl1)))
        indiaLbl1.isUserInteractionEnabled = true
        indiaLbl1.addGestureRecognizer(tap8)
        
        let tap9 = UITapGestureRecognizer(target: self, action: #selector((didtapindiaLbl2)))
        fivefoldLbl.isUserInteractionEnabled = true
        fivefoldLbl.addGestureRecognizer(tap9)
        
        let tap10 = UITapGestureRecognizer(target: self, action: #selector((didtapfivefoldLbl)))
        fivefoldSite.isUserInteractionEnabled = true
        fivefoldSite.addGestureRecognizer(tap10)
        
        let tap11 = UITapGestureRecognizer(target: self, action: #selector((didtapfivefoldSite)))
        homaThrepiLbl1.isUserInteractionEnabled = true
        homaThrepiLbl1.addGestureRecognizer(tap11)
        
        let tap12 = UITapGestureRecognizer(target: self, action: #selector((didtaphomaThrepiLbl1)))
        southAmericaLbl1.isUserInteractionEnabled = true
        southAmericaLbl1.addGestureRecognizer(tap12)
        
        let tap13 = UITapGestureRecognizer(target: self, action: #selector((didtapsouthAmericaLbl2)))
        southAmericaLbl2.isUserInteractionEnabled = true
        southAmericaLbl2.addGestureRecognizer(tap13)
        
        let tap14 = UITapGestureRecognizer(target: self, action: #selector((didtapaustreliaLblMail)))
        austreliaLblMail.isUserInteractionEnabled = true
        austreliaLblMail.addGestureRecognizer(tap14)
        
        
        let tap15 = UITapGestureRecognizer(target: self, action: #selector((didtapaustrailiyaBl2)))
        austrailiyaBl2.isUserInteractionEnabled = true
        austrailiyaBl2.addGestureRecognizer(tap15)
        
        let tap16 = UITapGestureRecognizer(target: self, action: #selector((didtapinternationalLbl1)))
        internationalLbl1.isUserInteractionEnabled = true
        internationalLbl1.addGestureRecognizer(tap16)
        
        let tap17 = UITapGestureRecognizer(target: self, action: #selector((didtapinternationalLbl2)))
        internationalLbl2.isUserInteractionEnabled = true
        internationalLbl2.addGestureRecognizer(tap17)
        
        let tap18 = UITapGestureRecognizer(target: self, action: #selector((didtapinternationalLbl3)))
        internationalLbl3.isUserInteractionEnabled = true
        internationalLbl3.addGestureRecognizer(tap18)
        
      
        
    }

    
    @objc func didtapMail(sender: UITapGestureRecognizer) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "dght@homatherapie.de" + "dght@homatherapie.de")
            UIApplication.shared.openURL(url!)
            return
        
    }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["dght@homatherapie.de"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
          self.present(composeVC, animated: true, completion: nil)
    }
   
    // MARK: MailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    
    @objc func didTaperopeLbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapie.de"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapsection2Lbl1(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "info@homatherapypoland.org" + "info@homatherapypoland.org")
            UIApplication.shared.openURL(url!)
            return
      }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["info@homatherapypoland.org"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @objc func didtapsection2Lbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapypoland.org"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapsection3email1(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "monika-koch@t-online.de" + "monika-koch@t-online.de")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["monika-koch@t-online.de"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    @objc func didtapusalbl1(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "info@agnihotra.org" + "info@agnihotra.org")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["info@agnihotra.org"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    @objc func didtapusalbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.agnihotra.org"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapindiaLbl1 (sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "tapovan3@yahoo.com" + "tapovan3@yahoo.com")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["tapovan3@yahoo.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    @objc func didtapindiaLbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapyindia.com"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapfivefoldLbl(sender: UITapGestureRecognizer) {
        
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "fivefoldpath@gmail.com" + "fivefoldpath@gmail.com")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["fivefoldpath@gmail.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    @objc func didtapfivefoldSite(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.fivefoldpathmission.org"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtaphomaThrepiLbl1(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "agnihomainfo@yahoo.co.in" + "agnihomainfo@yahoo.co.in")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["agnihomainfo@yahoo.co.in"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @objc func didtapsouthAmericaLbl1(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "terapiahoma@yahoo.com" + "terapiahoma@yahoo.com")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["terapiahoma@yahoo.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    @objc func didtapsouthAmericaLbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homa1.com"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapsection3Lbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapypoland.org")
{
            UIApplication.shared.openURL(url as URL)
        }
    }

    @objc func didtapsectionemail1(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapypoland.org"){
              UIApplication.shared.openURL(url as URL)
        }
    }
   
    
    @objc func didtapaustreliaLblMail(sender: UITapGestureRecognizer) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let url = URL(string: "omshreedham@agnihotra.com.au" + "terapiahoma@yahoo.com")
            UIApplication.shared.openURL(url!)
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["omshreedham@agnihotra.com.au"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @objc func didtapaustrailiyaBl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.agnihotra.com.au"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    @objc func didtapinternationalLbl1(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homatherapy.org"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapinternationalLbl2(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homahealth.com"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func didtapinternationalLbl3(sender: UITapGestureRecognizer) {
        if let url = NSURL(string: "http://www.homafarming.com"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
   
    @IBAction func homoThrapi(_ sender: Any) {
        if let url = NSURL(string: "http://www.http://www.homatherapy.org"){
            UIApplication.shared.openURL(url as URL)
    }
    }
    

    @IBAction func didTapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


    

