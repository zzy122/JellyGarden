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
func dealWithLoginUser(model:UserModel,nav:UINavigationController?)
{
    if let nickName = model.data?.nickname,nickName.count > 0//
    {
        DebugLog(message: "进入首页");
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setRootViewController(vc: BaseTabBarViewController())
    }
    else
    {
        nav?.pushViewController(SexViewController(), animated: true)
    }
}

