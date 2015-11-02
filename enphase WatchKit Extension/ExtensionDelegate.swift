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
    
    var complicationData: String!

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
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("Received \(applicationContext)")
        complicationData = applicationContext["data"] as? String
        
        if let server = CLKComplicationServer.sharedInstance(){
            for comp in server.activeComplications{
                server.reloadTimelineForComplication(comp)
            }
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
