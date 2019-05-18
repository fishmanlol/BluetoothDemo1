//
//  ScaleData.swift
//  BlueToothDemo
//
//  Created by Yi Tong on 5/16/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class WeightData: HealthData {
    
    var name: String = "weight"
    
    var value: Any?
    
    var time: Date?
    
    init(value: Double) {
        
        self.value = value
        self.time = Date()
        
    }
    
    init?(dict: [AnyHashable: Any]) {
        guard let allData = dict["DeviceData"] as? [[String: Any]], let data = allData.first else { return nil }
        guard let weight = Double(data["Weight"] as? String ?? "") else { return nil }
        
        let year = Int(data["year"] as? String ?? "")
        let month = Int(data["month"] as? String ?? "")
        let day = Int(data["day"] as? String ?? "")
        let hour = Int(data["hour"] as? String ?? "")
        let min = Int(data["min"] as? String ?? "")
        let sec = Int(data["sec"] as? String ?? "")
        
        
        if let time = Date(year: year, month: month, day: day, hour: hour, min: min, sec: sec) {
            if time.timeIntervalSinceNow < -15 {
                return nil
            } else {
                self.value = weight
                self.time = time
            }
        }
    }
}
