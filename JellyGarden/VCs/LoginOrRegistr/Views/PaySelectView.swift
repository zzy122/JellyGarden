//
//  PaySelectView.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class PaySelectView: UIView {
    var isSelectAlipay:Bool = true
    
    
    @IBOutlet weak var weiChatPayBtn: UIButton!
    @IBOutlet weak var aliPayBtn: UIButton!
    var tagFrame:CGRect?
    override func draw(_ rect: CGRect) {
        self.frame = tagFrame!
    }
    class func createPaySelectView() -> PaySelectView? {
        let nibView = CustomCreateNib<PaySelectView>().createXibView()
        guard let view = nibView else {
            return nil
        }
        view.aliPayBtn.isSelected = true
        return view;
    }
    
    @IBAction func clickWeichatPay(_ sender: UIButton) {
        self.weiChatPayBtn.isSelected = true
        isSelectAlipay = false
        self.aliPayBtn.isSelected = false
    }
    @IBAction func clickAliPay(_ sender: UIButton) {
        self.weiChatPayBtn.isSelected = false
        isSelectAlipay = true
        self.aliPayBtn.isSelected = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
