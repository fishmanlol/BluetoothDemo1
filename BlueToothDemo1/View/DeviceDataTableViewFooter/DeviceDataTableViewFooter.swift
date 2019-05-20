//
//  DeviceDataTableViewFooter.swift
//  BlueToothDemo1
//
//  Created by tongyi on 5/19/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class DeviceDataTableViewFooter: UIView {
    
    weak var recordTimeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        
        let recordTimeLabel = UILabel()
        recordTimeLabel.textAlignment = .center
        recordTimeLabel.font = UIFont.systemFont(ofSize: 13)
        recordTimeLabel.textColor = .gray
        self.recordTimeLabel = recordTimeLabel
        addSubview(recordTimeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recordTimeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(48)
        }
    }
    
}
