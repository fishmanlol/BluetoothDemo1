//
//  DeviceDataController.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import Foundation

class DeviceDataController: UIViewController {
    
    let device: Device
    let vm: DeviceDataViewModel
    var isDeviceConnected: BluetoothStatus = .connecting
    var centralManager: CBCentralManager!
    
    init(device: Device) {
        
        self.device = device
        self.vm = DeviceDataViewModel(device: device)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.device = Device(type: .pulseOximeter)
        self.vm = DeviceDataViewModel(device: device)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    //Private functions
    private func setup() {
        updateTitleView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: vm, action: #selector(vm.doneButtonTapped))
        view.backgroundColor = .white
        
        centralManager = CBCentralManager(delegate: vm, queue: nil, options: nil)
    }
    
    private func updateTitleView() {
        navigationItem.titleView = vm.titleView(for: device, isConnected: isDeviceConnected)
    }
    
}

extension DeviceDataController: DeviceDataViewModelDelegate {
    
    func bluetoothStatusChange(to status: BluetoothStatus) {
        
        isDeviceConnected = status
        updateTitleView()
    }
    
}
