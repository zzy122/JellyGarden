//
//  DepositRuleView.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/5.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
//let ClickCloseDepositView = "ClickCloseDepositView"
typealias ClickCloseDepositView = () -> ()
class DepositRuleView: UIView {
    private var closeMyView:ClickCloseDepositView?
    
    class func createRuleView() ->DepositRuleView
    {
        let nibView = CustomCreateNib<DepositRuleView>().createXibView()
        nibView?.layer.cornerRadius = 8
        nibView?.clipsToBounds = true
        return nibView!
    }
    func  clickClose(close:@escaping ClickCloseDepositView) {
        self.closeMyView = close
    }
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        closeMyView?()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
