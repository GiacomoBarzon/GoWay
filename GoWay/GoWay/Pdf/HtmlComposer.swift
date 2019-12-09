//
//  HtmlComposer.swift
//  GoWay
//
//  Created by Giacomo Barzon on 03/08/2019.
//  Copyright © 2019 Giacomo Barzon. All rights reserved.
//

import UIKit

class HtmlComposer: NSObject {
    
    let TravelToShow: Travel
        
    let pathHtml = Bundle.main.path(forResource: "travel_new", ofType: "html")
    
    let pathTratta = Bundle.main.path(forResource: "tratta", ofType: "html")
    
    
    init(travel: Travel) {
        self.TravelToShow = travel.copyTravel()
    }
    
    func provaHtml() -> String!{
        do {
            var HTMLContent = try String(contentsOfFile: pathHtml!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ORDER#", with: String(TravelToShow.order))
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd-MM-yyyy"
            let timeFormatterGet = DateFormatter()
            timeFormatterGet.dateFormat = "HH:mm"
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#START_DATE#", with: String(dateFormatterGet.string(from: TravelToShow.startingDate)))
            HTMLContent = HTMLContent.replacingOccurrences(of: "#START_TIME#", with: String(timeFormatterGet.string(from: TravelToShow.startingDate)))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#END_DATE#", with: String(dateFormatterGet.string(from: TravelToShow.endingDate)))
            HTMLContent = HTMLContent.replacingOccurrences(of: "#END_TIME#", with: String(timeFormatterGet.string(from: TravelToShow.endingDate)))
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_TIME#", with: stringFromTimeInterval(interval: TravelToShow.durata))
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_DISTANCE#", with: String(TravelToShow.distance))
            HTMLContent = HTMLContent.replacingOccurrences(of: "#VEHICLE#", with: TravelToShow.driver.vehicle)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DRIVER#", with: TravelToShow.driver.name)
            
            
            var allItems = ""
            
            for tratta in TravelToShow.tratte{
                var itemHTMLContent = try String(contentsOfFile: pathTratta!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PASSENGER#", with: tratta.passenger.name)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#NUMBERS#", with: String(tratta.passenger.numbers))
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PHONE#", with: String(tratta.passenger.telNum))
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#START_ADD#", with: tratta.formatAddressFromPlacemark(placemark: tratta.startAddress) )
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#END_ADD#", with: tratta.formatAddressFromPlacemark(placemark: tratta.endAddress) )
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#START_TIME#", with: timeFormatterGet.string(from: tratta.startData!))
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#LUGGAGES#", with: tratta.passenger.luggage)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#COMMENTS#", with: tratta.passenger.comments)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#END_ORDER#", with: String(tratta.order ?? 0))

                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            return HTMLContent
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = UIPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        printPageRenderer.setValue(page, forKey: "paperRect")
        printPageRenderer.setValue(page, forKey: "printableRect")
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        //let prova = FileManager.default.urls(for: .downloadsDirectory
        
        let pdfFilename = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("Ordine\(String(TravelToShow.order))").appendingPathExtension("pdf")
        //let pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Ordine\(TravelToShow.order).pdf"
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Ordine\(TravelToShow.order)").appendingPathExtension("pdf")
        
        pdfData?.write(to: outputURL, atomically: true)
        
        print(pdfFilename)
    }
    
    func exportHTMLContentToData(HTMLContent: String) -> NSData {
        let printPageRenderer = UIPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        //let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let page = CGRect(x: 0, y: 0, width: 841.8, height: 595.2) // A4, 72 dpi
        printPageRenderer.setValue(page, forKey: "paperRect")
        printPageRenderer.setValue(page, forKey: "printableRect")
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        return (pdfData!)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        //UIGraphicsBeginPDFContextToData(data, CGRect(x: 0, y: 0, width: 595.2, height: 841.8), nil)
        UIGraphicsBeginPDFContextToData(data, CGRect(x: 0, y: 0, width: 841.8, height: 595.2), nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
