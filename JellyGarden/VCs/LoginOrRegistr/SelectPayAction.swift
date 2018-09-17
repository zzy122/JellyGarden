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
    var viewController:UIViewController = UIViewController()
    var param:[String:Any] = [:]
    
    
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
    func showAlipaiView(param:[String:Any],vc:UIViewController, complection:@escaping paySuccess)
    {
        self.payResult = complection
        self.param = param
        self.showView.isHidden = false
        self.showAction.showView = self.backView
        self.showAction.showType = .bottom
        self.showAction.showTheView()
    }

}
extension SelectPayAction:SelectPayViewDelegate
{
    func clickAlipai() {
        self.param["channel"] = "alipay"
        TargetManager.share.requestDepositPay(param: self.param) { (result, error) in
            if let str = result as? String
            {
                OtherApplication.share.pay(VC:self.viewController, charge: str, complection: { (result) in
                    if result
                    {
                        alertHud(title: "支付成功")
                    }
                    self.payResult?(result)
                })
            }
            self.showAction.hiddenTheView()
        }
    }
    
    func clickWeiChatPay() {
        self.param["channel"] = "wx"
        TargetManager.share.requestDepositPay(param: self.param) { (result, error) in
            if let dic = result as? [String:Any]
            {
                let wechat:String =  dic["appid"] as! String
                let prepayId:String = dic["prepayid"] as! String
                let nonceStr:String = dic["noncestr"] as! String
                let timeStamp:Int = dic["timestamp"] as! Int
                let new_package:String = dic["new_package"] as! String
                let sign:String = dic["sign"] as! String
                OtherApplication.share.pay(wechat: wechat, prepayId: prepayId, package: new_package, nonceStr: nonceStr, timeStamp: UInt32(timeStamp), sign: sign, completion: { (success) in
                    if success
                    {
                        alertHud(title: "支付成功")
                    }
                    self.payResult?(success)
                })
            }
            self.showAction.hiddenTheView()
        }
        
         self.showAction.hiddenTheView()
    }
    func payAction()
    {
        
    }
    func clickClose() {
         self.showAction.hiddenTheView()
    }
    
    
}
