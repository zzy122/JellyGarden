//
//  AlertViewCoustom.swift
//
//  Created by zzy on 2018/4/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

enum ShowAlertStyle : Int {
    case actionSheet
    case alert
}


class AlertViewCoustom: NSObject, UIAlertViewDelegate, UIActionSheetDelegate {
    typealias ClickIndex = (Int) -> Void
    
    var touchIndex:ClickIndex?
    
    
    func showalertView(style:UIAlertControllerStyle, title:String?, message:String?, cancelBtnTitle:String?, touchIndex:@escaping ClickIndex, otherButtonTitles otherTitle:String?, _ moreButtonTitles: String...) {
        
        self.touchIndex = touchIndex;
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
            var count = 0
            
            if let cancelTitle = cancelBtnTitle {
               self.addAction(index: count, alertVC: alertController, style: UIAlertActionStyle.cancel, title: cancelTitle)
                count += 1
            }
            
            if let other = otherTitle, other.count > 0
            {
                self.addAction(index: count, alertVC: alertController, style: UIAlertActionStyle.default, title: other)
                count += 1
            }
            if moreButtonTitles.count > 0 {
                for otherIndex in 0 ..< moreButtonTitles.count
                {
                    self.addAction(index: count, alertVC: alertController, style: UIAlertActionStyle.default, title: moreButtonTitles[otherIndex])
                    count += 1
                }
            }
            
            self.currentViewController()?.present(alertController, animated: true, completion: {
                
            })
        }
        else
        {
            
            let alertView = UIAlertView.init(title: title ?? "", message: message ?? "", delegate: self, cancelButtonTitle: cancelBtnTitle, otherButtonTitles:"")
            for otherIndex in 0 ..< moreButtonTitles.count
            {
                alertView.addButton(withTitle: moreButtonTitles[otherIndex])
            }
            
            switch style{
            case .alert:
                alertView.show()
                break
            case .actionSheet:
                
                let alertSheet = UIActionSheet.init(title: title, delegate: self, cancelButtonTitle: cancelBtnTitle, destructiveButtonTitle: nil, otherButtonTitles: "")
                for otherIndex in 0 ..< moreButtonTitles.count
                {
                    alertSheet.addButton(withTitle: moreButtonTitles[otherIndex])
                }
                alertSheet.actionSheetStyle = UIActionSheetStyle.default
                alertSheet.show(in: (self.currentViewController()?.view)!)

                 break
                
            }
            
        }
        
    }
    
    func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    func addAction(index:Int, alertVC:UIAlertController, style:UIAlertActionStyle, title:String) {
        let alertCancel = UIAlertAction.init(title: title, style: style, handler: { (action) in
            self.clickAlert(Index: index, alertVC:alertVC)
        })
        
        alertVC.addAction(alertCancel)
    }
    func clickAlert(Index:Int, alertVC:UIAlertController)  {
        self.touchIndex!(Index)
        alertVC.dismiss(animated: true) {
            
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.touchIndex!(buttonIndex)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        self.touchIndex!(buttonIndex)
    }
    
    
}


