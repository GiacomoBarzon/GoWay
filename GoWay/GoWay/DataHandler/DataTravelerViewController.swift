//
//  DataTravelerViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 01/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class DataTravelerViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //TODO: al posto di un text field per il numero di passeggeri, posso mettere una rotella con i numeri
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passengersField: UITextField!
    @IBOutlet weak var luggagesField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        phoneField.delegate = self
        passengersField.delegate = self
        luggagesField.delegate = self
        commentField.delegate = self
        
        commentField.layer.borderWidth = 1
        commentField.layer.borderColor = UIColor.black.cgColor
        
        // hide keybord when tapping anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // setup
        setupText()

    }
    
    func setupText(){
        nameField.text = TrattaManager.sharedInstance.tempTratta?.passenger.name
        if TrattaManager.sharedInstance.tempTratta!.passenger.telNum != 0{
            phoneField.text = String(TrattaManager.sharedInstance.tempTratta!.passenger.telNum)
        }
        passengersField.text = String(TrattaManager.sharedInstance.tempTratta!.passenger.numbers)
        luggagesField.text = String(TrattaManager.sharedInstance.tempTratta!.passenger.luggage)
        commentField.text = TrattaManager.sharedInstance.tempTratta!.passenger.comments
    }
    
    
    // hide keybord when 'return' key pressed (if it's present)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    // get text values
    @IBAction func nameEdit(_ sender: Any) {
        TrattaManager.sharedInstance.tempTratta?.passenger.name = nameField.text!
    }
    
    @IBAction func phoneEdit(_ sender: Any) {
        TrattaManager.sharedInstance.tempTratta?.passenger.telNum = Int(phoneField.text ?? "0") ?? 0
    }
    
    @IBAction func passengersEdit(_ sender: Any) {
        TrattaManager.sharedInstance.tempTratta?.passenger.numbers = Int(passengersField.text ?? "1") ?? 1
    }
    
    @IBAction func luggagesEdit(_ sender: Any) {
        TrattaManager.sharedInstance.tempTratta?.passenger.luggage = luggagesField.text!
    }
    
    func textViewDidChange(_ textView: UITextView) {
        TrattaManager.sharedInstance.tempTratta?.passenger.comments = textView.text!
    }
}
