//
//  OtherApplication.swift
//  JellyGarden
//
//  Created by zzy on 2018/5/31.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

import UserNotifications

class OtherApplication: NSObject, WXApiDelegate, RCIMUserInfoDataSource, RCIMGroupMemberDataSource, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate, JPUSHRegisterDelegate {

    static var share = OtherApplication()
    
    private override init() {}
    
    func setYumeng() {
        UMConfigure.initWithAppkey(UMengKey, channel: nil)
        
        UMSocialManager.default().setPlaform(.wechatSession, appKey: WeiChatShareKey, appSecret: WeiChatShareScrete, redirectURL: "")
        
        UMSocialManager.default().setPlaform(.QQ, appKey: QQShareKey, appSecret: QQShareSecrete, redirectURL: "http://www.qq.com/music.html")
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey(UMengKey, channel: "App Store")
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
        RCIM.shared().setScheme("jg072423", forExtensionModule: "JrmfPacketManager")
        RCIM.shared().registerMessageType(DepositMessage.self)
        RCIM.shared().registerMessageType(TagStatueMessage.self)
        RCIM.shared().registerMessageType(ReadDestroyMessage.self)
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
    }
    
    func setJPushSetting() {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue) | UInt8(JPAuthorizationOptions.badge.rawValue) | UInt8(JPAuthorizationOptions.sound.rawValue))
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
    }
    
    func connectRongyun(token:String,complectiom:@escaping (Bool) -> Void) {
        RCIM.shared().connect(withToken: token, success: { (resultInfo) in
            DebugLog(message: "登录融云成功");
            DispatchQueue.main.async {//回主线程操作
                RCIM.shared().userInfoDataSource = self
                let model = RCUserInfo.init(userId: CurrentUserInfo?.user_id ?? "", name: CurrentUserInfo?.nickname, portrait: CurrentUserInfo?.avatar);
                RCIM.shared().currentUserInfo = model
                
                complectiom(true)
            }
        }, error: { (code) in
            complectiom(false)
        }) {
            complectiom(false)
        }
    }
   
    
    //JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userinfo = response.notification.request.content.userInfo
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {//后台挂起收到推送消息 点击推送消息进去之后执行
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
    
    
    //支付  charge是后台请求的数据
    func pay(VC: UIViewController, charge: String, complection: ((Bool) ->Void)?) {
        AlipaySDK.defaultService().payOrder(charge, fromScheme: "jg072423") { (result) in
            if result?["resultStatus"] as? Int == 9000 {
                /// 支付成功
                complection?(true)
            }
            else {
                complection?(false)
            }
        }
    }
    
    var wxpayCompletion: ((Bool) -> Void)?
    
    func pay(wechat partnerId: String,
             prepayId: String,
             package: String = "Sign=WxPay",
             nonceStr: String,
             timeStamp: UInt32,
             sign: String,
             param: [String: Any],
             completion: ((Bool) -> Void)?) {
        
        wxpayCompletion = completion
        
        let req = PayReq()
        req.partnerId = partnerId
        req.prepayId = prepayId
        req.package = package
        req.nonceStr = nonceStr
        req.timeStamp = timeStamp
        req.sign = sign
        
        WXApi.send(req)
    }
    
    func handleUrl(_ url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: BaseResp!) {
        if let resp = resp as? PayResp {
            if resp.errCode == WXSuccess.rawValue {
                /// 支付成功
                wxpayCompletion?(true)
            }
            else {
                wxpayCompletion?(false)
                /// 支付失败
            }
        }
    }
}

//RCIMConnectionStatusDelegate
extension OtherApplication {
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        print("与融云连接状态发生改变 status = \(status)")
    }
    
    //RCIMUserInfoDataSource
    //获取用户信息
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        //此处查询用户信息 请求自己的后.co台
        TargetManager.share.getDetailUserInfo(userid: userId, isUpdateUser: false) { (model, error) in
            guard let userModel = model else{
                completion(nil)
                return
            }
            let userInfo = RCUserInfo.init(userId: userModel.user_id, name: userModel.nickname , portrait: userModel.avatar)
            completion(userInfo)
        }
    }

    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if message.content.isMember(of: RCInformationNotificationMessage.self) {
            let msg:RCInformationNotificationMessage =  RCInformationNotificationMessage.notification(withMessage: message.content.conversationDigest(), extra: message.extra)
        }
    }
}
