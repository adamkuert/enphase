//
//  SolarData.swift
//  enphase
//
//  Created by Adam Kuert on 10/26/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import Foundation


class SolarData {
    let data_url = "https://enlighten.enphaseenergy.com/pv/public_systems/752126/today"
//    let data_url = "http://files.kuert.net/enphase/data.json"
//    let data_url = "https://enlighten-enphaseenergy-com-0yksu4dp6cl7.runscope.net/pv/public_systems/752126/today"
    
    init() {}
    
    func jsonAsDictionary(str:String) -> NSDictionary {
        do {
            if let ns_data = str.dataUsingEncoding(NSUTF8StringEncoding) {
                if let dict: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(ns_data, options:.MutableContainers) as? NSDictionary){
                    return dict
                }
            }
        } catch let caught as NSError{
            print(caught)
        } catch {
            print("Something went wrong")
        }
        return NSDictionary()
    }
    
    func getTotal(dict:NSDictionary) -> NSInteger {
        var total = 0
        let energy: NSArray = (dict["energy"] as? NSArray)!
        let firstElement: NSDictionary = (energy[0] as? NSDictionary)!
        for production in (firstElement["production"] as? NSArray)!{
            total += Int(production as! NSNumber)
        }
        return total
    }
    
    func getStartTime(dict:NSDictionary) -> NSInteger {
        let energy: NSArray = (dict["energy"] as? NSArray)!
        let firstElement: NSDictionary = (energy[0] as? NSDictionary)!
        let startTime = firstElement["start_time"] as? NSInteger!
        return startTime!
    }
    
    func getIntervalLength(dict:NSDictionary) -> NSInteger {
        let energy: NSArray = (dict["energy"] as? NSArray)!
        let firstElement: NSDictionary = (energy[0] as? NSDictionary)!
        let interval = firstElement["interval_length"] as? NSInteger!
        return interval!
    }
    
    func getProduction(dict:NSDictionary) -> NSArray {
        let energy: NSArray = (dict["energy"] as? NSArray)!
        let firstElement: NSDictionary = (energy[0] as? NSDictionary)!
        let production = firstElement["production"] as? NSArray!
        return production!
    }
    
    func asKWH(watts:NSInteger) -> String {
        return String(format: "%.1f", Double(watts)/1000)
    }
    
    func getData(withCallback callback: (NSDictionary) -> Void) {
        if let url = NSURL(string: data_url) {
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request, completionHandler: { (content, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription): \(error!.userInfo)")
                } else if content != nil {
                    print(content)
                    if let str = NSString(data: content!, encoding: NSUTF8StringEncoding) {
                        let dict = self.jsonAsDictionary(str as String)
                        callback(dict)
                    }
                    else {
                        print("unable to convert data to text")
                    }
                }
            })
            task.resume()
        }
        else {
            print("Unable to create NSURL")
        }
    }
}