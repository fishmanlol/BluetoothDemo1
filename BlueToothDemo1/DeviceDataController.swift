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
    
    @IBOutlet weak var fetchDataButton: UIButton!
    @IBOutlet weak var deviceDataTableView: UITableView!
    
    var device: Device!
    var vm: DeviceDataViewModel!
    var isDeviceConnected: BluetoothStatus = .connecting
    var centralManager: CBCentralManager!
    var allTextfields: [UITextField] = []
    
    static func loadFromStoryboard(device: Device) -> DeviceDataController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceDataController") as! DeviceDataController
        vc.device = device
        vc.vm = DeviceDataViewModel(device: device)
        
        return vc
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrorNotification), name: DeviceError.dataTooOld.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrorNotification), name: DeviceError.otherError.notificationName, object: nil)
        
        updateTitleView()
        
        vm.delegate = self
        
        view.backgroundColor = UIColor(r: 238, g: 238, b: 238)
        
        deviceDataTableView.delegate = self
        deviceDataTableView.dataSource = self
        deviceDataTableView.allowsSelection = false
        deviceDataTableView.alwaysBounceVertical = false
        deviceDataTableView.backgroundColor = UIColor(r: 238, g: 238, b: 238)
        deviceDataTableView.register(DeviceDataCell.self, forCellReuseIdentifier: "deviceDataCell")
        
        deviceDataTableView.tableFooterView = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedTableView))
        deviceDataTableView.addGestureRecognizer(tap)
        
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "gray"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        centralManager = CBCentralManager(delegate: vm, queue: nil, options: nil)
    }
    
    private func updateTitleView() {
        navigationItem.titleView = vm.titleView(for: device, isConnected: isDeviceConnected)
    }
    
    private func updateFetchDataButtonStatus() {
        
        fetchDataButton.setTitle(vm.isFetching ? "Fetching..." : "Fetch Data", for: .normal)
        
        fetchDataButton.isEnabled = isDeviceConnected == .connected
    }
    
    private func addTextFieldIfNeeded(_ textField: UITextField) {
        if !allTextfields.contains(textField) { allTextfields.append(textField) }
    }
    
    @objc private func didTappedTableView() {
        deviceDataTableView.endEditing(true)
    }
    
    @IBAction func FetchDataButtonTapped(_ sender: UIButton) {
        vm.fetchData()
    }
    
    @objc func handleErrorNotification(notification: Notification) {
        deviceDataTableView.tableFooterView = vm.tableFooterView(with: notification)
    }
    
    @objc func doneButtonTapped() {
        
        guard vm.checkInput(from: allTextfields) else { return }
        
//        vm.saveInput(from: [UITextField])
        
        navigationController?.popViewController(animated: true)
    }
}

extension DeviceDataController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.healthDataCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceDataCell", for: indexPath) as! DeviceDataCell
        cell.textField.delegate = self
        cell.textField.textColor = .black
        addTextFieldIfNeeded(cell.textField)
        vm.fill(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.headerTitle(in: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return vm.sectionFooterView(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return vm.footerHeight(at: section)
    }
    
}

extension DeviceDataController: UITableViewDelegate {
    
}

extension DeviceDataController: DeviceDataViewModelDelegate {
    
    func bluetoothStatusChange(to status: BluetoothStatus) {
        
        isDeviceConnected = status
        updateTitleView()
        updateFetchDataButtonStatus()
    }
    
    func dataFetched() {
        deviceDataTableView.reloadData()
    }
    
    func fetchingStatusChange(to isFetching: Bool) {
        updateFetchDataButtonStatus()
    }
}

extension DeviceDataController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textColor = .black
        return true
    }
}
