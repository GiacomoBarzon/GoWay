//
//  TravelPageViewController.swift
//  GoWay
//
//  Created by Giacomo Barzon on 31/07/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class TravelPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    var oldButton: UIBarButtonItem?
    
    //let titles = ["Modifica Tratta", "Modifica Autista", "Aggiungi Tratta", "Modifica Viaggio"]
    let titles = ["Modifica Tratta", "Modifica Autista", "Aggiungi Tratta"]
    
    // Pagina precedente: nil = mainPage, 1 = modifyTratta, 2 = modifyDriver, 3 = addTratta
    var previousPage: Int?
    var posTravelToModify: TravelPosition?
    var trattaToModify: Int?
        
    // CHANGE VIEW (not only change contentView, as suggested)
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // LIST OF DIFFERENT VIEW CONTROLLERS
    lazy var orderedViewControllers: [UIViewController] = []
    
    // CLASSICAL FUNCTION FOR A PAGEVIEWCONTROLLER
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
                
        print("Transizione completata? \(completed)")
        
        
        if (self.pageControl.currentPage == orderedViewControllers.count-1){
            self.navigationItem.rightBarButtonItem = oldButton
        }
        else{
            print("bottone non dovrebbe vedersi")
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pagina precedente: nil = mainPage, 1 = modifyTratta, 2 = modifyDriver, 3 = addTratta
        if (previousPage == 1){
            orderedViewControllers = [self.newVc(viewController: "PassengerView"),
                                      self.newVc(viewController: "TrattaView")]
            if posTravelToModify?.categoria == "InUso"{
                TrattaManager.sharedInstance.tempTratta =  CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].tratte[trattaToModify!].copyTratta()
            }
            else{
               TrattaManager.sharedInstance.tempTratta = CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].tratte[trattaToModify!].copyTratta()
            }
        }
        else if (previousPage == 3){
            orderedViewControllers = [self.newVc(viewController: "PassengerView"),
                                      self.newVc(viewController: "TrattaView")]
            TrattaManager.sharedInstance.initTratta()
        }
        else if (previousPage == 2){
            orderedViewControllers = [self.newVc(viewController: "DriverView")]
            if posTravelToModify?.categoria == "InUso"{
                DriverManager.sharedInstance.tempDriver = CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].driver.copyDriver()
            }
            else{
                DriverManager.sharedInstance.tempDriver = CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].driver.copyDriver()
            }
        }
        else if (previousPage == 4){
            orderedViewControllers = [self.newVc(viewController: "TravelView")]
            //TravelManager.sharedInstance.initTravel()
            
            if posTravelToModify?.categoria == "InUso"{
                TravelManager.sharedInstance.tempTravel = CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].copyTravel()
            }
            else{
                TravelManager.sharedInstance.tempTravel = CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].copyTravel()
            }
        }
        else {
            orderedViewControllers = [ //self.newVc(viewController: "TravelView"),
                                      self.newVc(viewController: "PassengerView"),
                                      self.newVc(viewController: "TrattaView"),
                                      self.newVc(viewController: "DriverView")]
            // TODO
            TravelManager.sharedInstance.initTravel()
            print("Create temp Travel with order \(TravelManager.sharedInstance.tempTravel?.order)")
            TrattaManager.sharedInstance.initTratta()
            DriverManager.sharedInstance.initDriver()
        }

        // Do any additional setup after loading the view.
        self.dataSource = self
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        
        if previousPage != nil {
            self.title = titles[previousPage!-1]
            print(previousPage!)
        }
        if (previousPage != 2) && (previousPage != 4) {
            oldButton = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
        
        
        // create a shared Travel to modify and then add
        //print(state!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // se ho premuto tasto indietro
        if self.isMovingFromParent && previousPage == nil {
            TravelManager.sharedInstance.deleteTravel()
            CabTaxi.sharedIstance.order -= 1
        }
    }
    
    
    @IBAction func endPressed(_ sender: Any) {
        if previousPage != nil{
            self.performSegue(withIdentifier: "endModifyTravel", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "endNewTravel", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // manage drivers and vehicles saved
        if previousPage == nil || previousPage == 2 {
            Drivers.sharedIstance.tempVehicle = DriverManager.sharedInstance.tempDriver?.vehicle
            Drivers.sharedIstance.addVehicleIfNotPresent()
            
            Drivers.sharedIstance.tempDriver = DriverManager.sharedInstance.tempDriver
            Drivers.sharedIstance.addDriver()
        }
        
        if segue.identifier == "endModifyTravel" {
            // Pagina precedente: nil = mainPage, 1 = modifyTratta, 2 = modifyDriver, 3 = addTratta
            switch previousPage {
                case 1:
                    if posTravelToModify?.categoria == "InUso"{
                        CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].tratte[trattaToModify!] = (TrattaManager.sharedInstance.tempTratta?.copyTratta())!
                    }
                    else{
                        CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].tratte[trattaToModify!] = (TrattaManager.sharedInstance.tempTratta?.copyTratta())!
                    }
                    break
                case 2:
                    if posTravelToModify?.categoria == "InUso" {
                        CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].driver = (DriverManager.sharedInstance.tempDriver?.copyDriver())!
                    }
                    else {
                        CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].driver = (DriverManager.sharedInstance.tempDriver?.copyDriver())!
                    }
                    break
                case 3:
                    if posTravelToModify?.categoria == "InUso" {
                        CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos].addTratta(trattaToAdd: (TrattaManager.sharedInstance.tempTratta?.copyTratta())!)
                    }
                    else {
                        CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos].addTratta(trattaToAdd: (TrattaManager.sharedInstance.tempTratta?.copyTratta())!)
                    }
                    break
                case 4:
                    if posTravelToModify?.categoria == "InUso" {
                        CabTaxi.sharedIstance.InUso[posTravelToModify!.arrayPos] = (TravelManager.sharedInstance.tempTravel?.copyTravel())!
                    }
                    else {
                        CabTaxi.sharedIstance.Completati[posTravelToModify!.arrayPos] = (TravelManager.sharedInstance.tempTravel?.copyTravel())!
                    }
                    TravelManager.sharedInstance.deleteTravel()
                    break
                default:
                    break
            }
            
            var destinationVC = segue.destination as! TravelTableViewController
            destinationVC.posTravelToShow = posTravelToModify
        }
        else if segue.identifier == "endNewTravel"{
            //TravelManager.sharedInstance.initTravel()
            var travelToAdd = TravelManager.sharedInstance.tempTravel?.copyTravel()
            travelToAdd?.addTratta(trattaToAdd: TrattaManager.sharedInstance.tempTratta!)
            travelToAdd?.driver = (DriverManager.sharedInstance.tempDriver?.copyDriver())!
            CabTaxi.sharedIstance.InUso.append(travelToAdd!)
            TravelManager.sharedInstance.deleteTravel()
            TrattaManager.sharedInstance.deleteTratta()
            print("default segue")
        }
    }

}
