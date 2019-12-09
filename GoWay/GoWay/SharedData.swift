//
//  SharedData.swift
//  GoWay
//
//  Created by Giacomo Barzon on 03/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

// MARK: TRAVEL MANAGER
class TravelManager{
    
    //The singleton instance
    static let sharedInstance = TravelManager()
    
    var tempTravel: Travel?
    var thereIsATravel: Bool = false
    
    private init(){}
    
    func storeTravel(travelToStore: Travel){
        tempTravel = travelToStore.copyTravel()
        thereIsATravel = true
    }
    
    func initTravel(){
        tempTravel = Travel()
        thereIsATravel = true
    }
    
    func deleteTravel(){
        tempTravel = nil
        thereIsATravel = false
    }
    
}

// MARK: TRATTA MANAGER
class TrattaManager{
    
    //The singleton instance
    static let sharedInstance = TrattaManager()
    
    var tempTratta: Tratta?
    var thereIsATratta: Bool = false
    
    private init(){}
    
    func storeTratta(trattaToStore: Tratta){
        tempTratta = trattaToStore.copyTratta()
        thereIsATratta = true
    }
    
    func initTratta(){
        tempTratta = Tratta()
        thereIsATratta = true
    }
    
    func deleteTratta(){
        tempTratta = nil
        thereIsATratta = false
    }
    
}

// MARK: DRIVER MANAGER
class DriverManager{
    
    //The singleton instance
    static let sharedInstance = DriverManager()
    
    var tempDriver: Driver?
    var thereIsADriver: Bool = false
    
    private init(){}
    
    func storeDriver(DriverToStore: Driver){
        tempDriver = DriverToStore.copyDriver()
        thereIsADriver = true
    }
    
    func initDriver(){
        tempDriver = Driver()
        thereIsADriver = true
    }
    
    func deleteDriver(){
        tempDriver = nil
        thereIsADriver = false
    }
}

// MARK: CabTaxi
class CabTaxi{
    static let sharedIstance = CabTaxi()
    
    var InUso: [Travel] = []
    var Completati: [Travel] = []
    
    var order: Int!
    
    var selectedTravel = [0, 0]
    
    private init () {}
}

// MARK: TravelPosition
class TravelPosition{
    var categoria: String
    var arrayPos: Int
    
    init(categoria: String, arrayPos: Int){
        self.categoria = categoria
        self.arrayPos = arrayPos
    }
}

// MARK: DRIVERS
class Drivers{
    static let sharedIstance = Drivers()
    
    var arrayDrivers: [Driver] = []
    var arrayVehicle: [String] = []
    
    var tempVehicle: String? = nil
    var tempDriver: Driver? = nil
    
    private init () {}
    
    func addVehicleIfNotPresent() {
        if tempVehicle == nil || tempVehicle == "" {
            return
        }
        
        var temp = false
        if !arrayVehicle.isEmpty {
            for vehicles in arrayVehicle {
                if vehicles == tempVehicle {
                    temp = true
                }
            }
        }
        if !temp {
            arrayVehicle.append(tempVehicle!)
        }
    }
    
    func addDriver() {
        if tempDriver == nil || tempDriver?.name == "" {
            return
        }
        
        var temp = false
        if !arrayDrivers.isEmpty {
            for (index,drivers) in arrayDrivers.enumerated() {
                if drivers.name == tempDriver?.name {
                    temp = true
                    arrayDrivers[index] = Driver(driver: tempDriver!)
                }
            }
        }
        if !temp {
            arrayDrivers.append(Driver(driver: tempDriver!))
        }
    }
}
