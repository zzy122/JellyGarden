//
//  UMengAcion.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UMengAcion: NSObject {
    class func uMengShare() {
        
        UMSocialUIManager.showShareMenuViewInWindow {(platformType, shreMenuView) in
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "友盟分享测试(图片)，swift3.0 Xcode8.1 umeng6.0.3 作者：targetcloud"
            let shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.title = "图片分享"
            shareObject.descr = "这里是图片分享测试，作者：targetcloud"
            shareObject.thumbImage = UIImage.init(named: "icon")
            shareObject.shareImage = "http://dev.umeng.com/images/tab2_1.png"
            messageObject.shareObject = shareObject;
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) in
                if let error1 = error {
                    print("Share Fail with error ：%@", error1.localizedDescription)
                }else{
                    self.getUserInfoForPlatform(platformType: platformType)
                    print("Share succeed")
                }
            })
        }
    }
    class func getUserInfoForPlatform(platformType:UMSocialPlatformType){
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: TopViewContoller(), completion: { (result:Any?, error:Error?) in
            if let userinfo  = result as? UMSocialUserInfoResponse {
                let message = " name: \(userinfo.name)\n icon: \(userinfo.iconurl)\n gender: \(userinfo.gender)\n"
                print(message)
                AlertViewCoustom().showalertView(style: UIAlertControllerStyle.alert, title: alertTitle, message: message, cancelBtnTitle: alertConfirm, touchIndex: { (index) in
                    
                }, otherButtonTitles: nil);
                
            }
        })
    }
    //三方登录
    class func uMengLogin(type:UMSocialPlatformType, loginSuccess:@escaping (Bool) -> Void) {
        UMSocialDataManager.default().clearAllAuthorUserInfo()
        UMSocialManager.default().getUserInfo(with: type, currentViewController: TopViewContoller()) { (result, error) in
            
            
            guard let userResult = result as? UMSocialUserInfoResponse else {
                DebugLog(message: error?.localizedDescription)
                return
            }
            
            //使用userResult登录
            
        }
    }
}
//分享

