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
    
    func dataFetched()
    
    func fetchingStatusChange(to isFetching: Bool)
}

class DeviceDataViewModel: NSObject {
    
    let device: Device
    
    let command: DeviceCommand
    
    var knowDevicesUUID: [String] = []
    
    var titleView: DeviceDataTitleView?
    
    weak var delegate: DeviceDataViewModelDelegate?
    
    var interestPeripheral: CBPeripheral?
    
    var isFetching: Bool = false {
        didSet {
            delegate?.fetchingStatusChange(to: isFetching)
        }
    }
    
    
    
    init(device: Device) {
        
        self.device = device
        self.command = DeviceCommand()
        
        super.init()
    
        command.delegate = self
        
        let defaults = UserDefaults.standard
        knowDevicesUUID = defaults.array(forKey: "knowDevices") as? [String] ?? []
    }
    
    //Public functions
    
    func checkInput(from textFields: [UITextField]) -> Bool {
        
        var isValid = true
        
        for (index, tf) in textFields.enumerated() {
            
            if tf.text == nil || tf.text! == "" {
                device.data[index].value = nil
                continue
            }
            
            if let value = Double(tf.text!), value < Double(Int.max) {
                
                device.data[index].value = value
                
            } else {
                
                tf.textColor = .red
                
                isValid = false
            }
            
        }
        
        return isValid
    }
    
    func tableFooterView(with notification: Notification) -> UIView {
        
        let message = notification.userInfo?["message"] as? String ?? ""
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .red
        label.text = message
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                label.alpha = 0
            })
        }
        
        return label
    }
    
    func footerHeight(at section: Int) -> CGFloat {
        return section == device.data.count - 1 ? 80 : 0
    }
    
    func sectionFooterView(at section: Int) -> UIView? {
        
        guard section == device.data.count - 1, let firstData = device.data.first, let time = firstData.time else { return nil }
        
        let footerView = DeviceDataTableViewFooter(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        footerView.recordTimeLabel.text = "Recorded at: \(time.formattedString)"
        return footerView
    }
    
    func fetchData() {
        
        command.peripheral(interestPeripheral, receiveData: 1)
        isFetching = true
    }
    
    func fill(_ cell: DeviceDataCell, at indexPath: IndexPath) {
        
        let healthData = device.data[indexPath.section]
        
        if healthData.value != nil {
            
            if let doubleValue = healthData.value as? Double {
                if doubleValue == Double(Int(doubleValue)) {
                    cell.textField.text = String(Int(doubleValue))
                } else {
                    cell.textField.text = String(doubleValue)
                }
            }
            
        } else {
            cell.textField.text = ""
        }
        
    }
    
    func healthDataCount() -> Int {
        return device.data.count
    }
    
    func headerTitle(in section: Int) -> String {
        return device.data[section].name
    }
    
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
            titleView!.bluetoothStatusLabel.textColor = UIColor(r: 0, g: 122, b: 255)
        case .disconnected:
            titleView!.bluetoothStatusIndicator.stopAnimating()
            titleView!.bluetoothStatusLabel.text = "disconnected"
            titleView!.bluetoothStatusLabel.textColor = .red
        case .connecting:
            titleView!.bluetoothStatusLabel.text = ""
            titleView!.bluetoothStatusIndicator.startAnimating()
        }
        
        return titleView!
    }
    
}

extension DeviceDataViewModel: DeviceCommandDelegate {
    func getDeviceData(_ dicDeviceData: [AnyHashable : Any]!) {
        
        isFetching = false
        var dataValid = false
        
        if let data = OxygenData(data: dicDeviceData), var oxygenData = device.data.first(where: { $0.name == "oxygen" }) {
            
            dataValid = true
            
            oxygenData.value = data.value
            oxygenData.time = data.time
            
            delegate?.dataFetched()
        }
        
        if let data = PulseData(data: dicDeviceData), var pulseData = device.data.first(where: { $0.name == "pulse" }) {
            
            dataValid = true
            
            pulseData.value = data.value
            pulseData.time = data.time
            
            delegate?.dataFetched()
        }
        
        if !dataValid {
            NotificationCenter.default.post(name: DeviceError.otherError.notificationName, object: nil, userInfo: ["message": "Data is not valid, please try again"])
        }
        
    }
    
    func getOperateResult(_ dicOperateResult: [AnyHashable : Any]!) {
        print(#function)
    }
    
    func getError(_ dicError: [AnyHashable : Any]!) {
        
        print(#function)
        print(dicError ?? "")
        
        NotificationCenter.default.post(name: DeviceError.otherError.notificationName, object: nil, userInfo: ["message": "Please make sure your device is turned on"])
        isFetching = false
    }
    
    
}

extension DeviceDataViewModel: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
            delegate?.bluetoothStatusChange(to: .connecting)
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
        
        delegate?.bluetoothStatusChange(to: .connecting)
        
        isFetching = false
        
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("\(peripheral.name ?? "Unkown") did fail to connect!")
        
        delegate?.bluetoothStatusChange(to: .connecting)
        
        isFetching = false
        
        central.connect(peripheral, options: nil)
    }
}

enum BluetoothStatus {
    case connected, disconnected, connecting
}
