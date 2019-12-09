//
//  ProvaController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 08/10/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ProvaController: UIViewController, UITextFieldDelegate {
    
    var startingAddress: String = ""
    var endingAddress: String = ""
    
    var startingPlacemark: CLPlacemark?
    var endingPlacemark: CLPlacemark?
    
    //var startingMapItem: MKMapItem?
    //var endingMapItem: MKMapItem?
        
    @IBOutlet weak var startAddress: UITextField!
    @IBOutlet weak var endAddress: UITextField!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
        
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
          locationManager.requestLocation()
        }
        
        // hide keybord when tapping anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        startLabel.text = ""
        endLabel.text = ""
    }
    
    @IBAction func writeStartAdd(_ sender: Any) {
        startingAddress = startAddress.text ?? ""
        getCoordinate(addressString: startingAddress) { (placemark,error) in
            self.processResponse(placemark: placemark, error: error, isStarting: true)
        }
        
    }
    
    @IBAction func writeEndAdd(_ sender: Any) {
        endingAddress = endAddress.text ?? ""
        getCoordinate(addressString: endingAddress) { (placemark,error) in
            self.processResponse(placemark: placemark, error: error, isStarting: false)
        }
    }
    
    // from Address to location
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLPlacemark?, NSError?) -> Void ) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    print("Placemark: \(placemark)")
                        
                    completionHandler(placemark, nil)
                    return
                }
            }
                
            completionHandler(nil, error as NSError?)
        }
    }
    
    // handle location results
    func processResponse(placemark: CLPlacemark?, error: NSError?, isStarting: Bool){
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            showAlert(alertString: "Unable to Find Location for Address")
            
            if isStarting {
                startAddress.text = ""
                startLabel.text = ""
            } else {
                endAddress.text = ""
                endLabel.text = ""
            }
        }
        else {
            if placemark != nil {
                if isStarting {
                    startLabel.text = formatAddressFromPlacemark(placemark: placemark!)
                    startingPlacemark = placemark
                    //startingMapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark!))
                } else {
                    endLabel.text = formatAddressFromPlacemark(placemark: placemark!)
                    endingPlacemark = placemark
                    //endingMapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark!))
                }
            }
            else {
                showAlert(alertString: "No Matching Location Found")
            }
        }
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    // hide keybord when 'return' key pressed (if it's present)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    func showAlert(alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                   style: .cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ProvaController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            //print("location:: \(locations)")
        }

    }

}
