//
//  DeviceDataTitleView.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

class DeviceDataTitleView: UIView {
    
    weak var deviceNameLabel: UILabel!
    weak var bluetoothStatusLabel: UILabel!
    weak var bluetoothStatusIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        
        let deviceNameLabel = UILabel()
        deviceNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        deviceNameLabel.textAlignment = .center
        self.deviceNameLabel = deviceNameLabel
        addSubview(deviceNameLabel)
        
        let bluetoothStatusLabel = UILabel()
        bluetoothStatusLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bluetoothStatusLabel.textAlignment = .center
        self.bluetoothStatusLabel = bluetoothStatusLabel
        addSubview(bluetoothStatusLabel)
        
        let bluetoothStatusIndicator = UIActivityIndicatorView(style: .gray)
        bluetoothStatusIndicator.isHidden = true
        bluetoothStatusIndicator.hidesWhenStopped = true
        self.bluetoothStatusIndicator = bluetoothStatusIndicator
        addSubview(bluetoothStatusIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bluetoothStatusLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-2)
            make.left.right.equalToSuperview()
        }
        
        bluetoothStatusIndicator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-2)
            make.centerX.equalToSuperview()
        }
        
        deviceNameLabel.snp.remakeConstraints { (make) in
            
            make.top.equalToSuperview().offset(bluetoothStatusIndicator.isHidden ? 4 : 0)
            make.left.right.equalToSuperview()
        }
    }
    
}
