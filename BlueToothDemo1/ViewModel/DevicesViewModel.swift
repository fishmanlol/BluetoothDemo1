//
//  DeviceViewModel.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class DevicesViewModel {

    private let devices: [Device]
    
    init() {
        
        let poDevice = Device(type: .pulseOximeter)
        let etDevice = Device(type: .earThermometer)
        let esDevice = Device(type: .electronicScale)
        
        devices = [poDevice, etDevice, esDevice]
    }
    
    //Public funcitons
    func devicesCount() -> Int {
        return devices.count
    }
    
    func device(at indexPath: IndexPath) -> Device {
        return devices[indexPath.row]
    }
    
    func fill(_ cell: DeviceTableViewCell, at indexPath: IndexPath) {
        
        let device = devices[indexPath.row]
        
        cell.deviceImageView.image = device.image
        cell.deviceNameLabel.text = device.name
    }
    
    @objc func noDeviceButtonTapped() {
        print("No Device")
    }
    
    //Private functions
    
}
