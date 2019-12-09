//
//  DataTravelViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 01/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class DataTravelViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var distanceText: UITextField!
    @IBOutlet weak var startingDataText: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide keybord when tapping anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        setupView()
    }
    
    // the date and time could be just correct, so the user could not modify it
    func setupView(){
        if TravelManager.sharedInstance.tempTravel?.startingDate != nil {
            startingDataText.date = TravelManager.sharedInstance.tempTravel!.startingDate
        }
    }
    

    // hide keybord when 'return' key pressed (if it's present)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    
    // get textfield
    @IBAction func startingDataField(_ sender: Any) {
        TravelManager.sharedInstance.tempTravel?.startingDate = startingDataText.date
    }
    
    
}
