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
    
    var watts: Int!
    
    var fetch_count = 0
    
    @IBOutlet weak var ui_fetch_count: UILabel!
    @IBOutlet weak var ui_label_total: UILabel!
    @IBOutlet weak var ui_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }

//    func getData() {
//        SolarData().getData(withCallback: { (result: NSDictionary) -> Void in
//            // Proccess and store results
//            self.handleResult(result)
//
//            // Update App UI
//            self.updateUI()
//            
//            // Update Watch Data
//            self.sendData()
//        })
//    }
//    
//    func getDataFromBackground(withCompletionHandler completionHandler: (UIBackgroundFetchResult)-> Void){
//        fetch_count += 1
//        SolarData().getData(withCallback: { (result: NSDictionary) -> Void in
//            // Proccess and store results
//            self.handleResult(result)
//            
//            // Update Watch Data
//            self.sendData()
//            
//            // Tell the system we're done
//            completionHandler(.NewData)
//        })
//    }
//    
//    @IBAction func buttonPressed(sender: UIButton) {
//        getData()
//    }
//    
//    func handleResult(result: NSDictionary){
//        let total = SolarData().getTotal(result)
////        let total = arc4random_uniform(10000)
//        print("Fetched \(total) watts")
//        watts = Int(total)
//    }
//    
//    func updateUI(){
//        let kilowatts = String(format: "%.1f", Double(watts)/1000)
//        dispatch_async(dispatch_get_main_queue()) {
//            self.ui_fetch_count.text = "\(self.fetch_count)"
//            self.ui_label_total.text = "\(kilowatts) kWh"
//        }
//    }
//    
//    func sendData(){
//        if (session.paired) {
//            print("Sending data: \(String(watts))")
//            let context = ["data": String(watts)]
//            do {
//                try session.updateApplicationContext(context)
//            } catch let error {
//                print("Failed to set session context")
//                print(error)
//            }
//        } else {
//            print("Device not paired")
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

