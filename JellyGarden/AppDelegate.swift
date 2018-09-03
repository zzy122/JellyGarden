//
//  AppDelegate.swift
//  JellyGarden
//
//  Created by zzy on 2018/5/31.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //设置友盟
        let nav = CustomNavigationViewController.init(rootViewController: FinishViewController())
        
        self.window = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.window?.backgroundColor = customBackViewColor
        self.setRootViewController(vc: nav)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        OtherApplication.share.setYumeng()
        OtherApplication.share.setRongIM()
        
        OtherApplication.share.setJPushSetting()
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: JPushChannel, apsForProduction: false)//开发环境
        //jpush自定义消息
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        // Override point for customization after application launch.
        
        WXApi.registerApp(WeiChatShareKey)
        
        return true
    }
    
    
    @objc func networkDidReceiveMessage(notification:NSNotification){//自定义的消息
        DebugLog(message: "收到的通知:\(String(describing: notification.userInfo))")
        APPNotyfyDealwith.share.addNotifyInfo(info: notification.userInfo?["content"] as? [String : Any])
    }
    func setRootViewController(vc:UIViewController) {
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        if let root = vc as? BaseTabBarViewController {
            RootViewController = root
        }
    }
    //ios9之前
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var result = RCIM.shared().openExtensionModuleUrl(url)
        if (!result) {
            result = UMSocialManager.default().handleOpen(url)
        }
        
        if (!result) {
            result = OtherApplication.share.handleUrl(url)
        }
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (result) in
                print("支付宝钱包回调结果")
            }
        }
        return result
    }
    
    //ios9之后
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var result = RCIM.shared().openExtensionModuleUrl(url)
        if (!result) {
            result = UMSocialManager.default().handleOpen(url)
        }
        
        if (!result) {
            result = OtherApplication.share.handleUrl(url)
        }
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (result) in
                print("支付宝钱包回调结果")
            }
        }
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        var result = RCIM.shared().openExtensionModuleUrl(url)
        if (!result) {
            result = UMSocialManager.default().handleOpen(url)
        }
        
        if (!result) {
            result = OtherApplication.share.handleUrl(url)
        }
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (result) in
                print("支付宝钱包回调结果")
            }
        }
        return result
    }
    
    /**
     收到推送的回调
     @param application  UIApplication 实例
     @param userInfo 推送时指定的参数
     @param completionHandler 完成回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.setBadge(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let password =  UserDefaults.standard.object(forKey: "GesterPassword") as? String ,password.count > 0 {
            if NeedGesterPassword {
                if (RootNav().topViewController?.isKind(of: CSIIGesturePasswordController.self))! {
                    return
                }
                
                let  gesterVC =  CSIIGesturePasswordController().initwithType(InitializeType.login, withState: { (success) in
                    if success {

                    }
                })
                
                gesterVC?.gesturePasswordView.logoimgView.sd_DownLoadImage(url: CurrentUserInfo?.avatar ?? "")
                RootViewController?.present(gesterVC!, animated: true, completion: nil)
            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

