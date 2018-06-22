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
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: JPushChannel, apsForProduction: false)//开发环境
        
        
        OtherApplication.share.setYumeng()
//        OtherApplication.share.setWeiChatPay()
        // Override point for customization after application launch.
        return true
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
        if (Pingpp.handleOpen(url, withCompletion: nil)) {
            return true;
        }
        let  result = UMSocialManager.default().handleOpen(url)
        return result
      
    }
    //ios9之后
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (Pingpp.handleOpen(url, withCompletion: nil)) {
            return true;
        }
        
        let  result = UMSocialManager.default().handleOpen(url)
        return result
    }
    /**
     收到推送的回调
     @param application  UIApplication 实例
     @param userInfo 推送时指定的参数
     @param completionHandler 完成回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        DebugLog(message: "收到推送消息的内容:\(userInfo.description)")
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

