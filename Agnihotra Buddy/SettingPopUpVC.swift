//
//  SettingPopUpVC.swift
//  Agnihotra Buddy
//
//  Created by Dilip on 28/12/18.
//  Copyright © 2018 Dilip. All rights reserved.
//

import UIKit

class SettingPopUpVC: UIViewController {
    @IBOutlet var popview: UIView!
    
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var privacyButton: UIButton!
    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var setView: UIView!
    
    // MARK: - View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - SetUp
    
    func setUp()
    {
        settingButton.setTitle(NSLocalizedString("Settings", comment: ""), for: .normal)
        
        contactsButton.setTitle(NSLocalizedString("Contacts",comment: ""),for:.normal)
        
        aboutButton.setTitle(NSLocalizedString("About", comment: ""), for: .normal)
        
        privacyButton.setTitle(NSLocalizedString("Privacy policy",comment: ""),for:.normal)
        
        shareButton.setTitle(NSLocalizedString("Share",comment: ""),for:.normal)
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.setView.addGestureRecognizer(gesture)
    }
    
    //MARK: - UIButton Action
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        setView.isHidden = true
    }
    
    @IBAction func didTapOnSetting(_ sender: Any) {
        
        popview.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingVC") as!SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapOnAbout(_ sender: Any) {
        popview.isHidden = true
        let about = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVC") as? AboutVC
        self.addChildViewController(about!)
        about?.view.frame = self.view.frame
        self.view.addSubview((about?.view)!)
        about?.didMove(toParentViewController: self)
    }
    
    @IBAction func didTaoOnContect(_ sender: Any) {
        popview.isHidden = true
        let contect = self.storyboard?.instantiateViewController(withIdentifier: "ContectVC") as! ContectVC
        self.navigationController?.pushViewController(contect, animated: true)
    }
    
    @IBAction func didTaoOnprivacy(_ sender: Any) {
        popview.isHidden = true
        let contect = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(contect, animated: true)
    }
    
    @IBAction func didTapOnShareButton(_ sender: Any) {
        popview.isHidden = true
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: "https://play.google.com/store/apps/details?id=app.gahomatherapy.agnihotramitra")
        {
            let objectsToShare = [message,link] as [Any]
            if( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) //
            {
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.title = "Share One"
                activityVC.excludedActivityTypes = []
                
                activityVC.popoverPresentationController?.sourceView = self.view
                if #available(iOS 12.0, *) {
                    activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
                } else {
                    // Fallback on earlier versions
                }
                
                self.present(activityVC, animated: true, completion: nil)
                
            }
            else
            {
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                //    activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
