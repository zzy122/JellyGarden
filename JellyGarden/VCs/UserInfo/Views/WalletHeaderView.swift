//
//  WalletView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/7.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
let ClickDeposit = "ClickDeposit"
class WalletHeaderView: UIView {
    @IBOutlet weak var dePositBtn: UIButton!
    @IBOutlet weak var depositLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBAction func clickDepositBtn(_ sender: UIButton) {
        zzy.router(name: ClickDeposit, object: nil, info: nil)
    }
    class func createWalletHeaderView() ->WalletHeaderView?
    {
        let nibView = CustomCreateNib<WalletHeaderView>().createXibView()
        return nibView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
