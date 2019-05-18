//
//  ViewController.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class DevicesController: UITableViewController {
    
    let cellId = "deviceCell"
    
    let vm = DevicesViewModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        
    }
    
    private func setup() {
        
        title = "Deivces"
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "DeviceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
}

//Table View Data Source
extension DevicesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.devicesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DeviceTableViewCell
       
        vm.fill(cell, at: indexPath)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = DeviceTableViewHeader()
        header.noDeviceButton.addTarget(vm, action: #selector(vm.noDeviceButtonTapped), for: .touchUpInside)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//Table View Delegate
extension DevicesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device = vm.device(at: indexPath)
        
        let deviceDataController = DeviceDataController(device: device)
        
        navigationController?.pushViewController(deviceDataController, animated: true)
    }
    
}

