//
//  AppDelegate.swift
//  GoWay
//
//  Created by Giacomo Barzon on 29/07/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("CARICAMENTO OGGETTI TRAVEL SALVATI")
        
        if let inusoData = UserDefaults.standard.data(forKey: "inUsoTravelArray") {
            if let inUso = NSKeyedUnarchiver.unarchiveObject(with: inusoData) as? [Travel] {
                print("Numero viaggi in Uso salvati: \(inUso.count)")
                for travel in inUso{
                    CabTaxi.sharedIstance.InUso.append(travel)
                }
            }
        }
        
        if let completatiData = UserDefaults.standard.data(forKey: "completatiTravelArray") {
            if let completati = NSKeyedUnarchiver.unarchiveObject(with: completatiData) as? [Travel] {
                print("CARICAMENTO OGGETTI TRAVEL SALVATI")
                print("Numero viaggi in Uso salvati: \(completati.count)")
                for travel in completati{
                    CabTaxi.sharedIstance.Completati.append(travel)
                }
            }
            
        }
        
        if let orderData = UserDefaults.standard.data(forKey: "orderTravel") {
            if let orderTravel = NSKeyedUnarchiver.unarchiveObject(with: orderData) as? Int {
                print("Ordine ultimo viaggio: \(orderTravel)")
                CabTaxi.sharedIstance.order = orderTravel
            }
        }
        else{
            print("non era salvato alcun ordine")
            CabTaxi.sharedIstance.order = 120
        }
        
        if let driversData = UserDefaults.standard.data(forKey: "driversArray") {
            if let drivers = NSKeyedUnarchiver.unarchiveObject(with: driversData) as? [Driver] {
                for driver in drivers{
                    Drivers.sharedIstance.arrayDrivers.append(driver)
                }
            }
        }
        if let vehicleData = UserDefaults.standard.data(forKey: "vehiclesArray") {
            if let vehicles = NSKeyedUnarchiver.unarchiveObject(with: vehicleData) as? [String] {
                for vehicle in vehicles{
                    Drivers.sharedIstance.arrayVehicle.append(vehicle)
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("SALVATAGGIO OGGETTI TRAVEL")
        
        let inUsoData = NSKeyedArchiver.archivedData(withRootObject: CabTaxi.sharedIstance.InUso)
        UserDefaults.standard.set(inUsoData, forKey: "inUsoTravelArray")
        
        let completatiData = NSKeyedArchiver.archivedData(withRootObject: CabTaxi.sharedIstance.Completati)
        UserDefaults.standard.set(completatiData, forKey: "completatiTravelArray")
        
        let orderData = NSKeyedArchiver.archivedData(withRootObject: CabTaxi.sharedIstance.order)
        UserDefaults.standard.set(orderData, forKey: "orderTravel")
        
        print("SALVATAGGIO OGGETTI DRIVER")
        
        let driversData = NSKeyedArchiver.archivedData(withRootObject: Drivers.sharedIstance.arrayDrivers)
        UserDefaults.standard.set(driversData, forKey: "driversArray")
        
        let vehiclesData = NSKeyedArchiver.archivedData(withRootObject: Drivers.sharedIstance.arrayVehicle)
        UserDefaults.standard.set(vehiclesData, forKey: "vehiclesArray")
        
        
    }


}

