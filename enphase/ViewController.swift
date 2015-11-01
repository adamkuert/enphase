//
//  ViewController.swift
//  enphase
//
//  Created by Adam Kuert on 10/26/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    var session: WCSession!
    
    let solar_data = SolarData()
    
    @IBOutlet weak var ui_label_total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        
        ui_label_total.text = "fetching..."
        
        solar_data.getData(withCallback: handleResult)
    }
    
    func handleResult(result: NSDictionary){
//        let watts = solar_data.getTotal(result)
        let watts = arc4random_uniform(10000)
        print("Fetched \(watts) watts")
        let kilowatts = String(format: "%.1f", Double(watts)/1000)
        
        // Update App UI
        ui_label_total.text = "\(kilowatts) kWh"
        
        // Update Watch Data
        sendData(String(watts))
        
    }
    
    func sendData(data: String){
        let context = ["data": data]
        print("Sending data: \(data)")
        do {
            try session.updateApplicationContext(context)
        } catch let error {
            print("Failed to set session context")
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

