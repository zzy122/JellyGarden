//
//  SelectPayAction.swift
//  JellyGarden
//
//  Created by kfzs on 2018/9/13.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class SelectPayAction: NSObject {
    typealias paySuccess = (Bool) -> Void
    static let shared = SelectPayAction()
    var payResult:paySuccess?
    var payCount:String = "0"
    
    
    private override init() {
        
    }
    var backView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect.init(x: 0, y: ScreenHeight - 200, width: ScreenWidth, height: 200)
        return view
    }()
    
    lazy var showView:SelectPayView = {
        let view1 = SelectPayView.createSelectPayView()
        view1?.frame = self.backView.bounds
        self.backView.addSubview(view1!)
        view1?.delegate = self
        return view1!
    }()
    
    lazy var showAction:AlipayAction = {
        let action:AlipayAction = AlipayAction.init(showType: .bottom, view: self.backView, windowView: RootViewController?.view)
        return action
        }()
    func showAlipaiView(amountStr:String, complection:@escaping paySuccess)
    {
        self.payResult = complection
        self.payCount = amountStr
        self.showView.isHidden = false
        self.showAction.showView = self.backView
        self.showAction.showType = .bottom
        self.showAction.showTheView()
    }

}
extension SelectPayAction:SelectPayViewDelegate
{
    func clickAlipai() {
        
        
        self.showAction.hiddenTheView()
    }
    
    func clickWeiChatPay() {
         self.showAction.hiddenTheView()
    }
    
    func clickClose() {
         self.showAction.hiddenTheView()
    }
    
    
}
