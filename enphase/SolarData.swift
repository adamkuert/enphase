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
    
    init() {}
    
//    init(fromPath path:String){
//        do {
//            data = try String(contentsOfFile: path)
//        } catch let error as NSError{
//            print("Error \(error)")
//        }
//    }
    
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
    
    func getData(withCallback done: (NSDictionary) -> Void) {
        if let url = NSURL(string: data_url) {
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: { (content, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription): \(error!.userInfo)")
                }
                else if content != nil {
                    if let str = NSString(data: content!, encoding: NSUTF8StringEncoding) {
                        let dict = self.jsonAsDictionary(str as String)
                        dispatch_async(dispatch_get_main_queue()) {
                            done(dict)
                        }
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