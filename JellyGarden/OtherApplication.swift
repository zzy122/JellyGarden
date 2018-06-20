//
//  OtherApplication.swift
//  JellyGarden
//
//  Created by zzy on 2018/5/31.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import UserNotifications
class OtherApplication: NSObject,WXApiDelegate,JPUSHRegisterDelegate,RCIMUserInfoDataSource,RCIMGroupMemberDataSource {
    static var share = OtherApplication()
    private override init() {
        
    }
    
    func setYumeng()
    {
        UMSocialManager.default().umSocialAppkey = UMengKey
        
        UMSocialManager.default().setPlaform(.wechatSession, appKey: WeiChatShareKey, appSecret: WeiChatShareScrete, redirectURL: "")
        
        UMSocialManager.default().setPlaform(.QQ, appKey: QQShareKey, appSecret: QQShareSecrete, redirectURL: "")
        
        UMSocialManager.default().setPlaform(.sina, appKey: WeiBoShareKey, appSecret: weiBoShareSecret, redirectURL: "必须要和你在新浪微博后台设置的回调地址一致")
    }
    func setRongIM () {
        //设置appkey
        RCIM.shared().enablePersistentUserInfoCache = true
        RCIM.shared().userInfoDataSource = self
        RCIM.shared().groupMemberDataSource = self
        RCIM.shared().initWithAppKey(RongIMKey)
        
        //链接融云
        let tocken = ""//这个值从后台获取
        RCIM.shared().connect(withToken: tocken, success: { (resultInfo) in
            DebugLog(message: "登录融云成功");
            DispatchQueue.main.async {//回主线程操作
                
            }
            
        }, error: { (code) in
            
        }) {
            
        }
    }
    func setJPushSetting() {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue) | UInt8(JPAuthorizationOptions.badge.rawValue) | UInt8(JPAuthorizationOptions.sound.rawValue))
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//        if ( @available(iOS 8.0,*))
//        {
//
//        }
        
        
        
        
    }
   
    
    //JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userinfo = response.notification.request.content.userInfo
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userinfo)
        }
        completionHandler()
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let info = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(info)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.badge.rawValue))
    }
    
    
    //RCIMUserInfoDataSource
    //获取用户信息
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        //此处查询用户信息 请求自己的后.co台
        let userInfo = RCUserInfo.init(userId: userId, name: "", portrait: "")
        completion(userInfo)
  
    }
    //支付  charge是后台请求的数据
    func pay(charge:String,complection:@escaping (Bool) ->Void) {
        Pingpp.createPayment(charge as NSObject, viewController: RootNav().topViewController, appURLScheme: "JellyGarden") { (result, error) in
            guard error == nil else {
                AlertViewCoustom().showalertView(style: .alert, title: alertTitle, message: "\(error.debugDescription)", cancelBtnTitle: alertConfirm, touchIndex: { (index) in
                }, otherButtonTitles: nil)
                complection(false)
                return
            }
            complection(true)
        }
    }
    
}
