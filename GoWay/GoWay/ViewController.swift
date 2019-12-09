//
//  ViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 29/07/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let headlines = ["In uso", "Completati"]
    
    var selectedTravel: TravelPosition?

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (2)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return(headlines[section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0){
            return (CabTaxi.sharedIstance.InUso.count)
        }
        else{
            return(CabTaxi.sharedIstance.Completati.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        
        let section = indexPath.section
        if(section==0){
            cell.textLabel?.attributedText = CabTaxi.sharedIstance.InUso[indexPath.row].printTravelInfo()
            cell.backgroundColor = UIColor.green
        }
        else{
            cell.textLabel?.attributedText = CabTaxi.sharedIstance.Completati[indexPath.row].printTravelInfo()
            cell.backgroundColor = UIColor.red
        }
        
        cell.textLabel?.numberOfLines = 0

        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            selectedTravel = TravelPosition(categoria: "InUso", arrayPos: indexPath.row)
        }
        else{
            selectedTravel = TravelPosition(categoria: "Completati", arrayPos: indexPath.row)
        }
        
        self.performSegue(withIdentifier: "mainToTravelTable", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "mainToTravelTable" {
            var destinationVC = segue.destination as! TravelTableViewController
            destinationVC.posTravelToShow = selectedTravel
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;

        // Do any additional setup after loading the view.
        

        // STORE DATA
        /*if Caso.sharedIstance.firstTime {
            var viaggio1 = Travel()
            
            var driver = Driver(name: "Gabriele Forin", telNum: 111111, vehicle: "AA111BB")
            viaggio1.addDriver(driver: driver)
            viaggio1.startingDate = Date.init(timeIntervalSinceNow: 0)
            viaggio1.endingDate = Date.init(timeIntervalSinceNow: 6000)
            viaggio1.distance = 510
            
            var tratta1 = Tratta(startPlace: "casa", endPlace: "fiera", distance: 10)
            var passenger1 = Passenger(name: "Marco Cava", telNum: 33312567, numbers: 2, luggage: "nessuno", comments: "portare passeggino")
            tratta1.startData = Date.init(timeIntervalSinceNow: 600)
            tratta1.addPassenger(passenger: passenger1)
            
            var tratta2 = Tratta(startPlace: "Torre, Padova", startAddress: "Via Roma, 14", endPlace: "Venezia", endAddress: "Aeroporto Marco Polo", distance: 50)
            var passenger2 = Passenger(name: "Luca Rossi", telNum: 33312567, numbers: 3, luggage: "1 grosso", comments: "portare rialzo")
            tratta2.startData = Date.init(timeIntervalSinceNow: 120)
            tratta2.addPassenger(passenger: passenger2)
            
            viaggio1.addTratta(trattaToAdd: tratta1)
            viaggio1.addTratta(trattaToAdd: tratta2)
            
            CabTaxi.sharedIstance.InUso.append(viaggio1)
            Caso.sharedIstance.firstTime = false
        }*/
        
        
    }


}

