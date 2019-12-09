//
//  Viaggio.swift
//  GoWay
//
//  Created by Giacomo Barzon on 29/07/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: PASSENGER
class Passenger: NSObject, NSCoding{
    var name: String
    var telNum: Int
    var numbers: Int
    var luggage: String
    var comments: String
    
    init(name: String = "", telNum: Int = 0, numbers: Int = 1, luggage: String = "", comments: String = ""){
        self.name = name
        self.telNum = telNum
        self.numbers = numbers
        self.luggage = luggage
        self.comments = comments
    }
    
    init(passenger: Passenger){
        self.name = passenger.name
        self.telNum = passenger.telNum
        self.numbers = passenger.numbers
        self.luggage = passenger.luggage
        self.comments = passenger.comments
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "PassName")
        coder.encode(telNum, forKey: "PassPhone")
        coder.encode(numbers, forKey: "PassNum")
        coder.encode(luggage, forKey: "PassLuggage")
        coder.encode(comments, forKey: "PassComments")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "PassName") as! String
        let telNum = decoder.decodeInteger(forKey: "PassPhone")
        let numbers = decoder.decodeInteger(forKey: "PassNum")
        let luggage = decoder.decodeObject(forKey: "PassLuggage") as! String
        let comments = decoder.decodeObject(forKey: "PassComments") as! String
        
        self.init(name: name, telNum: telNum, numbers: numbers, luggage: luggage, comments: comments)
    }
    
    func printPassengerInfo() -> String{
        var StringToPrint = "Nome: " + self.name
        StringToPrint += "\nCellulare: " + String(self.telNum)
        StringToPrint += "\nPasseggeri: " + String(self.numbers)
        if luggage != ""{
            StringToPrint += "\nBagagli: " + self.luggage
        }
        if comments != ""{
            StringToPrint += "\nCommenti: " + self.comments
        }
        
        return(StringToPrint)
    }
    
}


// MARK: DRIVER
class Driver: NSObject, NSCoding{
    var name: String
    var telNum: Int
    var vehicle: String
    
    init(name: String = "", telNum: Int = 0, vehicle: String = "" ){
        self.name = name
        self.telNum = telNum
        self.vehicle = vehicle
    }
    
    init(driver: Driver){
        self.name = driver.name
        self.telNum = driver.telNum
        self.vehicle = driver.vehicle
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "DriverName")
        coder.encode(telNum, forKey: "DriverPhone")
        coder.encode(vehicle, forKey: "DriverVehicle")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "DriverName") as! String
        let telNum = decoder.decodeInteger(forKey: "DriverPhone")
        let vehicle = decoder.decodeObject(forKey: "DriverVehicle") as! String
        
        self.init(name: name, telNum: telNum, vehicle: vehicle)
    }
    
    func copyDriver() -> Driver{
        let copiedDriver = Driver(driver: self)
        
        return (copiedDriver)
    }
    
    func printDriverInfo() -> String{
        var StringToPrint = "Nome: " + self.name
        StringToPrint += "\nCellulare: " + String(self.telNum)
        StringToPrint += "\nVeicolo: " + vehicle
        
        return(StringToPrint)
    }
}

// MARK: TRATTA
class Tratta: NSObject, NSCoding{
    
    var startData: Date?
    
    var startAddress: CLPlacemark?
    var endAddress: CLPlacemark?
    
    var durata: TimeInterval?
    var distance: Int?
    var order: Int?
    
    var passenger = Passenger()
    
    override init(){
        self.startData = Date.init(timeIntervalSinceNow: 0)
        self.order = 1
        self.distance = 0
        self.order = 1
    }
    
    init(startData: Date?, startAddress: CLPlacemark?, endAddress: CLPlacemark?, durata: TimeInterval?, distance: Int?, order: Int?){
        self.startData = startData
        
        self.startAddress = startAddress
        self.endAddress = endAddress
        
        self.durata = durata
        self.distance = distance
        self.order = order
    }
    
    init(tratta: Tratta){
        self.startData = tratta.startData
        
        self.startAddress = tratta.startAddress
        self.endAddress = tratta.endAddress
        
        self.durata = tratta.durata
        self.distance = tratta.distance
        self.order = tratta.order
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(startData, forKey: "TrattaStartData")
        
        coder.encode(startAddress, forKey: "TrattaStartAdd")
        coder.encode(endAddress, forKey: "TrattaEndAdd")
        
        coder.encode(order, forKey: "TrattaDistance")
        coder.encode(order, forKey: "TrattaDurata")
        coder.encode(order, forKey: "TrattaOrder")
        
        coder.encode(passenger, forKey: "TrattaPass")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let startData = decoder.decodeObject(forKey: "TrattaStartData") as! Date

        let startAddress = decoder.decodeObject(forKey: "TrattaStartAdd") as! CLPlacemark
        
        let endAddress = decoder.decodeObject(forKey: "TrattaEndAdd") as? CLPlacemark
        
        /*
        let endAddress: CLPlacemark?
        if temp != nil {
            endAddress = temp as? CLPlacemark
        }*/
        //let endAddress = decoder.decodeObject(forKey: "TrattaEndAdd") as! CLPlacemark
        
        let distance = decoder.decodeInteger(forKey: "TrattaDistance")
        let durata = decoder.decodeObject(forKey: "TrattaDurata") as! TimeInterval
        let order = decoder.decodeInteger(forKey: "TrattaOrder")
        
        let pass = decoder.decodeObject(forKey: "TrattaPass") as! Passenger
        
        self.init(startData: startData, startAddress: startAddress, endAddress: endAddress, durata: durata, distance: distance, order: order)

        self.addPassenger(passenger: pass)
    }
    
    func addPassenger(passenger: Passenger){
        self.passenger = Passenger(passenger: passenger)
    }
    
    func copyTratta() -> Tratta{
        let copiedTratta = Tratta(tratta: self)
        copiedTratta.addPassenger(passenger: self.passenger)
        
        return (copiedTratta)
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark?) -> String {
        if placemark == nil {
            return ""
        }
        
        return (placemark!.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    func printTrattaInfo() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"
        
        var StringToPrint = passenger.printPassengerInfo()
        StringToPrint += "\nOrario di partenza: \(dateFormatterGet.string(from: startData!))"
        //StringToPrint += "\nLuogo di partenza: \(startPlace)"
        StringToPrint += "\nIndirizzo di partenza: \(formatAddressFromPlacemark(placemark: startAddress ))"
        //StringToPrint += "\nOrario di rilascio: \(dateFormatterGet.string(from: endData!))"
        //StringToPrint += "\nLuogo di rilascio: \(endPlace)"
        StringToPrint += "\nIndirizzo di rilascio: \(formatAddressFromPlacemark(placemark: endAddress ))"
        StringToPrint += "\nOrdine di rilascio: \(order)"
        
        return(StringToPrint)
    }
    
}

// MARK: TRAVEL
class Travel: NSObject, NSCoding {
    
    //static var totalOrder: Int = 10000              // numero progressivo di ordine di trasferimento
    
    var order: Int
    var startingDate: Date
    var endingDate: Date
    
    var durata: TimeInterval
    var distance: Int                   // distanza totale
    
    var driver = Driver()
    var tratte: [Tratta] = []
    
    // Initialization
    init(startingDate: Date = Date.init(timeIntervalSinceNow: 0), endingDate: Date = Date.init(timeIntervalSinceNow: 0), distance: Int = 0){
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.distance = distance
        self.durata = endingDate.timeIntervalSince(startingDate)
        
        CabTaxi.sharedIstance.order += 1
        self.order = CabTaxi.sharedIstance.order
        print("Create Travel with order \(self.order)")
    }
    
    
    init(order: Int, startingDate: Date = Date.init(timeIntervalSinceNow: 0), endingDate: Date = Date.init(timeIntervalSinceNow: 0), distance: Int = 0){
        
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.distance = distance
        self.durata = endingDate.timeIntervalSince(startingDate)
        
        self.order = order
    }
    
    // Initialization from another travel
    init(travel: Travel){
        self.startingDate = travel.startingDate
        self.endingDate = travel.endingDate
        self.distance = travel.distance
        self.durata = travel.endingDate.timeIntervalSince(travel.startingDate)
        
        self.order = travel.order
    }
    
    // ENCODER
    required convenience init(coder decoder: NSCoder) {
        //self.init()
        
        let order = decoder.decodeInteger(forKey: "order")
        let startingDate = decoder.decodeObject(forKey: "startingDate") as! Date
        let endingDate =  decoder.decodeObject(forKey: "endingDate") as! Date
        let distance = decoder.decodeInteger(forKey: "distance")
        
        let driver = decoder.decodeObject(forKey: "driver") as! Driver
        let tratte = decoder.decodeObject(forKey: "tratte") as! [Tratta]
        
        self.init(order: order, startingDate: startingDate, endingDate: endingDate, distance: distance)
        self.addDriver(driver: driver)
        for tratta in tratte{
            self.addTratta(trattaToAdd: tratta)
        }
    }
    
    
    func encode(with coder: NSCoder) {
        print("travel encoding")
        coder.encode(order, forKey: "order")
        coder.encode(startingDate, forKey: "startingDate")
        coder.encode(endingDate, forKey: "endingDate")
        coder.encode(distance, forKey: "distance")
        
        coder.encode(driver, forKey: "driver")
        coder.encode(tratte, forKey: "tratte")

    }

    
    func copyTravel() -> Travel{
        let copiedTravel = Travel(travel: self)
        //copiedTravel.addPassenger(passenger: self.passenger)
        copiedTravel.addDriver(driver: self.driver)
        for tratta in self.tratte{
            copiedTravel.tratte.append(tratta.copyTratta())
        }
        
        return (copiedTravel)
    }
    
    func addDriver(driver: Driver){
        self.driver = Driver(driver: driver)
    }
    
    func addTratta(trattaToAdd: Tratta){
        var tempTratta = Tratta(tratta: trattaToAdd)
        tempTratta.addPassenger(passenger: trattaToAdd.passenger)
        self.tratte.append(tempTratta)
    }
    
    //SITEMARE COSA FAR STAMPARE
    func printTravelInfo(printDistance: Bool = false) -> NSMutableAttributedString{
        var boldText = "ORDINE: " + String(order)
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = CGFloat(5)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"
        
        //var normText = "\nDa sistemare"
        var normText = "\nOrario di partenza: \(dateFormatterGet.string(from: self.startingDate))"
        normText += "\nOrario di arrivo: \(dateFormatterGet.string(from: self.endingDate))"
        normText += "\nModi di viaggio: "
        if printDistance{
            normText += "\nDistanza totale: \(self.distance) km"
        }
        let normalString = NSMutableAttributedString(string: normText)
        
        attributedString.append(normalString)
        
        let totalLength = boldText.count + normText.count
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, totalLength))
        
        return(attributedString)
    }
    
}

