//
//  AddLocationVC.swift
//  Agnihotra Buddy
//
//  Created by Infoicon Technologies on 03/01/19.
//  Copyright © 2019 Infoicon Technologies. All rights reserved.
//

import UIKit


class AddLocationVC: UIViewController {
    
   
    
    @IBOutlet var addLoctionController: UIView!
    @IBOutlet var tableview: UITableView!
    var rows = [String]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.hideView))
        self.addLoctionController.addGestureRecognizer(gesture)

      
    }
    
    @objc func hideView(sender : UITapGestureRecognizer) {
        addLoctionController.isHidden = true
    }
   
    @IBAction func didTapAddLocation(_ sender: Any) {
        
        //addLoctionController.isHidden = true
        tableview.isHidden = true
        let mappin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseMapVC") as? ChooseMapVC
                self.addChildViewController(mappin!)
        
                mappin?.view.frame = self.view.frame
                self.view.addSubview((mappin?.view)!)
                mappin?.didMove(toParentViewController: self)
    }
}

extension AddLocationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! AddLocationCell
        
        //cell.lbl.text = rows[indexPath.row]
        return cell
    
}
}



  
