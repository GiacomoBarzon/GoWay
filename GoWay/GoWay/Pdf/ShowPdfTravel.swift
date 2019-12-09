//
//  ModifyTravel.swift
//  GoWay
//
//  Created by Giacomo Barzon on 30/07/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class ShowPdfTravel: UIViewController {

    @IBOutlet weak var webPreview: UIWebView!
    
    var travelToShow: Travel!
    var posTravelToShow: TravelPosition!
    var travelComposer: HtmlComposer!
    
    var HTMLContent: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSideOptionButton = UIBarButtonItem(title: "Salva", style: .plain, target: self, action: #selector(salva(sender:)))
        self.navigationItem.rightBarButtonItem = rightSideOptionButton
        
        if posTravelToShow.categoria == "InUso"{
            travelToShow = CabTaxi.sharedIstance.InUso[posTravelToShow.arrayPos].copyTravel()
        }
        else {
            travelToShow = CabTaxi.sharedIstance.Completati[posTravelToShow.arrayPos].copyTravel()
        }
        
        travelComposer = HtmlComposer(travel: travelToShow)
        createTravelAsHTML()
    }
    
    @objc func salva(sender: UIBarButtonItem) {
        
        //travelComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        
        let pdfData = travelComposer.exportHTMLContentToData(HTMLContent: HTMLContent)
        
        let activityViewController = UIActivityViewController(activityItems: ["Ordine\(travelToShow.order)", pdfData], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        
        super.viewDidAppear(animated)
    }*/
    
    func createTravelAsHTML(){
        if let travelHTML = travelComposer.provaHtml(){
            print("stampo html")
            webPreview.loadHTMLString(travelHTML, baseURL: NSURL(string: travelComposer.pathHtml!)! as URL)
            HTMLContent = travelHTML
        }
    }

}
