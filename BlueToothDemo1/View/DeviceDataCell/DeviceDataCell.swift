//
//  DeviceDataCell.swift
//  BlueToothDemo1
//
//  Created by tongyi on 5/19/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class DeviceDataCell: UITableViewCell {
    
    weak var textField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Private functions
    private func setup() {
        
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.clearButtonMode = .always
        self.textField = textField
        contentView.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.center.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
}
