//
//  Date.swift
//  TestBlueTooth
//
//  Created by Yi Tong on 5/9/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

extension Date {
    
    init?(year: Int?, month: Int?, day: Int?, hour: Int?, min: Int?, sec: Int?) {
        
        guard let year = year, let month = month, let day = day, let hour = hour, let min = min, let sec = sec else { return nil }
        
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        let components = DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: year, month: month, day: day, hour: hour, minute: min, second: sec, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        if let date = components.date {
            self = date
        } else {
            return nil
        }
    }
    
    var formattedString: String {
        
        let now = Date()
        let interval = Int(now.timeIntervalSince(self).rounded())
        
        switch interval {
        case 0..<10:
            return "Just Now"
        case 10..<60:
            return "Less Than Minute"
        case 60..<3600:
            return "\(interval/60)" + (interval/60 > 1 ? "minutes" : "minute") + "ago"
        case 3600..<86400:
            return "\(interval/3600)" + (interval/3660 > 1 ? "hours" : "hour") + "ago"
        default:
            return "\(interval/86400)" + (interval/86400 > 1 ? "days" : "day") + "ago"
        }
        
    }
    
}
