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
        if let user = model {//这里判断需不需要判断补填信息 
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
//    nav?.pushViewController(SexViewController(), animated: true)
//    return
    if let nickName = model.appointment_place,nickName.count > 0//
    {
       
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
               //设置推送的alias
                JPUSHService.setAlias(CurrentUserInfo?.user_id ?? "testZZY", completion: { (code, alias, seq) in
                    DebugLog(message: "极光推送code:\(code),alias:\(alias ?? ""),seq:\(seq)")
                }, seq: 1235)
                judgeGesterPassword()
            }
            else
            {
                alertHud(title: "用户聊天登录失败")
            }
        })
    }
}
func judgeGesterPassword()
{
    if UserDefaults.standard.bool(forKey: "NeedGesterPassword") {//是否需要APP打开密码
        let gesterVC:CSIIGesturePasswordController = CSIIGesturePasswordController().initwithType(InitializeType.login, withState: { (success) in
            if success {
                //请求token 进入主页
                NeedGesterPassword = true
                
                
            }
        })
        
        gesterVC.isLunch = true
        gesterVC.gesturePasswordView.logoimgView.sd_DownLoadImage(url: CurrentUserInfo?.avatar ?? "")
        RootViewController?.present(gesterVC, animated: true, completion: {
            
        })
//        RootNav().pushViewController(gesterVC, animated: true)
    }
}


