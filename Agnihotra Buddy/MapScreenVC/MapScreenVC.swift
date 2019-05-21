//
//  MapScreenVC.swift
//  Agnihotra Buddy
//
//  Created by VISHAL SETH on 23/01/19.
//  Copyright © 2019 Infoicon Technologies. All rights reserved.

import UIKit
import GooglePlaces
import MapKit
protocol selectAddressDelegate {
    
    func onSaveFromMapScreen(lati: Double, longi: Double, addressString : String)
}
class MapScreenVC: UIViewController,MKMapViewDelegate {
    let LocationData: LocationService = LocationService() 

    var delegate : selectAddressDelegate!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet var agnihotraLbl: UILabel!
    @IBOutlet var mapviewButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblTestLatitude: UILabel!
    @IBOutlet weak var btnMapType: UIButton!
    var isFromFindLocation = false
    var selectedLatitude = 0.0
    var selectedLongitude = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
        // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationData.locationManager.startUpdatingLocation()
        setUp()
        if isFromFindLocation == false
        {
            findMyLocation()
            
        }
        else
        {
            getAddressFromLatLon()
        }
    // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
     // MARK: - Setup
    func setUp()
    {
        selectButton.setTitle(NSLocalizedString("SELECT", comment: ""), for: .normal)
        mapviewButton.setTitle(NSLocalizedString("MAP VIEW",comment: ""),for:.normal)
        agnihotraLbl.text = NSLocalizedString("Agnihotra Buddy", comment: "")
        
        mapView.showsCompass = false
        
        self.navigationController?.navigationBar.isHidden = false
        
        // Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappen(_:)))
        mapView.addGestureRecognizer(tap)
        mapView.isUserInteractionEnabled = true
    }
    
    private func findMyLocation()
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            print("Used location")
            self.selectedLatitude = self.LocationData.locationManager.location?.coordinate.latitude ?? 0.0
            self.selectedLongitude = self.LocationData.locationManager.location?.coordinate.longitude ?? 0.0
            self.getAddressFromLatLon()
        }
        
        
    }
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
      
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        // add new annon
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location ,
                                         toCoordinateFrom: mapView)
        selectedLatitude = coordinate.latitude
        selectedLongitude = coordinate.longitude
        getAddressFromLatLon()
        
    }
    
    func loadSelectedLocation()
    {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.delegate = self
        //Setting the region to a state coordinate
        var newRegion:MKCoordinateRegion = MKCoordinateRegion()
        newRegion.center.latitude = self.selectedLatitude
        newRegion.center.longitude = self.selectedLongitude
        newRegion.span.latitudeDelta = 0.005;
        newRegion.span.longitudeDelta = 0.005;
        
            self.mapView.setRegion(newRegion, animated: true)
        
        
            let annotation = MKPointAnnotation()
            annotation.title = NSLocalizedString("Your Location", comment: "")
            annotation.coordinate = CLLocationCoordinate2D(latitude: selectedLatitude, longitude: selectedLongitude)
            self.mapView.addAnnotation(annotation)

    }
    
    // convert Coordinate into Address
    func getAddressFromLatLon() {
        
        if ReachabilityNetwork.isConnectedToNetwork() == true
        {
            CommonUtils.getAddressFromLocation(lat: String(selectedLatitude), longitude: String(selectedLongitude)) { (value) in
                self.lblAddress.text = value
                self.loadSelectedLocation()
                self.lblLatitude.text = NSLocalizedString("Latitude", comment: "") + ":" +  String(self.selectedLatitude)
                self.lblLongitude.text = NSLocalizedString("Longitude", comment: "") + ":" + String(self.selectedLongitude)
                self.lblTestLatitude.text = self.coordinateString(self.selectedLatitude, self.selectedLongitude)
            }
        }
    }
    
      // MARK: - UIButton Action
    
    @IBAction func didTapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnCurrentLocationSelected(_ sender: Any) {
        
        LocationData.locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            print("Used location")
            self.selectedLatitude = self.LocationData.locationManager.location?.coordinate.latitude ?? 0.0
            self.selectedLongitude = self.LocationData.locationManager.location?.coordinate.longitude ?? 0.0
            self.getAddressFromLatLon()
        }
    }
    
    @IBAction func btnPlusTap(_ sender: Any) {
        var region =   MKCoordinateRegion()
        //Set Zoom level using Span
        var span =   MKCoordinateSpan()
        region.center = mapView.region.center
        
        span.latitudeDelta = mapView.region.span.latitudeDelta/2.0002
        span.longitudeDelta = mapView.region.span.longitudeDelta/2.0002
        region.span=span;
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func btnMinusTap(_ sender: Any) {
        var region =   MKCoordinateRegion()
        //Set Zoom level using Span
        var span =   MKCoordinateSpan()
        region.center = mapView.region.center
        
        span.latitudeDelta = mapView.region.span.latitudeDelta*2
        span.longitudeDelta = mapView.region.span.longitudeDelta*2
        region.span=span;
        mapView.setRegion(region, animated: true)
        
    }
    @IBAction func btnTapSelectAddress(_ sender: Any) {
        if lblAddress.text!.count > 0 {
            delegate.onSaveFromMapScreen(lati: selectedLatitude, longi: selectedLongitude, addressString: lblAddress.text!)
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            CommonUtils.createAlert(title: AppName, message:Message_Constants.KPLEASEWAIT , obj: self)
        }
        
    }
    @IBAction func btnMapViewSelected(_ sender: UIButton) {
        
        // if sender.titleLabel?.text == "MAP VIEW" {
        
        if sender.titleLabel?.text == NSLocalizedString("MAP VIEW", comment: "") {
            btnMapType.setTitle(NSLocalizedString("SATELLITE",comment: ""),for:.normal)
            
            // btnMapType.setTitle("SATELLITE", for: .normal)
            mapView.mapType = .standard
        }
        else
        {
            mapView.mapType = .satellite
            btnMapType.setTitle(NSLocalizedString("MAP VIEW",comment: ""),for:.normal)
            // btnMapType.setTitle("MAP VIEW", for: .normal)
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MapScreenVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}


extension MapScreenVC: GMSAutocompleteViewControllerDelegate {
    
    func coordinateString(_ latitude: Double,_ longitude: Double) -> String {
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        return String(format:"%d°%d'%d\"%@ %d°%d'%d\"%@",
                      abs(latDegrees),
                      latMinutes,
                      latSeconds, latDegrees >= 0 ? "N" : "S",
                      abs(longDegrees),
                      longMinutes,
                      longSeconds,
                      longDegrees >= 0 ? "E" : "W" )
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print(place.coordinate.latitude,place.coordinate.longitude)
        selectedLatitude = place.coordinate.latitude
        selectedLongitude = place.coordinate.longitude
        self.lblAddress.text = place.formattedAddress
        self.searchBar.text = place.formattedAddress
        self.lblLatitude.text = "Latitude : " +  String(self.selectedLatitude)
        self.lblLongitude.text = "Longitude : " + String(self.selectedLongitude)
        self.loadSelectedLocation()
        self.lblTestLatitude.text = self.coordinateString(self.selectedLatitude, self.selectedLongitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
}
}
