//
//  ExtensionDelegate.swift
//  enphase WatchKit Extension
//
//  Created by Adam Kuert on 10/30/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import WatchKit
import ClockKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    var session: WCSession!
    
    var solar_data: NSDictionary!

    override init() {
        super.init()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }
    
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        print("Received \(applicationContext)")
//        complicationData = applicationContext["data"] as? String
//        redraw()
//    }
    
    func redraw(){
        if let server = CLKComplicationServer.sharedInstance(){
            for comp in server.activeComplications{
                server.reloadTimelineForComplication(comp)
            }
        }
    }
    
    func handleResult(result: NSDictionary){
        solar_data = result
        let total = SolarData().getTotal(result)
        //        let total = arc4random_uniform(10000)
        print("Fetched \(total) watts")
    }
    
    func getData(){
        SolarData().getData(withCallback: { (result: NSDictionary) -> Void in
            if (result.allKeys.count > 0) {
                // Proccess and store results
                self.handleResult(result)
                
                // Update App UI
                self.redraw()
            }
        })
    }

    func applicationDidBecomeActive() {
        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        getData()
    }

    func applicationWillResignActive() {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
