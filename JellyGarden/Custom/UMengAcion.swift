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
        UMSocialUIManager.setPreDefinePlatforms([NSNumber.init(value: Int8(UMSocialPlatformType.QQ.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.qzone.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatSession.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatTimeLine.rawValue))])
        
        
        UMSocialUIManager.showShareMenuViewInWindow {(platformType, shreMenuView) in

            let shareObject:UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: "分享title", descr: "描述问题", thumImage: placeImage)
            shareObject.webpageUrl = "www.baidu.com"
            
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.shareObject = shareObject;
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: RootViewController, completion: { (shareResponse, error) in
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
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: RootViewController, completion: { (result:Any?, error:Error?) in
            if let userinfo  = result as? UMSocialUserInfoResponse {
                let message = " name: \(userinfo.name)\n icon: \(userinfo.iconurl)\n gender: \(userinfo.gender)\n"
                print(message)
                AlertViewCoustom().showalertView(style: UIAlertControllerStyle.alert, title: alertTitle, message: message, cancelBtnTitle: alertConfirm, touchIndex: { (index) in
                    
                }, otherButtonTitles: nil);
                
            }
        })
    }
    //三方登录
    class func uMengLogin(type:UMSocialPlatformType,nav:UINavigationController?, loginSuccess:@escaping (Bool) -> Void) {
        UMSocialDataManager.default().clearAllAuthorUserInfo()
        UMSocialManager.default().getUserInfo(with: type, currentViewController: TopViewContoller()) { (result, error) in
            
            
            guard let userResult = result as? UMSocialUserInfoResponse else {
               
                alertHud(title: "\(String(describing: error?.localizedDescription))")
                return
            }
            DispatchQueue.main.async {
                 loginSuccess(true)
                var params:[String:Any] = ["open_id":userResult.openid,"avatar":userResult.iconurl,"nickname":userResult.name]
                switch type
                {
                    
                case .unKnown:
                    
                    break
                case .QQ:
                    params["platform"] = "qq"
                    break
                case .sina:
                    params["platform"] = "weibo"
                    break
                case .wechatSession:
                    params["platform"] = "wx"
                    break
                case .wechatTimeLine:
                    params["platform"] = "wx"
                    break
                case .wechatFavorite:
                    params["platform"] = "wx"
                    break
                case .qzone:
                    params["platform"] = "qq"
                    break
                default:
                    break
               
                }
                thirdLoginParams(params: params,  nav: nav)
            }
            
           
            //使用userResult登录
            
        }
    }
}
//分享

