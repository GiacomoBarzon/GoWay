//
//  TravelTableViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 04/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class TravelTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ChangeTravelState: UIButton!
    @IBOutlet weak var DeleteTravel: UIButton!
    
    var travelToShow: Travel?
    var previousPage: Int?
    var posTravelToShow: TravelPosition?
    var selectedRow: Int?

    let headlines = ["Viaggio", "Tratte", "Driver"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LEGGO OGGETTO TRAVEL PASSATO DA VIEWCONTROLLER PRECEDENTE
        if (posTravelToShow!.categoria == "InUso") {
            self.travelToShow = CabTaxi.sharedIstance.InUso[posTravelToShow!.arrayPos].copyTravel()
        }
        else {
            self.travelToShow = CabTaxi.sharedIstance.Completati[posTravelToShow!.arrayPos].copyTravel()
            ChangeTravelState.setTitle("VIAGGIO DA TERMINARE", for: .normal)
        }
        
        // TITLE AND BUTTON TEXT SETUP
        self.title = "Ordine di viaggio " + String(travelToShow!.order)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back")
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            if let navigator = self.navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        
        if(indexPath.section == 1){
            cell.textLabel?.text = travelToShow!.tratte[indexPath.row].printTrattaInfo()
        }
        else if(indexPath.section == 2){
            cell.textLabel?.text = travelToShow!.driver.printDriverInfo()
            cell.textLabel?.numberOfLines = 3
        }
        else{
            cell.textLabel?.attributedText = travelToShow!.printTravelInfo(printDistance: true)
            cell.selectionStyle = .none
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        
        cell.layer.cornerRadius = 10
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return(headlines[section])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1){
            return travelToShow!.tratte.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        if indexPath.section == 1 {
            previousPage = 1
        }
        else if(indexPath.section == 2){
            previousPage = 2
        }
        
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "modifyTravel", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modifyTravel"{
            // get a reference to the second view controller
            let secondViewController = segue.destination as! TravelPageViewController
            secondViewController.previousPage = previousPage
            secondViewController.posTravelToModify = posTravelToShow
            secondViewController.trattaToModify = selectedRow
        }
        else if segue.identifier == "addTratta"{
            // get a reference to the second view controller
            previousPage = 3
            let secondViewController = segue.destination as! TravelPageViewController
            secondViewController.previousPage = previousPage
            secondViewController.posTravelToModify = posTravelToShow
        }
        
        else if segue.identifier == "changeTravelState" {
            if posTravelToShow?.categoria == "InUso"{
                CabTaxi.sharedIstance.Completati.append((travelToShow?.copyTravel())!)
                CabTaxi.sharedIstance.InUso.remove(at: posTravelToShow!.arrayPos)
            }
            else {
                CabTaxi.sharedIstance.InUso.append((travelToShow?.copyTravel())!)
                CabTaxi.sharedIstance.Completati.remove(at: posTravelToShow!.arrayPos)
            }
            
            }
        else if segue.identifier == "deleteTravel" {
            if posTravelToShow?.categoria == "InUso"{
                CabTaxi.sharedIstance.InUso.remove(at: posTravelToShow!.arrayPos)
            }
            else {
                CabTaxi.sharedIstance.Completati.remove(at: posTravelToShow!.arrayPos)
            }
        }
        else if segue.identifier == "pdfPreview"{
            let secondViewController = segue.destination as! ShowPdfTravel
            secondViewController.posTravelToShow = posTravelToShow
        }
        
        // set a variable in the second view controller with the data to pass
        //secondViewController.receivedData = "hello"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
