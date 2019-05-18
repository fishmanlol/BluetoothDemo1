//
//  DeviceTableViewHeader.swift
//  BlueToothDemo1
//
//  Created by Yi Tong on 5/17/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class DeviceTableViewHeader: UIView {
    
    weak var noDeviceButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        
        let button = UIButton(type: .system)
        button.setTitle("I don't have device", for: .normal)
        self.noDeviceButton = button
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        noDeviceButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
