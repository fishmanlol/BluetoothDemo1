//
//  ETData.swift
//  TestBlueTooth
//
//  Created by Yi Tong on 5/14/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class TemperatureData: HealthData {
    var name = "temperature"
    
    var value: Any?
    
    var time: Date?
    
    var unit: TemperatureUnit?
    
    init(temperature: Double, unit: TemperatureUnit) {
        self.value = temperature
        self.unit = unit
    }
    
    init?(dict: [AnyHashable: Any]) {
        guard let allData = dict["DeviceData"] as? [[String: Any]], let data = allData.first else { return nil }
        guard let temperature = Double(data["temperature"] as? String ?? "") else { return nil }
        
        let year = Int(data["year"] as? String ?? "")
        let month = Int(data["month"] as? String ?? "")
        let day = Int(data["day"] as? String ?? "")
        let hour = Int(data["hour"] as? String ?? "")
        let min = Int(data["min"] as? String ?? "")
        let sec = Int(data["sec"] as? String ?? "")
        
        
        if let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            print(time.timeIntervalSinceNow)
            if time.timeIntervalSinceNow < -15 {
                return nil
            } else {
                self.value = temperature
                self.unit = TemperatureUnit(rawValue: data["UnitState"] as? String ?? "")
                self.time = time
            }
        }
    }
}

enum TemperatureUnit: String {
    case C, F
    
    var symbol: String {
        switch self {
        case .C:
            return "\u{2103}"
        case .F:
            return "\u{2109}"
        }
    }
}
