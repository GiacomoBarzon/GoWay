//
//  DataDriverViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 01/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class DataDriverViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var vehicleField: UITextField!
    
    @IBOutlet weak var driverPicker: UIPickerView!
    @IBOutlet weak var vehiclePicker: UIPickerView!
    
    @IBOutlet weak var driverButton: UIButton!
    @IBOutlet weak var vehicleButton: UIButton!
    
    
    var name: String = ""
    var phone: Int = 111111
    var vehicle: String = ""
    
    var driverData: [String] = [String]()
    var vehicleData: [String] = [String]()
    
    var newDriver: Bool = true
    var newVehicle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.driverPicker.delegate = self
        self.driverPicker.dataSource = self
        
        self.vehiclePicker.delegate = self
        self.vehiclePicker.dataSource = self
        

        // hide keybord when tapping anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if newDriver{
            driverButton.isHidden = true
        }
        if newVehicle{
            vehicleButton.isHidden = true
        }
        
        setupPicker()
        setupDriver()
    }
    
    func setupPicker(){
        driverData = ["Nuovo autista"]
        
        if !Drivers.sharedIstance.arrayDrivers.isEmpty{
            for driver in Drivers.sharedIstance.arrayDrivers{
                driverData.append(driver.name)
            }
        }
        
        vehicleData = ["Nuovo veicolo"]
        vehicleData.append(contentsOf: Drivers.sharedIstance.arrayVehicle)
    }
    
    func setupDriver() {
        nameField.text = DriverManager.sharedInstance.tempDriver!.name
        if (DriverManager.sharedInstance.tempDriver!.telNum != 0){
            phoneField.text = String(DriverManager.sharedInstance.tempDriver!.telNum)
        }
        vehicleField.text = DriverManager.sharedInstance.tempDriver!.vehicle
    }

    // hide keybord when 'return' key pressed (if it's present)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    // TEXTFIELD SETUP
    @IBAction func nameEdit(_ sender: Any) {
        DriverManager.sharedInstance.tempDriver!.name = nameField.text!
        name = nameField.text!
    }
    
    @IBAction func phoneEdit(_ sender: Any) {
        DriverManager.sharedInstance.tempDriver!.telNum = Int(phoneField.text!)!
        phone = Int(phoneField.text!)!
    }
    
    
    @IBAction func vehicleEdit(_ sender: Any) {
        DriverManager.sharedInstance.tempDriver!.vehicle = vehicleField.text!
        vehicle = vehicleField.text!
    }
    
    // PICKER SETUP
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == driverPicker{
            return driverData.count
        }
        else {
            return vehicleData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == driverPicker {
            return driverData[row]
        }
        else {
            return vehicleData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == driverPicker {
            if row > 0 {
                driverButton.isHidden = false
                
                nameField.text = Drivers.sharedIstance.arrayDrivers[row-1].name
                phoneField.text = String(Drivers.sharedIstance.arrayDrivers[row-1].telNum)
                //vehicleField.text = Drivers.sharedIstance.arrayDrivers[row-1].vehicle
                DriverManager.sharedInstance.tempDriver!.name = nameField.text!
                DriverManager.sharedInstance.tempDriver!.telNum = Int(phoneField.text!)!
            }
            else {
                driverButton.isHidden = true
                
                nameField.text = ""
                phoneField.text = ""
            }
        }
            
        else {
            if row > 0 {
                vehicleButton.isHidden = false
                
                vehicleField.text = Drivers.sharedIstance.arrayVehicle[row-1]
                DriverManager.sharedInstance.tempDriver!.vehicle = vehicleField.text!
            }
            else {
                vehicleButton.isHidden = true
                
                vehicleField.text = ""
            }
        }
    }
    
    @IBAction func driverPressed(_ sender: Any) {
        var tempRow = driverPicker.selectedRow(inComponent: 0) - 1
        
        Drivers.sharedIstance.arrayDrivers.remove(at: tempRow)
        setupPicker()
        driverPicker.reloadComponent(0)
        
    }
    
    @IBAction func vehiclePressed(_ sender: Any) {
        var tempRow = vehiclePicker.selectedRow(inComponent: 0) - 1
        
        Drivers.sharedIstance.arrayVehicle.remove(at: tempRow)
        setupPicker()
        vehiclePicker.reloadComponent(0)
    }
    
}
