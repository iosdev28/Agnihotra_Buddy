//
//  TimeZonePickerViewController.swift
//  TimeZonePickerView
//
//  Created by mitesh soni on 17/10/18.
//  Copyright © 2018 Mitesh Soni. All rights reserved.
//

import UIKit


public class UITimeZonePickerViewController: UIViewController {
    
    
    var searchResultsTVC: SearchResultsTVC?
    var searchController: UISearchController!
    
    var timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    
    public var delegate: TimeZonePickerViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
//        showButtonsOnTop()
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(onLeftBarButtonDown))
        searchResultsTVC = SearchResultsTVC()
//        navigationItem.hidesSearchBarWhenScrolling = true
        createSearchBar()
    }
    
    func showButtonsOnTop(){
        print("laali")
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        self.view.addSubview(navBar);
        
        let navItem = UINavigationItem(title: "SomeTitle");
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectorName));
        navItem.rightBarButtonItem = doneItem;
        
        searchController = UISearchController(searchResultsController: searchResultsTVC)
        searchController.searchBar.delegate = searchResultsTVC
        searchController.searchResultsUpdater = searchResultsTVC
        searchController.obscuresBackgroundDuringPresentation = true
        if #available(iOS 11.0, *) {
            navItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        
        definesPresentationContext = true
        searchResultsTVC?.delegate = self
        
        navBar.setItems([navItem], animated: false);
        
        navBar.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        }  else {
            // Fallback on earlier versions
        }
        
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        
    }
    
    @objc func selectorName(){
        print("selector down")
        dismiss(animated: true, completion: nil)
        }
        public override func viewDidAppear(_ animated: Bool) {
        self.searchController.isActive = true
        }
        @objc func onLeftBarButtonDown(){
         dismiss(animated: true, completion: nil)
       
    }
    /**
     Creates and set up search bar.
     */
    func createSearchBar() {
        
        searchController = UISearchController(searchResultsController: searchResultsTVC)
        searchController.searchBar.delegate = searchResultsTVC
        searchController.searchResultsUpdater = searchResultsTVC
        searchController.obscuresBackgroundDuringPresentation = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        
        definesPresentationContext = true
        searchResultsTVC?.delegate = self
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        searchController.isActive = false
    }

}

extension UITimeZonePickerViewController: SearchConnectionDelegate {
    
        func selectedTimeZone(timeZone: TimeZone?) {
            
        print("selected time zone in search vc is", timeZone)
       
        if let timeZone = timeZone {
            
           
          let title = NSLocalizedString("YES", comment: "")
        let cancelTitle = NSLocalizedString("CANCEL", comment: "")
         let msg = NSLocalizedString("Please confirm timezone for this location", comment: "")
            
        let alert = UIAlertController(title: ""
            , message: "\(msg)\(timeZone.identifier)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                print("Yay! You brought your towel!")
                self.delegate?.timeZonePickerView(self, didSelectTimeZone: timeZone)
                print("tomezone")
                
                alert.title = NSLocalizedString("Please confirm timezone for this location!", comment: "")
                
          
      
              
                 self.dismiss(animated: true, completion: nil)
                 self.dismiss(animated: true, completion: nil)
            }))
        
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
            
            else {
                dismiss(animated: true, completion: nil)
        }
    }
}
