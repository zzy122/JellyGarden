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
        //

        OtherApplication.share.setYumeng()
        OtherApplication.share.setRongIM()
        
        OtherApplication.share.setJPushSetting()
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: JPushChannel, apsForProduction: false)//开发环境
        //jpush自定义消息
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        // Override point for customization after application launch.
        
        testAliPay()
        return true
    }
    
    func testAliPay() {
        AlipaySDK.defaultService().payOrder("alipay_sdk=alipay-sdk-php-20180705&app_id=2018060460264651&biz_content=%7B%22body%22%3A%22%E7%94%A8%E6%88%B7%E9%92%B1%E5%8C%85%E5%85%85%E5%80%BC%22%2C%22subject%22%3A+%22%E7%94%A8%E6%88%B7%E9%92%B1%E5%8C%85%E5%85%85%E5%80%BC%22%2C%22out_trade_no%22%3A+%221234gh56789%22%2C%22timeout_express%22%3A+%22300m%22%2C%22total_amount%22%3A+%220.01%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fwww.18huyu.com%2Fadmin%2Fvideo%2Fnotify&sign_type=RSA2&timestamp=2018-08-27+16%3A59%3A10&version=1.0&sign=2h1z1dga9K6i03EPhuWgOF7CjTewF%2FpNB1pAeUgMLrgb4Oc0XyG7qL2pWN6Cu%2Fy%2FCfig04bqgi%2FjD3lKYjPcf6FiAEMWa%2FKcLtWXffzxczcX4I6T5VvYl716V3uqdk7HC2PTjYMgaunPcXYmHqZjAIc%2BSFIrL%2BBoSctWh8QPDCRxN4gRGdvOj3AM7dOUiPIa5OBrKyNHMElq3uR%2B0EocpMf%2BeYw9E9nfWIkI4ntUiO%2Fu6P3bDOqSpdUwev%2BtU92iUaiT%2FFj18sgadRnC%2FiG%2BZJy6CRMtITHXrK8SaCZG6RF%2Fl1waj%2BwaW5Vk4YRmPQY3q60RFSWs%2BByjT06yOysuyg%3D%3D", fromScheme: "cn.com.JellyGarden", callback: { (result) in
            print("\(result)")
        })
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
       if (RCIM.shared().openExtensionModuleUrl(url))
       {
            return true
        }
        
        if (Pingpp.handleOpen(url, withCompletion: nil)) {//收到支付结果通知
            return true;
        }
        let  result = UMSocialManager.default().handleOpen(url)
        return result
      
    }
    //ios9之后
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (RCIM.shared().openExtensionModuleUrl(url))
        {
            return true
        }
        if (Pingpp.handleOpen(url, withCompletion: nil)) {////要跳转支付宝或者微信的通知
            return true;
        }
        
        let  result = UMSocialManager.default().handleOpen(url)
        return result
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        return result
    }
    /**
     收到推送的回调
     @param application  UIApplication 实例
     @param userInfo 推送时指定的参数
     @param completionHandler 完成回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        DebugLog(message: "收到推送消息的内容:\(userInfo.description)")
        
        
        
        
        
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
        
       
        if let password =  UserDefaults.standard.object(forKey: "GesterPassword") as? String ,password.count > 0
        {
            if NeedGesterPassword
            {
                if (RootNav().topViewController?.isKind(of: CSIIGesturePasswordController.self))!
                {
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

