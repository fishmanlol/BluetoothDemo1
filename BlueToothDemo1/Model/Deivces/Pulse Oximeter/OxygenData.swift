//
//  OxygenData.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct OxygenData: HealthData {
    
    var name: String = "oxygen"
    
    var value: Any?
    
    var time: Date?
    
    init(oxygen: Double) {
        self.value = oxygen
    }
    
    init?(data: [AnyHashable: Any]) {
        
        guard let oxygenPulse = data["OxygenPulse"], let dict = oxygenPulse as? [AnyHashable: Any], let deviceData = dict["DeviceData1"] as? [[String: Any]], let firstData = deviceData.first else { return nil }
        
        let year = Int(firstData["year"] as? String ?? "")
        let month = Int(firstData["month"] as? String ?? "")
        let day = Int(firstData["day"] as? String ?? "")
        let hour = Int(firstData["hour"] as? String ?? "")
        let min = Int(firstData["min"] as? String ?? "")
        let sec = Int(firstData["sec"] as? String ?? "")
        
        if let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            if time.timeIntervalSinceNow < -15 {
                return nil
            } else {
                self.value = Double(firstData["Oxygen"] as? String ?? "")
                self.time = time
            }
        }
    }
}

