//
//  UserLoginAction.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/14.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UserLoginAction: NSObject {

}
func loginActionParams(params:[String:Any],nav:UINavigationController?) {
    TargetManager.share.loginAction(params: params) { (model, error) in
        if let user = model {//这里判断需不需要判断补填信息 gotoSex
            dealWithLoginUser(model: user, nav: nav)
        }
    }
}
func thirdLoginParams(params:[String:Any],nav:UINavigationController?)
{
    TargetManager.share.thirdLoginAction(params: params) { (model, error) in
        if let user = model {//这里判断需不需要判断补填信息 gotoSex
            dealWithLoginUser(model: user, nav: nav)
        }
    }
}
func dealWithLoginUser(model:UserModel,nav:UINavigationController?)
{
    if let nickName = model.data?.appointment_place,nickName.count > 0//
    {
        //请求token 进入主页
        judgeGotoMainVC()
        
    }
    else
    {
        nav?.pushViewController(SexViewController(), animated: true)
    }
}
func judgeGotoMainVC()
{
    TargetManager.share.rongcloudToken(isRefresh:false) { (model) in
        guard let tokenModel = model else{
            return
        }
        OtherApplication.share.connectRongyun(token: tokenModel.token ?? "", complectiom: { (success) in
            if success
            {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.setRootViewController(vc: BaseTabBarViewController())
            }
            else
            {
                alertHud(title: "用户聊天登录失败")
            }
        })
    }
}


