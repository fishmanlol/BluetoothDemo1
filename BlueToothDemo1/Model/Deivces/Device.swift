//
//  Device.swift
//  TestBlueTooth
//
//  Created by Yi Tong on 5/14/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

protocol HealthData {
    
    var name: String { get set}
    var value: Any? { get set }
    var time: Date? { get set }
}

class Device: Equatable {
    
    let type: DeviceType
    
    var data: [HealthData] = []
    
    var image: UIImage? {
        
        switch type {
        case .earThermometer:
            return UIImage(named: "heart")
        case .pulseOximeter:
            return UIImage(named: "heart")
        case .electronicScale:
            return UIImage(named: "heart")
        }
    }
    
    var name: String {
        
        switch type {
        case .pulseOximeter:
            return "Pulse Oximeter"
        case .earThermometer:
            return "Ear Thermometer"
        case .electronicScale:
            return "Electronic Scale"
        }
    }
    
    init(type: DeviceType) {
        self.type = type
    }
    
    static func ==(lhs: Device, rhs: Device) -> Bool {
        
        return lhs.name == rhs.name
        
    }
    
}

enum DeviceType: CaseIterable {
    
    case pulseOximeter, earThermometer, electronicScale
    
}

enum DeviceError {
    case dataTooOld, otherError
    
    var notificationName: NSNotification.Name {
        switch self {
        case .dataTooOld:
            return NSNotification.Name("dataTooOld")
        case .otherError:
            return NSNotification.Name("otherError")
        }
    }
}
