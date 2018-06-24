//
//  OtherApplication.swift
//  JellyGarden
//
//  Created by zzy on 2018/5/31.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import UserNotifications
class OtherApplication: NSObject,WXApiDelegate,JPUSHRegisterDelegate,RCIMUserInfoDataSource,RCIMGroupMemberDataSource,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate {
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
//        RCIM.shared().groupInfoDataSource = self
        RCIM.shared().groupMemberDataSource = self
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared().enableTypingStatus = true
        RCIM.shared().connectionStatusDelegate = self
        RCIM.shared().initWithAppKey(RongIMKey)
        RCIM.shared().registerMessageType(DepositMessage.self)
        RCIM.shared().registerMessageType(TagStatueMessage.self)
        //开启发送已读回执
        RCIM.shared().enabledReadReceiptConversationTypeList = [NSNumber.init(value: UInt8(RCConversationType.ConversationType_PRIVATE.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_DISCUSSION.rawValue)),NSNumber.init(value: UInt8(RCConversationType.ConversationType_GROUP.rawValue))]
        //链接融云
        //开启多端未读状态同步
        RCIM.shared().enableSyncReadStatus = true
        //设置显示未注册的消息
        //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
        RCIM.shared().showUnkownMessage = true
        RCIM.shared().showUnkownMessageNotificaiton = true
        //群成员数据源
        RCIM.shared().groupMemberDataSource = self
        //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
        RCIM.shared().enableMessageMentioned = true
        //开启消息撤回功能
        RCIM.shared().enableMessageRecall = true
//        "http:ggdhah"
        let tocken = "HlMfHYJvmEo44W/F61LuabRpUvcyPvtcBAE1MtjZHcdpH5OG47jQeT0W+LiJ7xaXIo0E1Fqz0Ymon0nAvrYU9OIT31DubvNL"//这个值从后台获取/BXSBnDD+hltcIS814LpyrRpUvcyPvtcBAE1MtjZHcdpH5OG47jQef897cW8KqvRjWjSrSRDTIWon0nAvrYU9GXAL9HR+6f1  HlMfHYJvmEo44W/F61LuabRpUvcyPvtcBAE1MtjZHcdpH5OG47jQeT0W+LiJ7xaXIo0E1Fqz0Ymon0nAvrYU9OIT31DubvNL
        RCIM.shared().connect(withToken: tocken, success: { (resultInfo) in
            DebugLog(message: "登录融云成功");
            DispatchQueue.main.async {//回主线程操作
                RCIM.shared().userInfoDataSource = self
                let model = RCUserInfo.init(userId: "18980898159", name: "zzy123", portrait: "ggggg");
                RCIM.shared().currentUserInfo = model
                
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

extension OtherApplication//RCIMConnectionStatusDelegate
{
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        print("与融云连接状态发生改变")
    }
//    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
//        if (groupId.count == 0) { return}
//
//        //请求自己的服务器得到group的信息
//        completion(RCDGroupInfo())
//    }
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if message.content.isMember(of: RCInformationNotificationMessage.self) {
            let msg:RCInformationNotificationMessage =  RCInformationNotificationMessage.notification(withMessage: message.content.conversationDigest(), extra: message.extra)
            print("appdelegate中接收到消息通知\(msg.message)")
        }
        
        //        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
        
    }
}
