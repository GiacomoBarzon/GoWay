//
//  AddressTableView.swift
//  GoWay
//
//  Created by Giacomo Barzon on 17/10/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit
import MapKit

class AddressTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var addresses: [String] = [String]()
    var placemarkArray: [CLPlacemark]!
    var currentTextField: UITextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ("Volevi dire...")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (addresses.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "myCell")
        
        cell.textLabel?.numberOfLines = 0

        if addresses.count > indexPath.row {
          cell.textLabel?.text = addresses[indexPath.row]
        } else {
          cell.textLabel?.text = "None of the above"
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}
