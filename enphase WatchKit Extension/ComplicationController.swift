//
//  ComplicationController.swift
//  enphase WatchKit Extension
//
//  Created by Adam Kuert on 10/30/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        if complication.family == .ModularSmall {
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "--")
            
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
            for x in 1...limit {
                let template = CLKComplicationTemplateModularSmallSimpleText()
                let d = NSDate(timeInterval: -1*Double(x)*60*60, sinceDate: date)
                let calendar = NSCalendar.currentCalendar()
                let hour = calendar.component(.Hour, fromDate: d)
                template.textProvider = CLKSimpleTextProvider(text: String(hour))
                let timelineEntry = CLKComplicationTimelineEntry(date: d, complicationTemplate: template)
                entries.append(timelineEntry)
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

        // Every 30 mins
        handler(NSDate(timeIntervalSinceNow: 60*30))
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
