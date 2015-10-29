//
//  SolarData.swift
//  enphase
//
//  Created by Adam Kuert on 10/26/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import Foundation


class SolarData {
    var data = ""
    let data_url = "https://enlighten.enphaseenergy.com/pv/public_systems/752126/today"
    
    init() {}
    
    init(fromPath path:String){
        do {
            data = try String(contentsOfFile: path)
        } catch let error as NSError{
            print("Error \(error)")
        }
    }
    
    func asJson() -> NSDictionary {
        do {
            if let ns_data = data.dataUsingEncoding(NSUTF8StringEncoding) {
                if let jsonResult: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(ns_data, options:.MutableContainers) as? NSDictionary){
                    return jsonResult
                }
            }
        } catch let caught as NSError{
            print(caught)
        } catch {
            print("Something went wrong")
        }
        return NSDictionary()
    }
    
    func getTotal() -> NSInteger {
        let json = asJson()
        let energy: NSArray = (json["energy"] as? NSArray)!
        let firstElement: NSDictionary = (energy[0] as? NSDictionary)!
        
        let productions = (firstElement["production"] as? NSArray)!
        
        var total = 0
        for production in productions{
            total += Int(production as! NSNumber)
        }
        
        return total
    }
    
    func getData(withCallback done: (String) -> Void) {
        if let url = NSURL(string: data_url) {
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: { (content, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription): \(error!.userInfo)")
                }
                else if content != nil {
                    if let str = NSString(data: content!, encoding: NSUTF8StringEncoding) {
                        self.data = str as String
                        let total = self.getTotal()
                        done(String(total))
                        print("Received data")
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