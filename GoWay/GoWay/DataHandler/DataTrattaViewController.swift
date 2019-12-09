//
//  DataTravelViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 01/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DataTrattaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startingAddressText: UITextField!
    @IBOutlet weak var arrivingAddressText: UITextField!
    @IBOutlet weak var startingDataText: UIDatePicker!
    
    var startingPlacemark: CLPlacemark?
    var endingPlacemark: CLPlacemark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keybord when tapping anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        setupView()
    }

    // the date and time could be just correct, so the user could not modify it
    func setupView(){
        
        if TrattaManager.sharedInstance.tempTratta?.startData != nil {
            startingDataText.date = TrattaManager.sharedInstance.tempTratta!.startData!
        }
        
        if TrattaManager.sharedInstance.tempTratta?.startAddress != nil {
            startingAddressText.text = TrattaManager.sharedInstance.tempTratta?.startAddress.debugDescription
        }
        
        if TrattaManager.sharedInstance.tempTratta?.endAddress != nil {
            startingAddressText.text = TrattaManager.sharedInstance.tempTratta?.endAddress.debugDescription
        }
        
    }
    
    // hide keybord when 'return' key pressed (if it's present)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    
    // get textfield
    @IBAction func startAddField(_ sender: Any) {
        let startingAddress = startingAddressText.text ?? ""
        
        getCoordinate(addressString: startingAddress) { (placemark,error) in
            self.processResponse(placemark: placemark, error: error, isStarting: true)
        }
    }
    
    @IBAction func endAddField(_ sender: Any) {
        let endingAddress = arrivingAddressText.text ?? ""
        
        getCoordinate(addressString: endingAddress) { (placemark,error) in
            self.processResponse(placemark: placemark, error: error, isStarting: false)
        }
    }
    
    @IBAction func startingDataField(_ sender: Any) {
        TrattaManager.sharedInstance.tempTratta?.startData = startingDataText.date
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
    func processResponse(placemark: CLPlacemark?, error: NSError?, isStarting: Bool) {
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            showAlert(alertString: "Unable to Find Location for Address")
            
            if isStarting {
                startingAddressText.text = ""
            } else {
                arrivingAddressText.text = ""
            }
        }
        else {
            if placemark != nil {
                if isStarting {
                    startingAddressText.text = formatAddressFromPlacemark(placemark: placemark!)
                    startingPlacemark = placemark
                    TrattaManager.sharedInstance.tempTratta?.startAddress = startingPlacemark
                    //startingMapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark!))
                } else {
                    arrivingAddressText.text = formatAddressFromPlacemark(placemark: placemark!)
                    endingPlacemark = placemark
                    TrattaManager.sharedInstance.tempTratta?.endAddress = endingPlacemark
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
    
    func showAlert(alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                   style: .cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
}
