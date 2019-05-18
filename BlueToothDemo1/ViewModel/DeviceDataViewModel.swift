//
//  DeviceDataViewModel.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

protocol DeviceDataViewModelDelegate: class {
    func bluetoothStatusChange(to status: BluetoothStatus)
}

class DeviceDataViewModel: NSObject {
    
    let device: Device
    
    let command: DeviceCommand
    
    var knowDevicesUUID: [String] = []
    
    var titleView: DeviceDataTitleView?
    
    weak var delegate: DeviceDataViewModelDelegate?
    
    var interestPeripheral: CBPeripheral?
    
    
    
    init(device: Device) {
        self.device = device
        self.command = DeviceCommand()
        
        let defaults = UserDefaults.standard
        knowDevicesUUID = defaults.array(forKey: "knowDevices") as? [String] ?? []
    }
    
    //Public functions
    func titleView(for device: Device, isConnected: BluetoothStatus) -> UIView {
        
        if titleView == nil {
            let titleView = DeviceDataTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
            self.titleView = titleView
            titleView.deviceNameLabel.text = device.name
        }
        
        switch isConnected {
        case .connected:
            titleView!.bluetoothStatusIndicator.stopAnimating()
            titleView!.bluetoothStatusLabel.text = "connected"
            titleView!.bluetoothStatusLabel.textColor = .blue
        case .disconnected:
            titleView!.bluetoothStatusIndicator.stopAnimating()
            titleView!.bluetoothStatusLabel.text = "disconnected"
            titleView!.bluetoothStatusLabel.textColor = .red
        case .connecting:
            titleView!.bluetoothStatusLabel.text = ""
            titleView!.bluetoothStatusIndicator.startAnimating()
        }
        
        if isConnected == .connected {
            
        } else if isConnected == .disconnected {
            
        }
        
        return titleView!
    }
    
    @objc func doneButtonTapped() {
        print("Done")
    }
    
}

extension DeviceDataViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth poweredOn")
        case .poweredOff:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth poweredOffs")
        case .unauthorized:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth unauthorized")
        case .unknown:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth unknown")
        case .unsupported:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth unsupported")
        case .resetting:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Bluetooth restting")
        default:
            delegate?.bluetoothStatusChange(to: .disconnected)
            print("Unkown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let name = peripheral.name else { return }
        
        if name.hasPrefix("SpO208") || name.hasPrefix("TEMP030024") || name.hasPrefix("WT01") {
            self.interestPeripheral = peripheral
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("\(peripheral.name ?? "Unkown") did connected!")
        
        delegate?.bluetoothStatusChange(to: .connected)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        print("\(peripheral.name ?? "Unkown") did disconnected!")
        
        delegate?.bluetoothStatusChange(to: .disconnected)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("\(peripheral.name ?? "Unkown") did fail to connect!")
        
        delegate?.bluetoothStatusChange(to: .disconnected)
    }
}

enum BluetoothStatus {
    case connected, disconnected, connecting
}
