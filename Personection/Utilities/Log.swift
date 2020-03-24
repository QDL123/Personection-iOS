//
//  Log.swift
//  Personection
//
//  Created by Quintin Leary on 6/8/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import Foundation
import FirebaseAnalytics

let eventTypes = [
    LogEvent.nullCurrentUser : "Null Current User",
    LogEvent.authentication : "Authentication Error Occurred",
    LogEvent.download : "Error Downloading Data",
    LogEvent.null : "Unexpected Null Value"
]

public class Log {
    
    static func e(eventType: LogEvent, message: String) {
        //print to the debugger
        print("*********** DEBUG ERROR MESSAGE **********")
        print(eventTypes[eventType] ?? "No Event Type" + ": " + message)
        print("******************************************")
        
        //log the event in analytics
        Analytics.logEvent(eventTypes[eventType] ?? "No Event Type", parameters: [
            "category" : "ERROR" as NSObject,
            "eventType" : eventTypes[eventType] ?? "No Event Type" as NSObject,
            "message" : message as NSObject
        ])
    }
    
    static func i(message: String) {
        //print to the debugger
        print("********** EVENT INFORMATION **********")
        print(message)
        print("***************************************")
        
        //log the event in analytics
        Analytics.logEvent("Information", parameters: [
            "category" : "INFORMATION" as NSObject,
            "message" : message as NSObject
        ])
    }
    
    static func wtf(message: String) {
        //print to the debugger
        print("*********** WTF HAPPENED ***********************************************")
        print("Something very whack has occured and needs to be looked at immediately")
        print("Here's the message: " + message)
        print("************************************************************************")
        
        //log the event in analytics
        Analytics.logEvent("WTF", parameters: [
            "category" : "WTF" as NSObject,
            "message" : message as NSObject
        ])
    }
}
