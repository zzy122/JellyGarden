//
//  NoDepositRecord.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/6.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class NoDepositRecord: UIView {
    class func  createNoDepositRecord() ->NoDepositRecord
    {
        let nibView = CustomCreateNib<NoDepositRecord>().createXibView()
        return nibView!
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
