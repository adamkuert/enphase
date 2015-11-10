//
//  ComplicationController.swift
//  enphase WatchKit Extension
//
//  Created by Adam Kuert on 10/30/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import ClockKit
import WatchKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        if let data = delegate.solar_data {
            let start_time = SolarData().getStartTime(data)
            handler(NSDate(timeIntervalSince1970: Double(start_time)))
        } else {
            handler(NSDate())
        }
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        if complication.family == .ModularSmall {
            let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
            var text = "--"
            if let data = delegate.solar_data {
                let watts = SolarData().getTotal(data)
                text = SolarData().asKWH(watts)
            }
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: text)
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            handler(timelineEntry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        if complication.family == .ModularSmall {
            var entries = [CLKComplicationTimelineEntry]()
            let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
            if let data = delegate.solar_data {
                let start_time = SolarData().getStartTime(data)
                let interval_length = SolarData().getIntervalLength(data)
                let production = SolarData().getProduction(data)
                let startDate = NSDate(timeIntervalSince1970: Double(start_time))
                var interval = 0
                var total = 0
                for p in production {
                    interval += 1
                    total += (p as? Int)!
                    let d = NSDate(timeInterval: Double(interval_length*interval), sinceDate: startDate)
                    let template = CLKComplicationTemplateModularSmallSimpleText()
                    let text = SolarData().asKWH(total)
                    template.textProvider = CLKSimpleTextProvider(text: text)
                    let timelineEntry = CLKComplicationTimelineEntry(date: d, complicationTemplate: template)
                    entries.append(timelineEntry)
                }
            }
            handler(entries)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        // Every 15 mins
        handler(NSDate(timeIntervalSinceNow: 60*15))
    }
    
    func requestedUpdateDidBegin() {
        let delegate = WKExtension.sharedExtension().delegate as! ExtensionDelegate
        delegate.getData()
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        switch complication.family {
        case .ModularSmall:
            let modularTemplate = CLKComplicationTemplateModularSmallSimpleText()
            modularTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            template = modularTemplate
        case .ModularLarge:
            template = nil
        case .UtilitarianSmall:
            template = nil
        case .UtilitarianLarge:
            template = nil
        case .CircularSmall:
            template = nil
        }
        handler(template)
    }
    
}
