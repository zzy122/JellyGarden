//
//  CountAction.swift
//  JellyGarden
//
//  Created by zzy on 19/9/18.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

public enum LimitType:Int {
    case appiontAction//发布约会
    case checkPhone//查看手机号  目前没有看到这个入口
    case checkQQ//查看qq
    case checkWeichat//查看微信
    case privatChat//发起私聊
    case photos//解锁相册
}


class CountAction: NSObject {//权限判断
    func checkLimit(seekUserId:String?, type:LimitType,complection:@escaping (Bool) -> Void)
    {
        var params:[String:Any] = ["user_id":CurrentUserInfo?.user_id ?? "","action":"1"]
        
        var payAction:Int = 5
        
        if let str = seekUserId
        {
            params["view_userid"] = str
        }
        var message:String = ""
        switch type {
        case .appiontAction:
            payAction = 7
            params["action"] = "1"
            message = "你今天免费机会已用完,发布约会需支付"
            break
        case .checkPhone:
            params["action"] = "2"
            message = "你今天免费机会已用完,查看联系方式需支付"
            break
        case .checkQQ:
            params["action"] = "3"
            message = "你今天免费机会已用完,查看QQ需支付"
            break
        case .checkWeichat:
            params["action"] = "4"
            message = "你今天免费机会已用完,查看微信需支付"
            break
        case .privatChat:
            payAction = 6
            params["action"] = "5"
            message = "你今天免费机会已用完,私聊需支付"
            break
        case .photos:
            payAction = 4
            params["action"] = "6"
            message = "你今天免费机会已用完,解锁相册需支付"
            break
        }
        TargetManager.share.requestCountLimit(param: params) { (model, error) in
            if let model1 = model {
                if model1.num > 0
                {
                    complection(true)
                }
                else
                {
                    AlertViewCoustom().showalertView(style: .alert, title: nil, message: "\(message)\(model1.price)元", cancelBtnTitle: alertCancel, touchIndex: { (clickTag) in
                        if clickTag == 0
                        {
                            complection(false)
                        }
                        else
                        {
                            SelectPayAction.shared.showAlipaiView(param: ["user_id":CurrentUserInfo?.user_id ?? "","amount":model1.price,"apply_userid":seekUserId ?? "0","action":payAction,"channel":"wx"], vc: RootNav().topViewController!, complection: { (success) in
                                complection(success)
                            })
                        }
                    }, otherButtonTitles: "支付")
                }
            }
            else
            {
                complection(false)
            }
        }
    }
}
