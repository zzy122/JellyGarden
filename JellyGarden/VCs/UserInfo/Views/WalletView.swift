//
//  WalletView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickDeposit = "ClickDeposit"
class WalletView: UIView {

    @IBOutlet weak var dePositBtn: UIButton!
    @IBOutlet weak var depositLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    class func createWalletView() ->WalletView?
    {
        let nibView = CustomCreateNib<WalletView>().createXibView()
        return nibView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func clickDepositBtn(_ sender: UIButton) {
        zzy.router(name: ClickDeposit, object: nil, info: nil)
    }
    
}
